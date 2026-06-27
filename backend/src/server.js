import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { pool } from './config/db.js';
import { auth, adminOnly } from './middleware/auth.js';

const app = express();
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(morgan('tiny'));

const ok = (res, data) => res.json({ data });
const wrap = (fn) => (req, res, next) => fn(req, res, next).catch(next);

function requireFields(body, fields) {
  const missing = fields.filter((f) => body[f] === undefined || body[f] === null || body[f] === '');
  if (missing.length) throw Object.assign(new Error(`Missing required field(s): ${missing.join(', ')}`), { status: 400 });
}

app.get('/api/health', (_, res) => res.json({ status: 'ok' }));

app.post('/api/auth/login', wrap(async (req, res) => {
  requireFields(req.body, ['email', 'password']);
  const { email, password } = req.body;
  const [r] = await pool.query('SELECT * FROM users WHERE email=? AND is_active=1', [email]);
  const u = r[0];
  if (!u || !await bcrypt.compare(password, u.password_hash)) return res.status(401).json({ message: 'Invalid login' });
  const token = jwt.sign({ id: u.id, name: u.name, email: u.email, role: u.role }, process.env.JWT_SECRET || 'dev_secret', { expiresIn: '12h' });
  ok(res, { token, user: { id: u.id, name: u.name, email: u.email, role: u.role } });
}));

app.get('/api/dashboard', auth, wrap(async (req, res) => {
  const { from, to, villa_id, technician_id } = req.query;
  const where = [];
  const params = [];
  if (from) { where.push('r.record_date>=?'); params.push(from); }
  if (to) { where.push('r.record_date<=?'); params.push(to); }
  if (villa_id) { where.push('r.villa_id=?'); params.push(villa_id); }
  if (technician_id) { where.push('r.technician_id=?'); params.push(technician_id); }
  const whereSql = where.length ? `WHERE ${where.join(' AND ')}` : '';
  const andSql = where.length ? `AND ${where.join(' AND ')}` : '';

  const [[today]] = await pool.query(`SELECT COUNT(*) records, COALESCE(SUM(spare_part_cost),0) cost FROM maintenance_records WHERE record_date=CURDATE()`);
  const [[month]] = await pool.query(`SELECT COUNT(*) records, COALESCE(SUM(spare_part_cost),0) cost FROM maintenance_records WHERE YEAR(record_date)=YEAR(CURDATE()) AND MONTH(record_date)=MONTH(CURDATE())`);
  const [[filtered]] = await pool.query(`SELECT COUNT(*) records, COALESCE(SUM(r.spare_part_cost),0) cost FROM maintenance_records r ${whereSql}`, params);
  const [byTech] = await pool.query(`SELECT t.name, COUNT(r.id) total, COALESCE(SUM(r.spare_part_cost),0) cost FROM technicians t LEFT JOIN maintenance_records r ON r.technician_id=t.id ${andSql} GROUP BY t.id ORDER BY total DESC LIMIT 8`, params);
  const [byVilla] = await pool.query(`SELECT v.name, COUNT(r.id) total, COALESCE(SUM(r.spare_part_cost),0) cost FROM villas v LEFT JOIN maintenance_records r ON r.villa_id=v.id ${andSql} GROUP BY v.id ORDER BY total DESC LIMIT 8`, params);
  const [recent] = await pool.query(`SELECT r.*,v.name villa_name,a.apartment_no,t.name technician_name FROM maintenance_records r JOIN villas v ON v.id=r.villa_id JOIN apartments a ON a.id=r.apartment_id JOIN technicians t ON t.id=r.technician_id ${whereSql} ORDER BY r.record_date DESC,r.id DESC LIMIT 10`, params);
  ok(res, { today, month, filtered, byTech, byVilla, recent });
}));

function crud(name, table, fields, required = []) {
  app.get(`/api/${name}`, auth, wrap(async (req, res) => {
    const [rows] = await pool.query(`SELECT * FROM ${table} ORDER BY id DESC`);
    ok(res, rows);
  }));
  app.post(`/api/${name}`, auth, wrap(async (req, res) => {
    requireFields(req.body, required);
    const data = {};
    fields.forEach((f) => { if (req.body[f] !== undefined) data[f] = req.body[f]; });
    const [r] = await pool.query(`INSERT INTO ${table} SET ?`, data);
    ok(res, { id: r.insertId, ...data });
  }));
  app.put(`/api/${name}/:id`, auth, wrap(async (req, res) => {
    const data = {};
    fields.forEach((f) => { if (req.body[f] !== undefined) data[f] = req.body[f]; });
    if (Object.keys(data).length === 0) throw Object.assign(new Error('No fields to update'), { status: 400 });
    await pool.query(`UPDATE ${table} SET ? WHERE id=?`, [data, req.params.id]);
    ok(res, { id: req.params.id, ...data });
  }));
  app.delete(`/api/${name}/:id`, auth, adminOnly, wrap(async (req, res) => {
    await pool.query(`DELETE FROM ${table} WHERE id=?`, [req.params.id]);
    ok(res, { deleted: true });
  }));
}

crud('villas', 'villas', ['name', 'area', 'notes', 'is_active'], ['name']);
crud('technicians', 'technicians', ['name', 'specialty', 'phone', 'notes', 'is_active'], ['name']);

app.get('/api/apartments', auth, wrap(async (req, res) => {
  const q = req.query.villa_id ? 'WHERE a.villa_id=?' : '';
  const params = req.query.villa_id ? [req.query.villa_id] : [];
  const [rows] = await pool.query(`SELECT a.*,v.name villa_name FROM apartments a JOIN villas v ON v.id=a.villa_id ${q} ORDER BY v.name,a.apartment_no`, params);
  ok(res, rows);
}));
app.post('/api/apartments', auth, wrap(async (req, res) => {
  requireFields(req.body, ['villa_id', 'apartment_no']);
  const { villa_id, apartment_no, floor, notes, is_active } = req.body;
  const [r] = await pool.query('INSERT INTO apartments SET ?', { villa_id, apartment_no, floor, notes, is_active: is_active ?? 1 });
  ok(res, { id: r.insertId });
}));
app.put('/api/apartments/:id', auth, wrap(async (req, res) => {
  if (Object.keys(req.body).length === 0) throw Object.assign(new Error('No fields to update'), { status: 400 });
  await pool.query('UPDATE apartments SET ? WHERE id=?', [req.body, req.params.id]);
  ok(res, { id: req.params.id });
}));
app.delete('/api/apartments/:id', auth, adminOnly, wrap(async (req, res) => {
  await pool.query('DELETE FROM apartments WHERE id=?', [req.params.id]);
  ok(res, { deleted: true });
}));

app.get('/api/users', auth, adminOnly, wrap(async (req, res) => {
  const [rows] = await pool.query('SELECT id,name,email,role,is_active,created_at FROM users ORDER BY id DESC');
  ok(res, rows);
}));
app.post('/api/users', auth, adminOnly, wrap(async (req, res) => {
  requireFields(req.body, ['name', 'email']);
  const { name, email, password, role, is_active } = req.body;
  const password_hash = await bcrypt.hash(password || 'User@12345', 10);
  const [r] = await pool.query('INSERT INTO users SET ?', { name, email, password_hash, role: role || 'SUPERVISOR', is_active: is_active ?? 1 });
  ok(res, { id: r.insertId });
}));
app.put('/api/users/:id', auth, adminOnly, wrap(async (req, res) => {
  requireFields(req.body, ['name', 'email']);
  const { name, email, password, role, is_active } = req.body;
  const data = { name, email, role: role || 'SUPERVISOR', is_active: is_active ?? 1 };
  if (password) data.password_hash = await bcrypt.hash(password, 10);
  await pool.query('UPDATE users SET ? WHERE id=?', [data, req.params.id]);
  ok(res, { id: req.params.id });
}));
app.delete('/api/users/:id', auth, adminOnly, wrap(async (req, res) => {
  if (Number(req.params.id) === req.user.id) throw Object.assign(new Error('لا يمكنك حذف حسابك الحالي'), { status: 400 });
  await pool.query('DELETE FROM users WHERE id=?', [req.params.id]);
  ok(res, { deleted: true });
}));

app.get('/api/records', auth, wrap(async (req, res) => {
  const where = [];
  const p = [];
  ['record_date', 'villa_id', 'apartment_id', 'technician_id'].forEach((f) => {
    if (req.query[f]) { where.push(`r.${f}=?`); p.push(req.query[f]); }
  });
  const sql = `SELECT r.*,v.name villa_name,a.apartment_no,u.name created_by_name,
    GROUP_CONCAT(DISTINCT t.name ORDER BY t.name SEPARATOR '، ') technician_name,
    GROUP_CONCAT(DISTINCT t.id) technician_ids
    FROM maintenance_records r
    JOIN villas v ON v.id=r.villa_id
    JOIN apartments a ON a.id=r.apartment_id
    LEFT JOIN users u ON u.id=r.created_by
    LEFT JOIN record_technicians rt ON rt.record_id=r.id
    LEFT JOIN technicians t ON t.id=rt.technician_id
    ${where.length ? 'WHERE ' + where.join(' AND ') : ''}
    GROUP BY r.id ORDER BY r.record_date DESC,r.id DESC`;
  const [rows] = await pool.query(sql, p);
  ok(res, rows);
}));
app.post('/api/records', auth, wrap(async (req, res) => {
  requireFields(req.body, ['record_date', 'villa_id', 'apartment_id', 'description']);
  const technicianIds = req.body.technician_ids?.length ? req.body.technician_ids : (req.body.technician_id ? [req.body.technician_id] : []);
  if (!technicianIds.length) throw Object.assign(new Error('يجب اختيار فني واحد على الأقل'), { status: 400 });
  const { technician_ids, ...rest } = req.body;
  const data = { ...rest, technician_id: technicianIds[0], created_by: req.user.id };
  const [r] = await pool.query('INSERT INTO maintenance_records SET ?', data);
  await pool.query('INSERT INTO record_technicians (record_id, technician_id) VALUES ?', [technicianIds.map((tid) => [r.insertId, tid])]);
  ok(res, { id: r.insertId });
}));
app.put('/api/records/:id', auth, wrap(async (req, res) => {
  if (Object.keys(req.body).length === 0) throw Object.assign(new Error('No fields to update'), { status: 400 });
  const { technician_ids, ...rest } = req.body;
  const data = { ...rest };
  if (technician_ids?.length) data.technician_id = technician_ids[0];
  if (Object.keys(data).length) await pool.query('UPDATE maintenance_records SET ? WHERE id=?', [data, req.params.id]);
  if (technician_ids?.length) {
    await pool.query('DELETE FROM record_technicians WHERE record_id=?', [req.params.id]);
    await pool.query('INSERT INTO record_technicians (record_id, technician_id) VALUES ?', [technician_ids.map((tid) => [req.params.id, tid])]);
  }
  ok(res, { id: req.params.id });
}));
app.delete('/api/records/:id', auth, adminOnly, wrap(async (req, res) => {
  await pool.query('DELETE FROM maintenance_records WHERE id=?', [req.params.id]);
  ok(res, { deleted: true });
}));

app.get('/api/reports/summary', auth, wrap(async (req, res) => {
  const from = req.query.from || '2000-01-01', to = req.query.to || '2999-12-31';
  const [rows] = await pool.query(`SELECT record_date, COUNT(*) total_records, COALESCE(SUM(spare_part_cost),0) total_cost FROM maintenance_records WHERE record_date BETWEEN ? AND ? GROUP BY record_date ORDER BY record_date DESC`, [from, to]);
  ok(res, rows);
}));

app.use((req, res) => res.status(404).json({ message: 'Not found' }));

app.use((err, req, res, next) => {
  const status = err.status || (err.code === 'ER_DUP_ENTRY' ? 409 : err.code === 'ER_NO_REFERENCED_ROW_2' ? 400 : 500);
  if (status === 500) console.error(err);
  res.status(status).json({ message: status === 500 ? 'Internal server error' : err.sqlMessage || err.message });
});

process.on('unhandledRejection', (err) => console.error('Unhandled rejection:', err));

app.listen(process.env.PORT || 4000, () => console.log('API running'));

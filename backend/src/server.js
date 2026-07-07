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

  // Maintenance KPIs
  const [[today]] = await pool.query(`SELECT COUNT(*) records, COALESCE(SUM(spare_part_cost),0) cost FROM maintenance_records WHERE record_date=CURDATE()`);
  const [[month]] = await pool.query(`SELECT COUNT(*) records, COALESCE(SUM(spare_part_cost),0) cost FROM maintenance_records WHERE YEAR(record_date)=YEAR(CURDATE()) AND MONTH(record_date)=MONTH(CURDATE())`);
  const [[filtered]] = await pool.query(`SELECT COUNT(*) records, COALESCE(SUM(r.spare_part_cost),0) cost FROM maintenance_records r ${whereSql}`, params);
  const [byTech] = await pool.query(`SELECT t.name, COUNT(r.id) total, COALESCE(SUM(r.spare_part_cost),0) cost FROM technicians t LEFT JOIN maintenance_records r ON r.technician_id=t.id ${andSql} GROUP BY t.id ORDER BY total DESC LIMIT 8`, params);
  const [byVilla] = await pool.query(`SELECT v.name, COUNT(r.id) total, COALESCE(SUM(r.spare_part_cost),0) cost FROM villas v LEFT JOIN maintenance_records r ON r.villa_id=v.id ${andSql} GROUP BY v.id ORDER BY total DESC LIMIT 8`, params);
  const [recent] = await pool.query(`SELECT r.id,r.record_date,r.description,r.spare_part_cost,r.issue_type,v.name villa_name,a.apartment_no,t.name technician_name FROM maintenance_records r JOIN villas v ON v.id=r.villa_id LEFT JOIN apartments a ON a.id=r.apartment_id JOIN technicians t ON t.id=r.technician_id ${whereSql} ORDER BY r.record_date DESC,r.id DESC LIMIT 8`, params);

  // Last 6 months trend (maintenance records count per month)
  const [monthlyTrend] = await pool.query(`
    SELECT DATE_FORMAT(record_date,'%Y-%m') mo, COUNT(*) cnt, COALESCE(SUM(spare_part_cost),0) cost
    FROM maintenance_records WHERE record_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
    GROUP BY mo ORDER BY mo ASC`);

  // Lease / financial KPIs
  const [[leaseKpi]] = await pool.query(`
    SELECT
      COUNT(DISTINCT l.id) total_leases,
      SUM(CASE WHEN l.is_active=1 THEN 1 ELSE 0 END) active_leases,
      COUNT(DISTINCT t.id) total_tenants
    FROM leases l JOIN tenants t ON t.id=l.tenant_id`);

  const [[installmentKpi]] = await pool.query(`
    SELECT
      COALESCE(SUM(CASE
        WHEN COALESCE(ip_sum.collected,0)<li.amount AND li.due_date<CURDATE() THEN li.amount-COALESCE(ip_sum.collected,0)
        ELSE 0 END),0) overdue_amount,
      COUNT(CASE
        WHEN COALESCE(ip_sum.collected,0)<li.amount AND li.due_date<CURDATE() THEN 1 END) overdue_count,
      COALESCE(SUM(CASE
        WHEN ip_sum.collected>=li.amount THEN li.amount ELSE 0 END),0) collected_total,
      COALESCE(SUM(CASE
        WHEN li.due_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(),INTERVAL 30 DAY)
          AND COALESCE(ip_sum.collected,0)<li.amount THEN li.amount-COALESCE(ip_sum.collected,0)
        ELSE 0 END),0) due_soon_amount,
      COALESCE(SUM(CASE
        WHEN YEAR(ip_pmt.payment_date)=YEAR(CURDATE()) AND MONTH(ip_pmt.payment_date)=MONTH(CURDATE())
        THEN ip_pmt.amount ELSE 0 END),0) collected_this_month
    FROM lease_installments li
    LEFT JOIN (SELECT installment_id, SUM(amount) collected FROM installment_payments GROUP BY installment_id) ip_sum ON ip_sum.installment_id=li.id
    LEFT JOIN installment_payments ip_pmt ON ip_pmt.installment_id=li.id`);

  // Apartment occupancy — derived from active leases, not manual field
  const [[aptKpi]] = await pool.query(`
    SELECT
      COUNT(*) total,
      SUM(EXISTS(SELECT 1 FROM leases l WHERE l.apartment_id=a.id AND l.is_active=1)) rented,
      SUM(NOT EXISTS(SELECT 1 FROM leases l WHERE l.apartment_id=a.id AND l.is_active=1)) available
    FROM apartments a WHERE a.is_active=1`);

  // Overdue installments list (top 5)
  const [overdueList] = await pool.query(`
    SELECT li.id, li.due_date, li.amount, COALESCE(SUM(ip.amount),0) collected,
      t.name tenant_name, v.name villa_name, a.apartment_no
    FROM lease_installments li
    JOIN leases l ON l.id=li.lease_id
    JOIN apartments a ON a.id=l.apartment_id
    JOIN villas v ON v.id=a.villa_id
    JOIN tenants t ON t.id=l.tenant_id
    LEFT JOIN installment_payments ip ON ip.installment_id=li.id
    WHERE li.due_date<CURDATE()
    GROUP BY li.id
    HAVING collected<li.amount
    ORDER BY li.due_date ASC LIMIT 5`);

  ok(res, { today, month, filtered, byTech, byVilla, recent, monthlyTrend, leaseKpi, installmentKpi, aptKpi, overdueList });
}));

function pageGuard(pageId) {
  return wrap(async (req, res, next) => {
    if (req.user.role === 'ADMIN') return next();
    const [[row]] = await pool.query('SELECT allowed_pages FROM role_permissions WHERE role=?', [req.user.role]);
    const allowed = row ? (typeof row.allowed_pages === 'string' ? JSON.parse(row.allowed_pages) : row.allowed_pages) : [];
    if (!allowed.includes(pageId)) throw Object.assign(new Error('ليس لديك صلاحية الوصول لهذه الصفحة'), { status: 403 });
    next();
  });
}

app.get('/api/permissions', auth, wrap(async (req, res) => {
  const [rows] = await pool.query('SELECT role, allowed_pages FROM role_permissions');
  const map = {};
  rows.forEach((r) => { map[r.role] = typeof r.allowed_pages === 'string' ? JSON.parse(r.allowed_pages) : r.allowed_pages; });
  ok(res, map);
}));
app.put('/api/permissions/:role', auth, adminOnly, wrap(async (req, res) => {
  const { allowed_pages } = req.body;
  if (!Array.isArray(allowed_pages)) throw Object.assign(new Error('allowed_pages must be an array'), { status: 400 });
  await pool.query('INSERT INTO role_permissions (role, allowed_pages) VALUES (?,?) ON DUPLICATE KEY UPDATE allowed_pages=?', [req.params.role, JSON.stringify(allowed_pages), JSON.stringify(allowed_pages)]);
  ok(res, { role: req.params.role, allowed_pages });
}));

function crud(name, table, fields, required = [], pageId = null) {
  app.get(`/api/${name}`, auth, ...(pageId ? [pageGuard(pageId)] : []), wrap(async (req, res) => {
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
  const [rows] = await pool.query(`
    SELECT a.*, v.name villa_name,
      CASE WHEN EXISTS(
        SELECT 1 FROM leases l
        WHERE l.apartment_id=a.id AND l.is_active=1
      ) THEN 'rented' ELSE 'available' END AS rental_status
    FROM apartments a
    JOIN villas v ON v.id=a.villa_id
    ${q} ORDER BY v.name, a.apartment_no`, params);
  ok(res, rows);
}));
app.post('/api/apartments', auth, wrap(async (req, res) => {
  requireFields(req.body, ['villa_id', 'apartment_no']);
  const { villa_id, apartment_no, apt_type, bathrooms, has_balcony, rental_status, floor, notes, is_active } = req.body;
  const [r] = await pool.query('INSERT INTO apartments SET ?', {
    villa_id, apartment_no, apt_type: apt_type || null,
    bathrooms: bathrooms ?? 1, has_balcony: has_balcony ? 1 : 0,
    rental_status: rental_status || 'available', floor, notes, is_active: is_active ?? 1
  });
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
  const [[{ adminCount }]] = await pool.query(`SELECT COUNT(*) adminCount FROM users WHERE role='ADMIN' AND is_active=1`);
  if (adminCount <= 1) {
    const [[target]] = await pool.query('SELECT role FROM users WHERE id=?', [req.params.id]);
    if (target?.role === 'ADMIN') throw Object.assign(new Error('لا يمكن حذف آخر مدير في النظام'), { status: 400 });
  }
  await pool.query('DELETE FROM users WHERE id=?', [req.params.id]);
  ok(res, { deleted: true });
}));

app.get('/api/records', auth, pageGuard('records'), wrap(async (req, res) => {
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
    LEFT JOIN apartments a ON a.id=r.apartment_id
    LEFT JOIN users u ON u.id=r.created_by
    LEFT JOIN record_technicians rt ON rt.record_id=r.id
    LEFT JOIN technicians t ON t.id=rt.technician_id
    ${where.length ? 'WHERE ' + where.join(' AND ') : ''}
    GROUP BY r.id ORDER BY r.record_date DESC,r.id DESC`;
  const [rows] = await pool.query(sql, p);
  ok(res, rows);
}));
app.post('/api/records', auth, wrap(async (req, res) => {
  requireFields(req.body, ['record_date', 'villa_id', 'description']);
  const technicianIds = req.body.technician_ids?.length ? req.body.technician_ids : (req.body.technician_id ? [req.body.technician_id] : []);
  if (!technicianIds.length) throw Object.assign(new Error('يجب اختيار فني واحد على الأقل'), { status: 400 });
  const cost = Number(req.body.spare_part_cost ?? 0);
  if (cost < 0) throw Object.assign(new Error('تكلفة قطعة الغيار لا يمكن أن تكون سالبة'), { status: 400 });
  const { technician_ids, ...rest } = req.body;
  const data = { ...rest, spare_part_cost: cost, apartment_id: rest.apartment_id || null, technician_id: technicianIds[0], created_by: req.user.id };
  const [r] = await pool.query('INSERT INTO maintenance_records SET ?', data);
  await pool.query('INSERT INTO record_technicians (record_id, technician_id) VALUES ?', [technicianIds.map((tid) => [r.insertId, tid])]);
  ok(res, { id: r.insertId });
}));
app.put('/api/records/:id', auth, wrap(async (req, res) => {
  if (Object.keys(req.body).length === 0) throw Object.assign(new Error('No fields to update'), { status: 400 });
  const { technician_ids, ...rest } = req.body;
  const data = { ...rest };
  if ('apartment_id' in data) data.apartment_id = data.apartment_id || null;
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

// ─── Tenants ──────────────────────────────────────────────────────────────
crud('tenants', 'tenants', ['name', 'phone', 'national_id', 'email', 'notes'], ['name'], 'tenants_mgmt');

// ─── Leases ───────────────────────────────────────────────────────────────
app.get('/api/leases', auth, pageGuard('leases'), wrap(async (req, res) => {
  const where = [];
  const p = [];
  if (req.query.apartment_id) { where.push('l.apartment_id=?'); p.push(req.query.apartment_id); }
  if (req.query.tenant_id) { where.push('l.tenant_id=?'); p.push(req.query.tenant_id); }
  if (req.query.is_active !== undefined) { where.push('l.is_active=?'); p.push(req.query.is_active); }
  const [rows] = await pool.query(`
    SELECT l.*, t.name tenant_name, t.phone tenant_phone,
      a.apartment_no, v.name villa_name,
      (SELECT COUNT(*) FROM lease_installments li WHERE li.lease_id=l.id) installments_count,
      (SELECT COALESCE(SUM(ip.amount),0) FROM lease_installments li JOIN installment_payments ip ON ip.installment_id=li.id WHERE li.lease_id=l.id) collected_amount
    FROM leases l
    JOIN tenants t ON t.id=l.tenant_id
    JOIN apartments a ON a.id=l.apartment_id
    JOIN villas v ON v.id=a.villa_id
    ${where.length ? 'WHERE ' + where.join(' AND ') : ''}
    ORDER BY l.id DESC`, p);
  ok(res, rows);
}));
app.get('/api/leases/:id', auth, pageGuard('leases'), wrap(async (req, res) => {
  const [[lease]] = await pool.query(`
    SELECT l.*, t.name tenant_name, t.phone tenant_phone,
      a.apartment_no, v.name villa_name
    FROM leases l
    JOIN tenants t ON t.id=l.tenant_id
    JOIN apartments a ON a.id=l.apartment_id
    JOIN villas v ON v.id=a.villa_id
    WHERE l.id=?`, [req.params.id]);
  if (!lease) throw Object.assign(new Error('Not found'), { status: 404 });
  const [installments] = await pool.query(`
    SELECT li.*,
      COALESCE(SUM(ip.amount),0) collected_amount,
      CASE
        WHEN COALESCE(SUM(ip.amount),0) >= li.amount THEN 'collected'
        WHEN li.due_date < CURDATE() THEN 'overdue'
        WHEN COALESCE(SUM(ip.amount),0) > 0 THEN 'partial'
        WHEN li.due_date <= DATE_ADD(CURDATE(), INTERVAL 30 DAY) THEN 'due_soon'
        ELSE 'upcoming'
      END status
    FROM lease_installments li
    LEFT JOIN installment_payments ip ON ip.installment_id=li.id
    WHERE li.lease_id=?
    GROUP BY li.id
    ORDER BY li.due_date`, [req.params.id]);
  ok(res, { lease, installments });
}));
app.post('/api/leases', auth, wrap(async (req, res) => {
  requireFields(req.body, ['apartment_id', 'tenant_id', 'start_date', 'end_date', 'total_amount']);
  const { apartment_id, tenant_id, start_date, end_date, total_amount, notes, is_active } = req.body;
  const [r] = await pool.query('INSERT INTO leases SET ?', { apartment_id, tenant_id, start_date, end_date, total_amount, notes, is_active: is_active ?? 1 });
  ok(res, { id: r.insertId });
}));
app.put('/api/leases/:id', auth, wrap(async (req, res) => {
  if (Object.keys(req.body).length === 0) throw Object.assign(new Error('No fields to update'), { status: 400 });
  const { apartment_id, tenant_id, start_date, end_date, total_amount, notes, is_active } = req.body;
  const data = {};
  if (apartment_id !== undefined) data.apartment_id = apartment_id;
  if (tenant_id !== undefined) data.tenant_id = tenant_id;
  if (start_date !== undefined) data.start_date = start_date;
  if (end_date !== undefined) data.end_date = end_date;
  if (total_amount !== undefined) data.total_amount = total_amount;
  if (notes !== undefined) data.notes = notes;
  if (is_active !== undefined) data.is_active = is_active;
  await pool.query('UPDATE leases SET ? WHERE id=?', [data, req.params.id]);
  ok(res, { id: req.params.id });
}));
app.delete('/api/leases/:id', auth, adminOnly, wrap(async (req, res) => {
  await pool.query('DELETE FROM leases WHERE id=?', [req.params.id]);
  ok(res, { deleted: true });
}));

// ─── Installments ─────────────────────────────────────────────────────────
app.get('/api/installments/all', auth, wrap(async (req, res) => {
  const { status, from, to, villa_id } = req.query;
  let where = '1=1';
  const params = [];
  if (from)     { where += ' AND li.due_date >= ?'; params.push(from); }
  if (to)       { where += ' AND li.due_date <= ?'; params.push(to); }
  if (villa_id) { where += ' AND a.villa_id = ?'; params.push(villa_id); }
  const [rows] = await pool.query(`
    SELECT li.id, li.lease_id, li.due_date, li.amount, li.notes,
      COALESCE(SUM(ip.amount),0) collected_amount,
      CASE
        WHEN COALESCE(SUM(ip.amount),0) >= li.amount THEN 'collected'
        WHEN li.due_date < CURDATE() THEN 'overdue'
        WHEN COALESCE(SUM(ip.amount),0) > 0 THEN 'partial'
        WHEN li.due_date <= DATE_ADD(CURDATE(), INTERVAL 30 DAY) THEN 'due_soon'
        ELSE 'upcoming'
      END status,
      t.name tenant_name, v.name villa_name, a.apartment_no,
      l.total_amount lease_total, l.is_active lease_is_active, l.end_date lease_end_date
    FROM lease_installments li
    JOIN leases l ON l.id = li.lease_id
    JOIN apartments a ON a.id = l.apartment_id
    JOIN villas v ON v.id = a.villa_id
    JOIN tenants t ON t.id = l.tenant_id
    LEFT JOIN installment_payments ip ON ip.installment_id = li.id
    WHERE ${where}
    GROUP BY li.id
    ORDER BY li.due_date ASC`, params);
  const filtered = status ? rows.filter(r => r.status === status) : rows;
  ok(res, filtered);
}));

app.post('/api/leases/:leaseId/installments', auth, wrap(async (req, res) => {
  requireFields(req.body, ['due_date', 'amount']);
  const { due_date, amount, notes } = req.body;
  const [r] = await pool.query('INSERT INTO lease_installments SET ?', { lease_id: req.params.leaseId, due_date, amount, notes });
  ok(res, { id: r.insertId });
}));
app.put('/api/installments/:id', auth, wrap(async (req, res) => {
  const { due_date, amount, notes } = req.body;
  const data = {};
  if (due_date !== undefined) data.due_date = due_date;
  if (amount !== undefined) data.amount = amount;
  if (notes !== undefined) data.notes = notes;
  if (Object.keys(data).length === 0) throw Object.assign(new Error('No fields to update'), { status: 400 });
  await pool.query('UPDATE lease_installments SET ? WHERE id=?', [data, req.params.id]);
  ok(res, { id: req.params.id });
}));
app.delete('/api/installments/:id', auth, adminOnly, wrap(async (req, res) => {
  await pool.query('DELETE FROM lease_installments WHERE id=?', [req.params.id]);
  ok(res, { deleted: true });
}));

// ─── Payments ─────────────────────────────────────────────────────────────
app.get('/api/installments/:installmentId/payments', auth, wrap(async (req, res) => {
  const [rows] = await pool.query('SELECT * FROM installment_payments WHERE installment_id=? ORDER BY payment_date', [req.params.installmentId]);
  ok(res, rows);
}));
app.post('/api/installments/:installmentId/payments', auth, wrap(async (req, res) => {
  requireFields(req.body, ['amount', 'payment_date']);
  const { amount, payment_date, notes } = req.body;
  const [r] = await pool.query('INSERT INTO installment_payments SET ?', { installment_id: req.params.installmentId, amount, payment_date, notes });
  ok(res, { id: r.insertId });
}));
app.delete('/api/payments/:id', auth, adminOnly, wrap(async (req, res) => {
  await pool.query('DELETE FROM installment_payments WHERE id=?', [req.params.id]);
  ok(res, { deleted: true });
}));

app.get('/api/reports/summary', auth, wrap(async (req, res) => {
  const from = req.query.from || '2000-01-01', to = req.query.to || '2999-12-31';
  const [rows] = await pool.query(`SELECT record_date, COUNT(*) total_records, COALESCE(SUM(spare_part_cost),0) total_cost FROM maintenance_records WHERE record_date BETWEEN ? AND ? GROUP BY record_date ORDER BY record_date DESC`, [from, to]);
  ok(res, rows);
}));

app.use((req, res) => res.status(404).json({ message: 'Not found' }));

const FK_MESSAGES = {
  fk_apartments_villa:    'لا يمكن حذف الفيلا — تحتوي على شقق مرتبطة',
  fk_lease_apt:           'لا يمكن حذف الشقة — مرتبطة بعقد إيجار نشط',
  fk_lease_tenant:        'لا يمكن حذف المستأجر — لديه عقود إيجار',
  fk_inst_lease:          'لا يمكن حذف العقد — لديه أقساط مرتبطة',
  fk_records_villa:       'لا يمكن حذف الفيلا — لديها كشوف صيانة',
  fk_records_apartment:   'لا يمكن حذف الشقة — لديها كشوف صيانة',
  fk_records_technician:  'لا يمكن حذف الفني — لديه كشوف صيانة',
};

app.use((err, req, res, next) => {
  if (err.code === 'ER_ROW_IS_REFERENCED_2') {
    const match = err.sqlMessage?.match(/CONSTRAINT `(\w+)`/);
    const msg = (match && FK_MESSAGES[match[1]]) || 'لا يمكن الحذف — السجل مرتبط ببيانات أخرى';
    return res.status(409).json({ message: msg });
  }
  if (err.code === 'ER_DUP_ENTRY') {
    const msg = err.sqlMessage?.includes('unique_apartment_per_villa')
      ? 'رقم الشقة موجود مسبقاً في هذه الفيلا'
      : 'البيانات مكررة';
    return res.status(409).json({ message: msg });
  }
  const status = err.status || (err.code === 'ER_NO_REFERENCED_ROW_2' ? 400 : 500);
  if (status === 500) console.error(err);
  res.status(status).json({ message: status === 500 ? 'Internal server error' : err.message });
});

process.on('unhandledRejection', (err) => console.error('Unhandled rejection:', err));

app.listen(process.env.PORT || 4000, () => console.log('API running'));

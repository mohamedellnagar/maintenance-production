import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import multer from 'multer';
import * as XLSX from 'xlsx';
import { pool } from './config/db.js';
import { auth, adminOnly } from './middleware/auth.js';
import { runMigrations } from './migrate.js';

const upload = multer({ storage: multer.memoryStorage(), limits: { fileSize: 10 * 1024 * 1024 } });

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

const LOCK_MS = 24 * 60 * 60 * 1000;
// a fully-collected installment locks (no edit/delete/pay) 1 day after it was collected
async function assertInstallmentUnlocked(installmentId) {
  const [[row]] = await pool.query(
    `SELECT li.amount, COALESCE(SUM(ip.amount),0) paid, MAX(ip.created_at) collected_at
     FROM lease_installments li LEFT JOIN installment_payments ip ON ip.installment_id=li.id
     WHERE li.id=? GROUP BY li.id`, [installmentId]);
  if (!row) return;
  const collected = Number(row.paid) >= Number(row.amount);
  if (collected && row.collected_at && (Date.now() - new Date(row.collected_at).getTime()) > LOCK_MS)
    throw Object.assign(new Error('هذه الدفعة مُحصّلة ومقفلة — لا يمكن تعديلها أو حذفها (متاح السجل فقط)'), { status: 423 });
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

  // Last 6 months collection trend (positive installment payments only — excludes refunds)
  const [paymentTrend] = await pool.query(`
    SELECT DATE_FORMAT(payment_date,'%Y-%m') mo,
      COALESCE(SUM(CASE WHEN amount>0 THEN amount ELSE 0 END),0) collected,
      COUNT(*) cnt
    FROM installment_payments WHERE payment_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
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
        WHEN YEAR(ip_pmt.payment_date)=YEAR(CURDATE()) AND MONTH(ip_pmt.payment_date)=MONTH(CURDATE()) AND ip_pmt.amount>0
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

  // Overdue installments list (top 12) — excludes cancelled/terminated
  const [overdueList] = await pool.query(`
    SELECT li.id, li.due_date, li.amount, COALESCE(SUM(ip.amount),0) collected,
      t.name tenant_name, t.phone tenant_phone, v.name villa_name, a.apartment_no
    FROM lease_installments li
    JOIN leases l ON l.id=li.lease_id
    JOIN apartments a ON a.id=l.apartment_id
    JOIN villas v ON v.id=a.villa_id
    JOIN tenants t ON t.id=l.tenant_id
    LEFT JOIN installment_payments ip ON ip.installment_id=li.id
    WHERE li.due_date<CURDATE() AND li.is_cancelled=0
    GROUP BY li.id
    HAVING collected<li.amount
    ORDER BY li.due_date ASC LIMIT 12`);

  // Overall collection rate (all non-cancelled installments)
  const [[financeSummary]] = await pool.query(`
    SELECT
      COALESCE(SUM(li.amount),0) total_billed,
      COALESCE((SELECT SUM(ip.amount) FROM installment_payments ip
        JOIN lease_installments li2 ON li2.id=ip.installment_id WHERE li2.is_cancelled=0),0) total_paid
    FROM lease_installments li WHERE li.is_cancelled=0`);

  ok(res, { today, month, filtered, byTech, byVilla, recent, monthlyTrend, paymentTrend, leaseKpi, installmentKpi, aptKpi, overdueList, financeSummary });
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
// Active technicians only — used in records/dropdowns
app.get('/api/technicians/active', auth, wrap(async (req, res) => {
  const [rows] = await pool.query('SELECT id,name,specialty FROM technicians WHERE is_active=1 ORDER BY name');
  ok(res, rows);
}));

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
function validatePassword(pwd) {
  if (!pwd || pwd.length < 8) throw Object.assign(new Error('كلمة المرور يجب أن تكون 8 أحرف على الأقل'), { status: 400 });
  if (!/[A-Z]/.test(pwd)) throw Object.assign(new Error('كلمة المرور يجب أن تحتوي على حرف كبير'), { status: 400 });
  if (!/[0-9]/.test(pwd)) throw Object.assign(new Error('كلمة المرور يجب أن تحتوي على رقم'), { status: 400 });
}
app.post('/api/users', auth, adminOnly, wrap(async (req, res) => {
  requireFields(req.body, ['name', 'email', 'password']);
  const { name, email, password, role, is_active } = req.body;
  validatePassword(password);
  const password_hash = await bcrypt.hash(password, 10);
  const [r] = await pool.query('INSERT INTO users SET ?', { name, email, password_hash, role: role || 'SUPERVISOR', is_active: is_active ?? 1 });
  ok(res, { id: r.insertId });
}));
app.put('/api/users/:id', auth, adminOnly, wrap(async (req, res) => {
  requireFields(req.body, ['name', 'email']);
  const { name, email, password, role, is_active } = req.body;
  if (password) validatePassword(password);
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
crud('tenants', 'tenants', ['name', 'phone', 'national_id', 'car_number', 'email', 'notes'], ['name'], 'tenants_mgmt');

// ─── Leases ───────────────────────────────────────────────────────────────
app.get('/api/leases', auth, pageGuard('leases'), wrap(async (req, res) => {
  const where = [];
  const p = [];
  if (req.query.apartment_id) { where.push('l.apartment_id=?'); p.push(req.query.apartment_id); }
  if (req.query.tenant_id) { where.push('l.tenant_id=?'); p.push(req.query.tenant_id); }
  if (req.query.is_active !== undefined) { where.push('l.is_active=?'); p.push(req.query.is_active); }
  const [rows] = await pool.query(`
    SELECT l.*, t.name tenant_name, t.phone tenant_phone,
      a.apartment_no, v.name villa_name, v.id villa_id,
      (SELECT COUNT(*) FROM lease_installments li WHERE li.lease_id=l.id) installments_count,
      (SELECT COALESCE(SUM(ip.amount),0) FROM lease_installments li JOIN installment_payments ip ON ip.installment_id=li.id WHERE li.lease_id=l.id) collected_amount,
      (SELECT COUNT(*) FROM lease_installments li
        LEFT JOIN (SELECT installment_id, SUM(amount) paid FROM installment_payments GROUP BY installment_id) pp ON pp.installment_id=li.id
        WHERE li.lease_id=l.id AND li.is_cancelled=0 AND li.due_date < CURDATE() AND COALESCE(pp.paid,0) < li.amount) overdue_count
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
  const isTerminated = lease.terminated_at != null;
  const [installments] = await pool.query(`
    SELECT li.*,
      COALESCE(SUM(ip.amount),0) collected_amount,
      MAX(ip.created_at) collected_at,
      CASE
        WHEN li.is_cancelled=1 THEN 'cancelled'
        WHEN COALESCE(SUM(ip.amount),0) >= li.amount THEN 'collected'
        WHEN ? = 1 AND li.notes LIKE 'مستحق عند إنهاء%' THEN 'settlement'
        WHEN ? = 1 THEN 'settled'
        WHEN li.due_date < CURDATE() THEN 'overdue'
        WHEN COALESCE(SUM(ip.amount),0) > 0 THEN 'partial'
        WHEN li.due_date <= DATE_ADD(CURDATE(), INTERVAL 30 DAY) THEN 'due_soon'
        ELSE 'upcoming'
      END status
    FROM lease_installments li
    LEFT JOIN installment_payments ip ON ip.installment_id=li.id
    WHERE li.lease_id=?
    GROUP BY li.id
    ORDER BY li.due_date`, [isTerminated ? 1 : 0, isTerminated ? 1 : 0, req.params.id]);
  // lock a collected installment 1 day after it was fully collected (edit/delete/pay disabled → history only)
  const DAY = 24 * 60 * 60 * 1000;
  for (const i of installments) {
    i.locked = i.status === 'collected' && i.collected_at != null && (Date.now() - new Date(i.collected_at).getTime()) > DAY;
  }
  ok(res, { lease, installments });
}));
app.post('/api/leases', auth, wrap(async (req, res) => {
  requireFields(req.body, ['apartment_id', 'tenant_id', 'start_date', 'end_date', 'total_amount']);
  const { apartment_id, tenant_id, start_date, end_date, total_amount, fees_amount, deposit_amount, deposit_type, deposit_notes, notes, is_active } = req.body;
  const [r] = await pool.query('INSERT INTO leases SET ?', { apartment_id, tenant_id, start_date, end_date, total_amount, fees_amount: fees_amount || 0, deposit_amount: deposit_amount || 0, deposit_type: deposit_type || null, deposit_notes: deposit_notes || null, notes, is_active: is_active ?? 1 });
  ok(res, { id: r.insertId });
}));
app.put('/api/leases/:id', auth, wrap(async (req, res) => {
  if (Object.keys(req.body).length === 0) throw Object.assign(new Error('No fields to update'), { status: 400 });
  const { apartment_id, tenant_id, start_date, end_date, total_amount, fees_amount, deposit_amount, deposit_type, deposit_notes, notes, is_active } = req.body;
  const data = {};
  if (apartment_id !== undefined) data.apartment_id = apartment_id;
  if (tenant_id !== undefined) data.tenant_id = tenant_id;
  if (start_date !== undefined) data.start_date = start_date;
  if (end_date !== undefined) data.end_date = end_date;
  if (total_amount !== undefined) data.total_amount = total_amount;
  if (fees_amount !== undefined) data.fees_amount = fees_amount;
  if (deposit_amount !== undefined) data.deposit_amount = deposit_amount;
  if (deposit_type !== undefined) data.deposit_type = deposit_type;
  if (deposit_notes !== undefined) data.deposit_notes = deposit_notes;
  if (notes !== undefined) data.notes = notes;
  if (is_active !== undefined) data.is_active = is_active;
  await pool.query('UPDATE leases SET ? WHERE id=?', [data, req.params.id]);
  ok(res, { id: req.params.id });
}));
app.delete('/api/leases/:id', auth, adminOnly, wrap(async (req, res) => {
  await pool.query('DELETE FROM leases WHERE id=?', [req.params.id]);
  ok(res, { deleted: true });
}));

app.post('/api/leases/:id/terminate', auth, adminOnly, wrap(async (req, res) => {
  const { terminate_date, cascade_refund_amount, new_owed_amount, notes_summary } = req.body;
  const leaseId = req.params.id;

  // ── input validation ──────────────────────────────────────────────
  if (!terminate_date) throw Object.assign(new Error('تاريخ الإنهاء مطلوب'), { status: 400 });
  if (!/^\d{4}-\d{2}-\d{2}$/.test(terminate_date)) throw Object.assign(new Error('صيغة تاريخ الإنهاء غير صحيحة (YYYY-MM-DD)'), { status: 400 });
  const tDate = new Date(terminate_date);
  if (isNaN(tDate.getTime())) throw Object.assign(new Error('تاريخ الإنهاء غير صالح'), { status: 400 });
  const refundAmt = Number(cascade_refund_amount || 0);
  const owedAmt = Number(new_owed_amount || 0);
  if (isNaN(refundAmt) || refundAmt < 0) throw Object.assign(new Error('مبلغ الاسترداد غير صالح'), { status: 400 });
  if (isNaN(owedAmt) || owedAmt < 0) throw Object.assign(new Error('المبلغ المستحق غير صالح'), { status: 400 });

  // ── lease existence + range + double-termination guard ────────────
  const [[lease]] = await pool.query(
    `SELECT id, notes, DATE_FORMAT(start_date,'%Y-%m-%d') AS start_date,
       DATE_FORMAT(end_date,'%Y-%m-%d') AS end_date,
       DATE_FORMAT(terminated_at,'%Y-%m-%d') AS terminated_at
     FROM leases WHERE id=?`, [leaseId]);
  if (!lease) throw Object.assign(new Error('العقد غير موجود'), { status: 404 });
  if (lease.terminated_at) throw Object.assign(new Error('تم إنهاء هذا العقد مسبقاً بتاريخ ' + lease.terminated_at), { status: 409 });
  if (terminate_date < lease.start_date || terminate_date > lease.end_date)
    throw Object.assign(new Error(`تاريخ الإنهاء يجب أن يكون بين ${lease.start_date} و ${lease.end_date}`), { status: 400 });

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    // 1. cancel all unpaid installments (those with no full payment)
    await conn.query(
      `UPDATE lease_installments li
       SET is_cancelled=1, notes=CONCAT(COALESCE(notes,''),' [مُلغاة بإنهاء العقد ${terminate_date}]')
       WHERE li.lease_id=? AND li.is_cancelled=0
         AND (SELECT COALESCE(SUM(ip.amount),0) FROM installment_payments ip WHERE ip.installment_id=li.id) < li.amount`,
      [leaseId]
    );
    // 2a. rent overpayment → cascade refund across collected installments newest → oldest
    if (refundAmt > 0) {
      const [collectedInsts] = await conn.query(
        `SELECT li.id, COALESCE(SUM(ip.amount),0) AS paid
         FROM lease_installments li
         LEFT JOIN installment_payments ip ON ip.installment_id=li.id
         WHERE li.lease_id=? AND li.is_cancelled=0
         GROUP BY li.id, li.amount
         HAVING COALESCE(SUM(ip.amount),0) >= li.amount
         ORDER BY li.due_date DESC`,
        [leaseId]
      );
      let remaining = refundAmt;
      for (const inst of collectedInsts) {
        if (remaining <= 0) break;
        const deduct = Math.min(remaining, Number(inst.paid));
        await conn.query('INSERT INTO installment_payments SET ?',
          { installment_id: inst.id, amount: -deduct, payment_date: terminate_date, notes: `استرداد إيجار عند إنهاء العقد ${terminate_date}` }
        );
        remaining = Math.round((remaining - deduct) * 100) / 100;
      }
    }
    // 2b. tenant still owes (rent shortfall not covered by deposit) → add installment
    if (owedAmt > 0) {
      await conn.query('INSERT INTO lease_installments SET ?',
        { lease_id: leaseId, due_date: terminate_date, amount: owedAmt, notes: `مستحق عند إنهاء العقد ${terminate_date}` }
      );
    }
    // 2c. record settlement summary (incl. deposit disposition) in lease notes
    if (notes_summary && String(notes_summary).trim()) {
      const stamp = `\n\n──── تسوية إنهاء العقد (${terminate_date}) ────\n${String(notes_summary).trim()}`;
      await conn.query('UPDATE leases SET notes=CONCAT(COALESCE(notes,\'\'), ?) WHERE id=?', [stamp, leaseId]);
    }
    // 3. mark lease terminated: shorten end_date, flag terminated_at, deactivate
    await conn.query('UPDATE leases SET end_date=?, terminated_at=?, is_active=0 WHERE id=?', [terminate_date, terminate_date, leaseId]);
    await conn.commit();
    ok(res, { terminated: true });
  } catch (e) {
    await conn.rollback();
    throw e;
  } finally {
    conn.release();
  }
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
        WHEN li.is_cancelled=1 THEN 'cancelled'
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

// add n calendar months to YYYY-MM-DD (clamps day to end of month)
function addMonths(dateStr, n) {
  const [y, m, d] = dateStr.split('-').map(Number);
  const totalM = (m - 1) + n;
  const ny = y + Math.floor(totalM / 12);
  const nm = ((totalM % 12) + 12) % 12; // 0-11
  const lastDay = new Date(Date.UTC(ny, nm + 1, 0)).getUTCDate();
  const nd = Math.min(d, lastDay);
  return `${ny}-${String(nm + 1).padStart(2, '0')}-${String(nd).padStart(2, '0')}`;
}

// auto-generate installments across the lease term by frequency
app.post('/api/leases/:id/generate-installments', auth, wrap(async (req, res) => {
  const { frequency, replace } = req.body;
  const INTERVALS = { monthly: 1, quarterly: 3, semiannual: 6, annual: 12 };
  const interval = INTERVALS[frequency];
  if (!interval) throw Object.assign(new Error('التكرار غير صالح (شهري/ربع سنوي/نصف سنوي/سنوي)'), { status: 400 });

  const [[lease]] = await pool.query(
    `SELECT id, total_amount, DATE_FORMAT(start_date,'%Y-%m-%d') start_date, DATE_FORMAT(end_date,'%Y-%m-%d') end_date
     FROM leases WHERE id=?`, [req.params.id]);
  if (!lease) throw Object.assign(new Error('العقد غير موجود'), { status: 404 });
  const total = Number(lease.total_amount);
  if (!(total > 0)) throw Object.assign(new Error('قيمة العقد غير صالحة'), { status: 400 });

  // build due dates from start while strictly before end
  const dueDates = [];
  for (let k = 0; k < 600; k++) {
    const due = addMonths(lease.start_date, k * interval);
    if (due >= lease.end_date) break;
    dueDates.push(due);
  }
  if (dueDates.length === 0) dueDates.push(lease.start_date);
  const periods = dueDates.length;
  const base = Math.floor((total / periods) * 100) / 100;

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    // guard: refuse if any existing installment is locked (collected > 1 day)
    if (replace) {
      const [locked] = await conn.query(
        `SELECT li.id FROM lease_installments li
         LEFT JOIN installment_payments ip ON ip.installment_id=li.id
         WHERE li.lease_id=? GROUP BY li.id, li.amount
         HAVING COALESCE(SUM(ip.amount),0) >= li.amount AND MAX(ip.created_at) < NOW() - INTERVAL 1 DAY`, [req.params.id]);
      if (locked.length) throw Object.assign(new Error('لا يمكن الاستبدال — يوجد دفعات محصّلة ومقفلة'), { status: 423 });
      await conn.query('DELETE FROM lease_installments WHERE lease_id=?', [req.params.id]);
    }
    const FREQ_AR = { monthly: 'شهري', quarterly: 'ربع سنوي', semiannual: 'نصف سنوي', annual: 'سنوي' };
    for (let i = 0; i < periods; i++) {
      const amt = i === periods - 1
        ? Math.round((total - base * (periods - 1)) * 100) / 100
        : base;
      await conn.query('INSERT INTO lease_installments SET ?',
        { lease_id: req.params.id, due_date: dueDates[i], amount: amt, notes: `مُولّدة تلقائياً (${FREQ_AR[frequency]})` });
    }
    await conn.commit();
    ok(res, { generated: periods, per_installment: base, frequency });
  } catch (e) {
    await conn.rollback();
    throw e;
  } finally {
    conn.release();
  }
}));
app.put('/api/installments/:id', auth, wrap(async (req, res) => {
  await assertInstallmentUnlocked(req.params.id);
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
  await assertInstallmentUnlocked(req.params.id);
  await pool.query('DELETE FROM lease_installments WHERE id=?', [req.params.id]);
  ok(res, { deleted: true });
}));

// ─── Payments ─────────────────────────────────────────────────────────────
app.get('/api/installments/:installmentId/payments', auth, wrap(async (req, res) => {
  const [rows] = await pool.query(
    `SELECT ip.*, u.name AS created_by_name
     FROM installment_payments ip
     LEFT JOIN users u ON u.id = ip.created_by
     WHERE ip.installment_id=? ORDER BY ip.created_at, ip.id`, [req.params.installmentId]);
  ok(res, rows);
}));
app.post('/api/installments/:installmentId/payments', auth, wrap(async (req, res) => {
  await assertInstallmentUnlocked(req.params.installmentId);
  requireFields(req.body, ['amount', 'payment_date']);
  const { amount, payment_date, notes } = req.body;
  const [r] = await pool.query('INSERT INTO installment_payments SET ?', { installment_id: req.params.installmentId, amount, payment_date, notes, created_by: req.user.id });
  ok(res, { id: r.insertId });
}));
app.delete('/api/payments/:id', auth, adminOnly, wrap(async (req, res) => {
  const [[pay]] = await pool.query('SELECT installment_id FROM installment_payments WHERE id=?', [req.params.id]);
  if (pay) await assertInstallmentUnlocked(pay.installment_id);
  await pool.query('DELETE FROM installment_payments WHERE id=?', [req.params.id]);
  ok(res, { deleted: true });
}));

app.get('/api/reports/summary', auth, wrap(async (req, res) => {
  const from = req.query.from || '2000-01-01', to = req.query.to || '2999-12-31';
  const [rows] = await pool.query(`SELECT record_date, COUNT(*) total_records, COALESCE(SUM(spare_part_cost),0) total_cost FROM maintenance_records WHERE record_date BETWEEN ? AND ? GROUP BY record_date ORDER BY record_date DESC`, [from, to]);
  ok(res, rows);
}));

// ═══ Inventory / Warehouse (المخزن) ════════════════════════════════════════
crud('suppliers', 'suppliers', ['name', 'phone', 'notes', 'is_active'], ['name'], 'inventory');

// on-hand stock expression: purchases add, consumption subtracts, adjustments are signed
const STOCK_EXPR = `COALESCE(SUM(CASE m.type WHEN 'purchase' THEN m.quantity WHEN 'consume' THEN -m.quantity ELSE m.quantity END),0)`;

function decorateItem(i) {
  const stock = Number(i.stock || 0);
  const pQty = Number(i.purchased_qty || 0);
  const pVal = Number(i.purchased_value || 0);
  const avgCost = pQty > 0 ? Math.round((pVal / pQty) * 100) / 100 : 0;
  return {
    ...i,
    stock,
    avg_cost: avgCost,
    stock_value: Math.round(stock * avgCost * 100) / 100,
    status: stock <= 0 ? 'out' : (stock <= Number(i.reorder_level || 0) ? 'low' : 'ok'),
  };
}

app.get('/api/inventory/items', auth, pageGuard('inventory'), wrap(async (req, res) => {
  const [rows] = await pool.query(`
    SELECT i.*,
      ${STOCK_EXPR} AS stock,
      COALESCE(SUM(CASE WHEN m.type='purchase' THEN m.quantity ELSE 0 END),0) AS purchased_qty,
      COALESCE(SUM(CASE WHEN m.type='purchase' THEN m.total_amount ELSE 0 END),0) AS purchased_value
    FROM inventory_items i
    LEFT JOIN stock_movements m ON m.item_id=i.id
    GROUP BY i.id ORDER BY i.name`);
  ok(res, rows.map(decorateItem));
}));

app.get('/api/inventory/items/:id', auth, pageGuard('inventory'), wrap(async (req, res) => {
  const [[item]] = await pool.query(`
    SELECT i.*,
      ${STOCK_EXPR} AS stock,
      COALESCE(SUM(CASE WHEN m.type='purchase' THEN m.quantity ELSE 0 END),0) AS purchased_qty,
      COALESCE(SUM(CASE WHEN m.type='purchase' THEN m.total_amount ELSE 0 END),0) AS purchased_value
    FROM inventory_items i LEFT JOIN stock_movements m ON m.item_id=i.id
    WHERE i.id=? GROUP BY i.id`, [req.params.id]);
  if (!item) throw Object.assign(new Error('الصنف غير موجود'), { status: 404 });
  const [movements] = await pool.query(`
    SELECT m.*, s.name supplier_name, v.name villa_name, u.name created_by_name
    FROM stock_movements m
    LEFT JOIN suppliers s ON s.id=m.supplier_id
    LEFT JOIN villas v ON v.id=m.villa_id
    LEFT JOIN users u ON u.id=m.created_by
    WHERE m.item_id=? ORDER BY m.movement_date DESC, m.id DESC`, [req.params.id]);
  ok(res, { item: decorateItem(item), movements });
}));

app.post('/api/inventory/items', auth, wrap(async (req, res) => {
  requireFields(req.body, ['name']);
  const { name, unit, category, reorder_level, notes, is_active } = req.body;
  const [r] = await pool.query('INSERT INTO inventory_items SET ?',
    { name, unit: unit || 'قطعة', category: category || null, reorder_level: reorder_level || 0, notes: notes || null, is_active: is_active ?? 1 });
  ok(res, { id: r.insertId });
}));
app.put('/api/inventory/items/:id', auth, wrap(async (req, res) => {
  const data = {};
  ['name', 'unit', 'category', 'reorder_level', 'notes', 'is_active'].forEach(f => { if (req.body[f] !== undefined) data[f] = req.body[f]; });
  if (!Object.keys(data).length) throw Object.assign(new Error('No fields'), { status: 400 });
  await pool.query('UPDATE inventory_items SET ? WHERE id=?', [data, req.params.id]);
  ok(res, { id: req.params.id });
}));
app.delete('/api/inventory/items/:id', auth, adminOnly, wrap(async (req, res) => {
  await pool.query('DELETE FROM inventory_items WHERE id=?', [req.params.id]);
  ok(res, { deleted: true });
}));

// all movements (filterable)
app.get('/api/inventory/movements', auth, pageGuard('inventory'), wrap(async (req, res) => {
  const where = ['1=1']; const p = [];
  if (req.query.type) { where.push('m.type=?'); p.push(req.query.type); }
  if (req.query.item_id) { where.push('m.item_id=?'); p.push(req.query.item_id); }
  if (req.query.from) { where.push('m.movement_date>=?'); p.push(req.query.from); }
  if (req.query.to) { where.push('m.movement_date<=?'); p.push(req.query.to); }
  const [rows] = await pool.query(`
    SELECT m.*, i.name item_name, i.unit item_unit, s.name supplier_name, v.name villa_name, u.name created_by_name
    FROM stock_movements m
    JOIN inventory_items i ON i.id=m.item_id
    LEFT JOIN suppliers s ON s.id=m.supplier_id
    LEFT JOIN villas v ON v.id=m.villa_id
    LEFT JOIN users u ON u.id=m.created_by
    WHERE ${where.join(' AND ')} ORDER BY m.movement_date DESC, m.id DESC LIMIT 500`, p);
  ok(res, rows);
}));

// record a movement (purchase / consume / adjust)
app.post('/api/inventory/movements', auth, wrap(async (req, res) => {
  const { item_id, type, quantity, unit_price, movement_date, supplier_id, villa_id, record_id, notes } = req.body;
  requireFields(req.body, ['item_id', 'type', 'quantity', 'movement_date']);
  if (!['purchase', 'consume', 'adjust'].includes(type)) throw Object.assign(new Error('نوع الحركة غير صالح'), { status: 400 });
  const qty = Number(quantity);
  if (isNaN(qty) || qty === 0) throw Object.assign(new Error('الكمية غير صالحة'), { status: 400 });
  if ((type === 'purchase' || type === 'consume') && qty <= 0) throw Object.assign(new Error('الكمية يجب أن تكون أكبر من صفر'), { status: 400 });

  // current stock + avg cost
  const [[cur]] = await pool.query(`
    SELECT ${STOCK_EXPR} AS stock,
      COALESCE(SUM(CASE WHEN m.type='purchase' THEN m.quantity ELSE 0 END),0) AS pq,
      COALESCE(SUM(CASE WHEN m.type='purchase' THEN m.total_amount ELSE 0 END),0) AS pv
    FROM inventory_items i LEFT JOIN stock_movements m ON m.item_id=i.id WHERE i.id=?`, [item_id]);
  if (!cur) throw Object.assign(new Error('الصنف غير موجود'), { status: 404 });
  const stock = Number(cur.stock);
  const avgCost = Number(cur.pq) > 0 ? Number(cur.pv) / Number(cur.pq) : 0;

  if (type === 'consume' && qty > stock)
    throw Object.assign(new Error(`الكمية المتاحة ${stock} فقط — لا يمكن صرف ${qty}`), { status: 400 });

  const up = type === 'purchase' ? Number(unit_price || 0) : (type === 'consume' ? Math.round(avgCost * 100) / 100 : 0);
  const total = Math.round(Math.abs(qty) * up * 100) / 100;
  const [r] = await pool.query('INSERT INTO stock_movements SET ?', {
    item_id, type, quantity: qty, unit_price: up, total_amount: total, movement_date,
    supplier_id: type === 'purchase' ? (supplier_id || null) : null,
    villa_id: type === 'consume' ? (villa_id || null) : null,
    record_id: type === 'consume' ? (record_id || null) : null,
    notes: notes || null, created_by: req.user.id,
  });
  ok(res, { id: r.insertId });
}));
app.delete('/api/inventory/movements/:id', auth, adminOnly, wrap(async (req, res) => {
  await pool.query('DELETE FROM stock_movements WHERE id=?', [req.params.id]);
  ok(res, { deleted: true });
}));

// summary / KPIs / reports
app.get('/api/inventory/summary', auth, pageGuard('inventory'), wrap(async (req, res) => {
  const [items] = await pool.query(`
    SELECT i.id, i.name, i.unit, i.reorder_level,
      ${STOCK_EXPR} AS stock,
      COALESCE(SUM(CASE WHEN m.type='purchase' THEN m.quantity ELSE 0 END),0) AS purchased_qty,
      COALESCE(SUM(CASE WHEN m.type='purchase' THEN m.total_amount ELSE 0 END),0) AS purchased_value
    FROM inventory_items i LEFT JOIN stock_movements m ON m.item_id=i.id
    GROUP BY i.id`);
  const decorated = items.map(decorateItem);
  const totalValue = Math.round(decorated.reduce((s, i) => s + i.stock_value, 0) * 100) / 100;
  const lowStock = decorated.filter(i => i.status === 'low');
  const outStock = decorated.filter(i => i.status === 'out');

  const [[mp]] = await pool.query(`SELECT COALESCE(SUM(total_amount),0) v, COUNT(*) c FROM stock_movements WHERE type='purchase' AND YEAR(movement_date)=YEAR(CURDATE()) AND MONTH(movement_date)=MONTH(CURDATE())`);
  const [[mc]] = await pool.query(`SELECT COALESCE(SUM(total_amount),0) v, COALESCE(SUM(quantity),0) q, COUNT(*) c FROM stock_movements WHERE type='consume' AND YEAR(movement_date)=YEAR(CURDATE()) AND MONTH(movement_date)=MONTH(CURDATE())`);
  const [topConsumed] = await pool.query(`
    SELECT i.name, i.unit, SUM(m.quantity) qty, COALESCE(SUM(m.total_amount),0) value
    FROM stock_movements m JOIN inventory_items i ON i.id=m.item_id
    WHERE m.type='consume' GROUP BY m.item_id ORDER BY qty DESC LIMIT 8`);
  const [byVilla] = await pool.query(`
    SELECT v.name villa_name, COALESCE(SUM(m.total_amount),0) value, SUM(m.quantity) qty
    FROM stock_movements m JOIN villas v ON v.id=m.villa_id
    WHERE m.type='consume' AND m.villa_id IS NOT NULL GROUP BY m.villa_id ORDER BY value DESC LIMIT 8`);

  ok(res, {
    total_items: decorated.length,
    total_value: totalValue,
    low_count: lowStock.length,
    out_count: outStock.length,
    low_items: lowStock.map(i => ({ id: i.id, name: i.name, unit: i.unit, stock: i.stock, reorder_level: Number(i.reorder_level) })),
    month_purchases: { value: Number(mp.v), count: mp.c },
    month_consumption: { value: Number(mc.v), qty: Number(mc.q), count: mc.c },
    top_consumed: topConsumed,
    by_villa: byVilla,
  });
}));

// ── Inventory Import (استيراد المخزن) ───────────────────────────────────────
function invSheets() {
  return [
    { name: 'الأصناف', headers: ['اسم الصنف *', 'الوحدة', 'الفئة', 'حد إعادة الطلب', 'الرصيد الافتتاحي', 'سعر الوحدة', 'ملاحظات'],
      rows: [['مواسير PVC 2 بوصة', 'متر', 'سباكة', 20, 100, 8, ''], ['كابل كهرباء 2.5مم', 'لفة', 'كهرباء', 5, 10, 120, '']] },
    { name: 'الموردون', headers: ['الاسم *', 'الهاتف', 'ملاحظات'],
      rows: [['مؤسسة النور للأدوات', '0501112222', ''], ['شركة الإمداد', '0509998888', 'مورد رئيسي']] },
    { name: 'المشتريات', headers: ['اسم الصنف *', 'الكمية *', 'سعر الوحدة *', 'التاريخ', 'المورّد', 'ملاحظات'],
      rows: [['مواسير PVC 2 بوصة', 50, 8, '2026-01-15', 'مؤسسة النور للأدوات', 'فاتورة 1023']] },
  ];
}
app.get('/api/inventory/import/template', auth, adminOnly, (req, res) => {
  const wb = XLSX.utils.book_new();
  for (const s of invSheets()) {
    const ws = XLSX.utils.aoa_to_sheet([s.headers, ...s.rows]);
    ws['!cols'] = s.headers.map(() => ({ wch: 20 }));
    XLSX.utils.book_append_sheet(wb, ws, s.name);
  }
  const buf = Buffer.from(XLSX.write(wb, { type: 'array', bookType: 'xlsx' }));
  res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  res.setHeader('Content-Disposition', "attachment; filename*=UTF-8''%D9%86%D9%85%D9%88%D8%B0%D8%AC_%D8%A7%D9%84%D9%85%D8%AE%D8%B2%D9%86.xlsx");
  res.send(buf);
});

app.post('/api/inventory/import/preview', auth, adminOnly, upload.single('file'), wrap(async (req, res) => {
  if (!req.file) return res.status(400).json({ message: 'لم يتم رفع ملف' });
  const wb = XLSX.read(req.file.buffer, { type: 'buffer', cellDates: true });
  const items = parseSheet(wb, 'الأصناف');
  const suppliers = parseSheet(wb, 'الموردون');
  const purchases = parseSheet(wb, 'المشتريات');
  const errors = [];
  items.forEach((r, i) => { if (!r['اسم الصنف *']) errors.push(`الأصناف - صف ${i + 2}: اسم الصنف مطلوب`); });
  suppliers.forEach((r, i) => { if (!r['الاسم *']) errors.push(`الموردون - صف ${i + 2}: الاسم مطلوب`); });
  purchases.forEach((r, i) => {
    if (!r['اسم الصنف *']) errors.push(`المشتريات - صف ${i + 2}: اسم الصنف مطلوب`);
    if (!r['الكمية *']) errors.push(`المشتريات - صف ${i + 2}: الكمية مطلوبة`);
    if (r['سعر الوحدة *'] === '' || r['سعر الوحدة *'] == null) errors.push(`المشتريات - صف ${i + 2}: سعر الوحدة مطلوب`);
  });
  ok(res, { items, suppliers, purchases, errors,
    counts: { items: items.length, suppliers: suppliers.length, purchases: purchases.length } });
}));

app.post('/api/inventory/import/confirm', auth, adminOnly, upload.single('file'), wrap(async (req, res) => {
  if (!req.file) return res.status(400).json({ message: 'لم يتم رفع ملف' });
  const wb = XLSX.read(req.file.buffer, { type: 'buffer', cellDates: true });
  const itemRows = parseSheet(wb, 'الأصناف').filter(r => r['اسم الصنف *']);
  const supRows = parseSheet(wb, 'الموردون').filter(r => r['الاسم *']);
  const purRows = parseSheet(wb, 'المشتريات').filter(r => r['اسم الصنف *'] && r['الكمية *']);
  const today = new Date().toISOString().slice(0, 10);
  const conn = await pool.getConnection();
  const report = { items: 0, suppliers: 0, purchases: 0, opening: 0, skipped: [] };
  try {
    await conn.beginTransaction();
    // suppliers
    const supMap = {};
    const [existingSup] = await conn.query('SELECT id, name FROM suppliers');
    existingSup.forEach(s => { supMap[s.name] = s.id; });
    for (const r of supRows) {
      const name = String(r['الاسم *']).trim();
      if (supMap[name]) { report.skipped.push(`مورّد "${name}" موجود بالفعل`); continue; }
      const [ins] = await conn.query('INSERT INTO suppliers (name,phone,notes) VALUES (?,?,?)', [name, r['الهاتف'] || null, r['ملاحظات'] || null]);
      supMap[name] = ins.insertId; report.suppliers++;
    }
    // items (+ optional opening balance as a purchase movement)
    const itemMap = {};
    const [existingItems] = await conn.query('SELECT id, name FROM inventory_items');
    existingItems.forEach(i => { itemMap[i.name] = i.id; });
    for (const r of itemRows) {
      const name = String(r['اسم الصنف *']).trim();
      let itemId = itemMap[name];
      if (!itemId) {
        const [ins] = await conn.query('INSERT INTO inventory_items SET ?',
          { name, unit: r['الوحدة'] || 'قطعة', category: r['الفئة'] || null, reorder_level: Number(r['حد إعادة الطلب']) || 0, notes: r['ملاحظات'] || null });
        itemId = ins.insertId; itemMap[name] = itemId; report.items++;
      } else { report.skipped.push(`صنف "${name}" موجود بالفعل`); }
      const openQty = Number(r['الرصيد الافتتاحي']) || 0;
      if (openQty > 0) {
        const up = Number(r['سعر الوحدة']) || 0;
        await conn.query('INSERT INTO stock_movements SET ?',
          { item_id: itemId, type: 'purchase', quantity: openQty, unit_price: up, total_amount: Math.round(openQty * up * 100) / 100, movement_date: today, notes: 'رصيد افتتاحي (استيراد)', created_by: req.user.id });
        report.opening++;
      }
    }
    // purchases
    for (const r of purRows) {
      const name = String(r['اسم الصنف *']).trim();
      const itemId = itemMap[name];
      if (!itemId) { report.skipped.push(`مشتريات: صنف "${name}" غير موجود`); continue; }
      const qty = Number(r['الكمية *']) || 0;
      const up = Number(r['سعر الوحدة *']) || 0;
      if (qty <= 0) { report.skipped.push(`مشتريات "${name}": كمية غير صالحة`); continue; }
      const supName = r['المورّد'] ? String(r['المورّد']).trim() : null;
      await conn.query('INSERT INTO stock_movements SET ?',
        { item_id: itemId, type: 'purchase', quantity: qty, unit_price: up, total_amount: Math.round(qty * up * 100) / 100,
          movement_date: toDate(r['التاريخ']) || today, supplier_id: (supName && supMap[supName]) || null, notes: r['ملاحظات'] || null, created_by: req.user.id });
      report.purchases++;
    }
    await conn.commit();
    ok(res, report);
  } catch (e) {
    await conn.rollback();
    throw e;
  } finally {
    conn.release();
  }
}));

// ── Import Template ────────────────────────────────────────────────────────
app.get('/api/import/template', auth, adminOnly, (req, res) => {
  const wb = XLSX.utils.book_new();
  const sheets = [
    { name:'الفلل', headers:['اسم الفيلا *','المنطقة','ملاحظات'], rows:[['فيلا الأحمدي','دبي - الجميرا',''],['فيلا النخيل','أبوظبي - الخالدية','فيلا مجددة 2024']] },
    { name:'الشقق', headers:['اسم الفيلا *','رقم الشقة *','نوع الشقة','عدد الحمامات','بلكونة (نعم/لا)','الدور','ملاحظات'], rows:[['فيلا الأحمدي','101','غرفتان وصالة',2,'نعم','أول',''],['فيلا الأحمدي','102','استوديو',1,'لا','أرضي','مدخل خاص'],['فيلا النخيل','201','ثلاث غرف وصالة',3,'نعم','ثاني','']] },
    { name:'المستأجرين', headers:['الاسم *','الهاتف','رقم الهوية','رقم السيارة','الإيميل','ملاحظات'], rows:[['أحمد محمد الكندي','0501234567','784-1990-1234567-1','أ ب ج 12345','ahmed@email.com',''],['سارة علي المنصوري','0559876543','784-1985-7654321-2','','','مستأجرة قديمة']] },
    { name:'العقود', headers:['اسم الفيلا *','رقم الشقة *','اسم المستأجر *','تاريخ البداية *','تاريخ النهاية *','إجمالي الإيجار *','ملاحظات'], rows:[['فيلا الأحمدي','101','أحمد محمد الكندي','2025-01-01','2026-01-01',60000,''],['فيلا النخيل','201','سارة علي المنصوري','2024-06-01','2025-06-01',90000,'عقد منتهي']] },
    { name:'الدفعات', headers:['اسم الفيلا *','رقم الشقة *','اسم المستأجر *','تاريخ الاستحقاق *','المبلغ *','تاريخ الدفع (فارغ = لم يُدفع)','ملاحظات'], rows:[['فيلا الأحمدي','101','أحمد محمد الكندي','2025-01-01',15000,'2025-01-05','ربع سنوي'],['فيلا الأحمدي','101','أحمد محمد الكندي','2025-04-01',15000,'','لم يُدفع بعد']] },
  ];
  for (const s of sheets) {
    const ws = XLSX.utils.aoa_to_sheet([s.headers, ...s.rows]);
    ws['!cols'] = s.headers.map(() => ({ wch: 22 }));
    XLSX.utils.book_append_sheet(wb, ws, s.name);
  }
  const buf = Buffer.from(XLSX.write(wb, { type: 'array', bookType: 'xlsx' }));
  res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  res.setHeader('Content-Disposition', 'attachment; filename*=UTF-8\'\'%D9%86%D9%85%D9%88%D8%B0%D8%AC_%D8%A7%D9%84%D8%A7%D8%B3%D8%AA%D9%8A%D8%B1%D8%A7%D8%AF.xlsx');
  res.send(buf);
});

// ── Import ─────────────────────────────────────────────────────────────────
function parseSheet(wb, name) {
  const ws = wb.Sheets[name];
  if (!ws) return [];
  return XLSX.utils.sheet_to_json(ws, { defval: '' });
}

app.post('/api/import/preview', auth, adminOnly, upload.single('file'), wrap(async (req, res) => {
  if (!req.file) return res.status(400).json({ message: 'لم يتم رفع ملف' });
  const wb = XLSX.read(req.file.buffer, { type: 'buffer', cellDates: true });
  const villas      = parseSheet(wb, 'الفلل');
  const apartments  = parseSheet(wb, 'الشقق');
  const tenants     = parseSheet(wb, 'المستأجرين');
  const leases      = parseSheet(wb, 'العقود');
  const installments= parseSheet(wb, 'الدفعات');
  const errors = [];
  villas.forEach((r, i) => { if (!r['اسم الفيلا *']) errors.push(`الفلل - صف ${i+2}: اسم الفيلا مطلوب`); });
  apartments.forEach((r, i) => {
    if (!r['اسم الفيلا *']) errors.push(`الشقق - صف ${i+2}: اسم الفيلا مطلوب`);
    if (!r['رقم الشقة *'])  errors.push(`الشقق - صف ${i+2}: رقم الشقة مطلوب`);
  });
  tenants.forEach((r, i) => { if (!r['الاسم *']) errors.push(`المستأجرين - صف ${i+2}: الاسم مطلوب`); });
  leases.forEach((r, i) => {
    if (!r['اسم الفيلا *'])     errors.push(`العقود - صف ${i+2}: اسم الفيلا مطلوب`);
    if (!r['رقم الشقة *'])      errors.push(`العقود - صف ${i+2}: رقم الشقة مطلوب`);
    if (!r['اسم المستأجر *'])   errors.push(`العقود - صف ${i+2}: اسم المستأجر مطلوب`);
    if (!r['تاريخ البداية *'])  errors.push(`العقود - صف ${i+2}: تاريخ البداية مطلوب`);
    if (!r['تاريخ النهاية *'])  errors.push(`العقود - صف ${i+2}: تاريخ النهاية مطلوب`);
    if (!r['إجمالي الإيجار *']) errors.push(`العقود - صف ${i+2}: إجمالي الإيجار مطلوب`);
  });
  installments.forEach((r, i) => {
    if (!r['اسم الفيلا *'])       errors.push(`الدفعات - صف ${i+2}: اسم الفيلا مطلوب`);
    if (!r['رقم الشقة *'])        errors.push(`الدفعات - صف ${i+2}: رقم الشقة مطلوب`);
    if (!r['اسم المستأجر *'])     errors.push(`الدفعات - صف ${i+2}: اسم المستأجر مطلوب`);
    if (!r['تاريخ الاستحقاق *']) errors.push(`الدفعات - صف ${i+2}: تاريخ الاستحقاق مطلوب`);
    if (!r['المبلغ *'])           errors.push(`الدفعات - صف ${i+2}: المبلغ مطلوب`);
  });
  ok(res, { villas, apartments, tenants, leases, installments, errors,
    counts: { villas: villas.length, apartments: apartments.length, tenants: tenants.length, leases: leases.length, installments: installments.length } });
}));

function toDate(v) {
  if (!v) return null;
  if (v instanceof Date) return isNaN(v) ? null : v.toISOString().slice(0, 10);
  // normalize Arabic-Indic and Persian digits to ASCII
  let s = String(v).trim().replace(/[٠-٩]/g, d => String(d.charCodeAt(0) - 0x0660))
                          .replace(/[۰-۹]/g, d => String(d.charCodeAt(0) - 0x06F0));
  if (/^\d{4}-\d{2}-\d{2}$/.test(s)) return s;
  // dd/mm/yyyy or dd-mm-yyyy → yyyy-mm-dd
  const m = s.match(/^(\d{1,2})[/-](\d{1,2})[/-](\d{4})$/);
  if (m) { const [, dd, mm, yy] = m; return `${yy}-${mm.padStart(2,'0')}-${dd.padStart(2,'0')}`; }
  const d = new Date(s);
  return isNaN(d) ? null : d.toISOString().slice(0, 10);
}

app.post('/api/import/confirm', auth, adminOnly, upload.single('file'), wrap(async (req, res) => {
  if (!req.file) return res.status(400).json({ message: 'لم يتم رفع ملف' });
  const wb = XLSX.read(req.file.buffer, { type: 'buffer', cellDates: true });
  const villaRows  = parseSheet(wb, 'الفلل').filter(r => r['اسم الفيلا *']);
  const aptRows    = parseSheet(wb, 'الشقق').filter(r => r['اسم الفيلا *'] && r['رقم الشقة *']);
  const tenRows    = parseSheet(wb, 'المستأجرين').filter(r => r['الاسم *']);
  const leaseRows  = parseSheet(wb, 'العقود').filter(r => r['اسم الفيلا *'] && r['رقم الشقة *'] && r['اسم المستأجر *']);
  const instRows   = parseSheet(wb, 'الدفعات').filter(r => r['اسم الفيلا *'] && r['رقم الشقة *'] && r['اسم المستأجر *'] && r['المبلغ *']);
  const conn = await pool.getConnection();
  const report = { villas:0, apartments:0, tenants:0, leases:0, installments:0, skipped:[] };
  try {
    await conn.beginTransaction();
    const villaMap = {};
    for (const r of villaRows) {
      const name = String(r['اسم الفيلا *']).trim();
      const [[ex]] = await conn.query('SELECT id FROM villas WHERE name=?', [name]);
      if (ex) { villaMap[name] = ex.id; report.skipped.push(`فيلا "${name}" موجودة بالفعل`); continue; }
      const [ins] = await conn.query('INSERT INTO villas (name,area,notes) VALUES (?,?,?)', [name, r['المنطقة']||null, r['ملاحظات']||null]);
      villaMap[name] = ins.insertId; report.villas++;
    }
    const [existingVillas] = await conn.query('SELECT id, name FROM villas');
    existingVillas.forEach(v => { if (!villaMap[v.name]) villaMap[v.name] = v.id; });
    const aptMap = {};
    for (const r of aptRows) {
      const vName = String(r['اسم الفيلا *']).trim(), aptNo = String(r['رقم الشقة *']).trim();
      const vid = villaMap[vName];
      if (!vid) { report.skipped.push(`شقة ${aptNo}: فيلا "${vName}" غير موجودة`); continue; }
      const [[ex]] = await conn.query('SELECT id FROM apartments WHERE villa_id=? AND apartment_no=?', [vid, aptNo]);
      if (ex) { aptMap[`${vName}|${aptNo}`] = ex.id; report.skipped.push(`شقة ${aptNo} في "${vName}" موجودة بالفعل`); continue; }
      const balcony = String(r['بلكونة (نعم/لا)']||'').trim() === 'نعم' ? 1 : 0;
      const [ins] = await conn.query('INSERT INTO apartments (villa_id,apartment_no,apt_type,bathrooms,has_balcony,floor,notes) VALUES (?,?,?,?,?,?,?)',
        [vid, aptNo, r['نوع الشقة']||null, Number(r['عدد الحمامات'])||1, balcony, r['الدور']||null, r['ملاحظات']||null]);
      aptMap[`${vName}|${aptNo}`] = ins.insertId; report.apartments++;
    }
    const [existingApts] = await conn.query('SELECT a.id, a.apartment_no, v.name villa_name FROM apartments a JOIN villas v ON v.id=a.villa_id');
    existingApts.forEach(a => { const k=`${a.villa_name}|${a.apartment_no}`; if(!aptMap[k]) aptMap[k]=a.id; });
    const tenMap = {};
    for (const r of tenRows) {
      const name = String(r['الاسم *']).trim();
      const [[ex]] = await conn.query('SELECT id FROM tenants WHERE name=?', [name]);
      if (ex) { tenMap[name] = ex.id; report.skipped.push(`مستأجر "${name}" موجود بالفعل`); continue; }
      const [ins] = await conn.query('INSERT INTO tenants (name,phone,national_id,car_number,email,notes) VALUES (?,?,?,?,?,?)',
        [name, r['الهاتف']||null, r['رقم الهوية']||null, r['رقم السيارة']||null, r['الإيميل']||null, r['ملاحظات']||null]);
      tenMap[name] = ins.insertId; report.tenants++;
    }
    const [existingTens] = await conn.query('SELECT id, name FROM tenants');
    existingTens.forEach(t => { if(!tenMap[t.name]) tenMap[t.name]=t.id; });
    const leaseMap = {};
    for (const r of leaseRows) {
      const vName=String(r['اسم الفيلا *']).trim(), aptNo=String(r['رقم الشقة *']).trim(), tName=String(r['اسم المستأجر *']).trim();
      const aptId=aptMap[`${vName}|${aptNo}`], tenId=tenMap[tName];
      if (!aptId) { report.skipped.push(`عقد: شقة ${aptNo} في "${vName}" غير موجودة`); continue; }
      if (!tenId) { report.skipped.push(`عقد: مستأجر "${tName}" غير موجود`); continue; }
      const startDate=toDate(r['تاريخ البداية *']), endDate=toDate(r['تاريخ النهاية *']);
      if (!startDate || !endDate) { report.skipped.push(`عقد "${tName}" في شقة ${aptNo}: تاريخ غير صالح (استخدم صيغة YYYY-MM-DD)`); continue; }
      const [[ex]] = await conn.query('SELECT id FROM leases WHERE apartment_id=? AND tenant_id=? AND start_date=?', [aptId, tenId, startDate]);
      if (ex) { leaseMap[`${vName}|${aptNo}|${tName}`]=ex.id; report.skipped.push(`عقد "${tName}" في شقة ${aptNo} موجود بالفعل`); continue; }
      const isActive = endDate >= new Date().toISOString().slice(0,10) ? 1 : 0;
      const [ins] = await conn.query('INSERT INTO leases (apartment_id,tenant_id,start_date,end_date,total_amount,notes,is_active) VALUES (?,?,?,?,?,?,?)',
        [aptId, tenId, startDate, endDate, Number(r['إجمالي الإيجار *'])||0, r['ملاحظات']||null, isActive]);
      leaseMap[`${vName}|${aptNo}|${tName}`]=ins.insertId; report.leases++;
    }
    const [existingLeases] = await conn.query('SELECT l.id, a.apartment_no, v.name villa_name, t.name tenant_name FROM leases l JOIN apartments a ON a.id=l.apartment_id JOIN villas v ON v.id=a.villa_id JOIN tenants t ON t.id=l.tenant_id');
    existingLeases.forEach(l => { const k=`${l.villa_name}|${l.apartment_no}|${l.tenant_name}`; if(!leaseMap[k]) leaseMap[k]=l.id; });
    for (const r of instRows) {
      const vName=String(r['اسم الفيلا *']).trim(), aptNo=String(r['رقم الشقة *']).trim(), tName=String(r['اسم المستأجر *']).trim();
      const leaseId=leaseMap[`${vName}|${aptNo}|${tName}`];
      if (!leaseId) { report.skipped.push(`دفعة: لم يُعثر على عقد لـ"${tName}" في شقة ${aptNo}`); continue; }
      const dueDate=toDate(r['تاريخ الاستحقاق *']), amount=Number(r['المبلغ *'])||0;
      if (!dueDate) { report.skipped.push(`دفعة لـ"${tName}" في شقة ${aptNo}: تاريخ استحقاق غير صالح (استخدم صيغة YYYY-MM-DD)`); continue; }
      const [[ex]] = await conn.query('SELECT id FROM lease_installments WHERE lease_id=? AND due_date=? AND amount=?', [leaseId, dueDate, amount]);
      if (ex) {
        const payDate=toDate(r['تاريخ الدفع (فارغ = لم يُدفع)']);
        if (payDate) {
          const [[paid]] = await conn.query('SELECT id FROM installment_payments WHERE installment_id=? AND payment_date=?', [ex.id, payDate]);
          if (!paid) { await conn.query('INSERT INTO installment_payments (installment_id,amount,payment_date,notes) VALUES (?,?,?,?)', [ex.id, amount, payDate, r['ملاحظات']||null]); report.installments++; }
        }
        report.skipped.push(`قسط بتاريخ ${dueDate} للعقد موجود بالفعل`); continue;
      }
      const [ins] = await conn.query('INSERT INTO lease_installments (lease_id,due_date,amount,notes) VALUES (?,?,?,?)', [leaseId, dueDate, amount, r['ملاحظات']||null]);
      const payDate=toDate(r['تاريخ الدفع (فارغ = لم يُدفع)']);
      if (payDate) await conn.query('INSERT INTO installment_payments (installment_id,amount,payment_date,notes) VALUES (?,?,?,?)', [ins.insertId, amount, payDate, r['ملاحظات']||null]);
      report.installments++;
    }
    await conn.commit();
    ok(res, report);
  } catch(e) { await conn.rollback(); throw e; }
  finally { conn.release(); }
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
  // surface common data-shape errors with a helpful Arabic message
  const DATA_ERRORS = {
    ER_BAD_NULL_ERROR: 'حقل مطلوب فارغ أو بقيمة غير صالحة (تحقق من التواريخ والمبالغ)',
    ER_TRUNCATED_WRONG_VALUE: 'قيمة غير صالحة في أحد الحقول (غالباً تاريخ بصيغة خاطئة — استخدم YYYY-MM-DD)',
    ER_TRUNCATED_WRONG_VALUE_FOR_FIELD: 'قيمة غير صالحة في أحد الحقول (تحقق من صيغة التواريخ والأرقام)',
    ER_DATA_TOO_LONG: 'إحدى القيم أطول من المسموح في أحد الحقول',
    WARN_DATA_TRUNCATED: 'قيمة غير صالحة في أحد الحقول',
  };
  if (DATA_ERRORS[err.code]) return res.status(400).json({ message: DATA_ERRORS[err.code] });
  const status = err.status || (err.code === 'ER_NO_REFERENCED_ROW_2' ? 400 : 500);
  if (status === 500) console.error(err);
  res.status(status).json({ message: status === 500 ? 'Internal server error' : err.message });
});

process.on('unhandledRejection', (err) => console.error('Unhandled rejection:', err));

// auto-apply idempotent schema migrations on startup, then start the server
runMigrations()
  .catch(err => console.error('[migrate] continuing despite error:', err.message))
  .finally(() => app.listen(process.env.PORT || 4000, () => console.log('API running')));

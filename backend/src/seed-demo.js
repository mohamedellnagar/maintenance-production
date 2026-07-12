// One-off demo seeder — loads demo data with correct utf8mb4 encoding.
// Run inside the demo backend container:  node src/seed-demo.js
// It drops all existing tables in the target DB, then loads database/demo-full.sql
// fetched from GitHub (raw), so Arabic text is preserved (unlike console paste).
import mysql from 'mysql2/promise';

const RAW_URL = process.env.DEMO_SQL_URL
  || 'https://raw.githubusercontent.com/mohamedellnagar/maintenance-production/main/database/demo-full.sql';

async function main() {
  console.log('[seed] fetching demo SQL from', RAW_URL);
  const res = await fetch(RAW_URL);
  if (!res.ok) throw new Error('fetch failed: HTTP ' + res.status);
  const sql = await res.text();
  console.log('[seed] fetched', sql.length, 'bytes');

  const conn = await mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    port: Number(process.env.DB_PORT || 3306),
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME,
    multipleStatements: true,
    charset: 'utf8mb4',
  });
  console.log('[seed] connected to', process.env.DB_NAME);

  // wipe existing tables (handles the previously corrupted load)
  await conn.query('SET FOREIGN_KEY_CHECKS=0');
  const [tables] = await conn.query(
    'SELECT table_name t FROM information_schema.tables WHERE table_schema = DATABASE()');
  for (const row of tables) {
    const t = row.t || row.T || row.table_name || row.TABLE_NAME;
    await conn.query('DROP TABLE IF EXISTS `' + t + '`');
  }
  await conn.query('SET FOREIGN_KEY_CHECKS=1');
  console.log('[seed] dropped', tables.length, 'old table(s)');

  // load schema + demo data (utf8mb4 preserved end-to-end)
  await conn.query(sql);
  const [[{ n }]] = await conn.query('SELECT COUNT(*) n FROM tenants');
  const [[t]] = await conn.query('SELECT name, car_number FROM tenants LIMIT 1');
  console.log('[seed] done — tenants:', n, '| sample:', t.name, '/', t.car_number);
  await conn.end();
}

main().then(() => process.exit(0)).catch(e => { console.error('[seed] FAILED:', e.message); process.exit(1); });

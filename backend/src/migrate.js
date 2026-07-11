// Idempotent schema migrations — run automatically on backend startup.
// Adds missing columns/tables only; never drops or modifies existing data.
import { pool } from './config/db.js';

// columns to ensure exist: [table, column, DDL]
const COLUMNS = [
  ['apartments', 'apt_type', "apt_type VARCHAR(50) NULL"],
  ['apartments', 'bathrooms', "bathrooms TINYINT UNSIGNED NOT NULL DEFAULT 1"],
  ['apartments', 'has_balcony', "has_balcony BOOLEAN NOT NULL DEFAULT FALSE"],
  ['apartments', 'rental_status', "rental_status ENUM('available','rented') NOT NULL DEFAULT 'available'"],
  ['leases', 'fees_amount', "fees_amount DECIMAL(12,2) NOT NULL DEFAULT 0"],
  ['leases', 'deposit_amount', "deposit_amount DECIMAL(12,2) NOT NULL DEFAULT 0"],
  ['leases', 'deposit_type', "deposit_type ENUM('cash','check') NULL"],
  ['leases', 'deposit_notes', "deposit_notes VARCHAR(255) NULL"],
  ['leases', 'terminated_at', "terminated_at DATE NULL DEFAULT NULL"],
  ['lease_installments', 'is_cancelled', "is_cancelled TINYINT(1) NOT NULL DEFAULT 0"],
  ['installment_payments', 'created_by', "created_by BIGINT NULL"],
  ['tenants', 'car_number', "car_number VARCHAR(50) NULL"],
  ['stock_movements', 'apartment_id', "apartment_id BIGINT NULL"],
];

const TABLES = [
  `CREATE TABLE IF NOT EXISTS suppliers (
    id BIGINT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(150) NOT NULL, phone VARCHAR(50) NULL,
    notes TEXT NULL, is_active BOOLEAN NOT NULL DEFAULT TRUE, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  ) CHARACTER SET utf8mb4`,
  `CREATE TABLE IF NOT EXISTS inventory_items (
    id BIGINT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(150) NOT NULL, unit VARCHAR(30) NOT NULL DEFAULT 'قطعة',
    category VARCHAR(80) NULL, reorder_level DECIMAL(12,2) NOT NULL DEFAULT 0, notes TEXT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  ) CHARACTER SET utf8mb4`,
  `CREATE TABLE IF NOT EXISTS stock_movements (
    id BIGINT PRIMARY KEY AUTO_INCREMENT, item_id BIGINT NOT NULL,
    type ENUM('purchase','consume','adjust') NOT NULL, quantity DECIMAL(12,2) NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL DEFAULT 0, total_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    movement_date DATE NOT NULL, supplier_id BIGINT NULL, villa_id BIGINT NULL, record_id BIGINT NULL,
    notes TEXT NULL, created_by BIGINT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_mov_item FOREIGN KEY (item_id) REFERENCES inventory_items(id) ON DELETE CASCADE,
    CONSTRAINT fk_mov_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(id) ON DELETE SET NULL,
    CONSTRAINT fk_mov_villa FOREIGN KEY (villa_id) REFERENCES villas(id) ON DELETE SET NULL
  ) CHARACTER SET utf8mb4`,
];

export async function runMigrations() {
  let added = 0;
  try {
    for (const [table, column, ddl] of COLUMNS) {
      const [[{ n }]] = await pool.query(
        `SELECT COUNT(*) n FROM information_schema.columns
         WHERE table_schema = DATABASE() AND table_name = ? AND column_name = ?`, [table, column]);
      if (!n) {
        await pool.query(`ALTER TABLE \`${table}\` ADD COLUMN ${ddl}`);
        console.log(`[migrate] + ${table}.${column}`);
        added++;
      }
    }
    for (const ddl of TABLES) await pool.query(ddl);
    console.log(added ? `[migrate] done — ${added} column(s) added` : '[migrate] schema up to date');
  } catch (e) {
    console.error('[migrate] failed:', e.message);
    throw e;
  }
}

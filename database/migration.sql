-- ═══════════════════════════════════════════════════════════════════════════
-- Migration: sync production database with current code
-- آمن للتشغيل (idempotent): يتخطّى أي عمود أو جدول موجود مسبقاً.
-- شغّله مرة واحدة على قاعدة بيانات الإنتاج عند الديبلوي.
--   mysql -u USER -p DBNAME < database/migration.sql
-- ═══════════════════════════════════════════════════════════════════════════

-- helper: يضيف عموداً فقط إن لم يكن موجوداً
DELIMITER $$
DROP PROCEDURE IF EXISTS _addcol $$
CREATE PROCEDURE _addcol(IN tbl VARCHAR(64), IN col VARCHAR(64), IN ddl TEXT)
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns
      WHERE table_schema = DATABASE() AND table_name = tbl AND column_name = col) THEN
    SET @s = CONCAT('ALTER TABLE `', tbl, '` ADD COLUMN ', ddl);
    PREPARE st FROM @s; EXECUTE st; DEALLOCATE PREPARE st;
  END IF;
END $$
DELIMITER ;

-- ── الشقق: حقول النوع/الحمامات/البلكونة/حالة الإيجار ──
CALL _addcol('apartments', 'apt_type',      "apt_type VARCHAR(50) NULL");
CALL _addcol('apartments', 'bathrooms',     "bathrooms TINYINT UNSIGNED NOT NULL DEFAULT 1");
CALL _addcol('apartments', 'has_balcony',   "has_balcony BOOLEAN NOT NULL DEFAULT FALSE");
CALL _addcol('apartments', 'rental_status', "rental_status ENUM('available','rented') NOT NULL DEFAULT 'available'");

-- ── العقود: الرسوم + التأمين + الإنهاء المبكر ──
CALL _addcol('leases', 'fees_amount',    "fees_amount DECIMAL(12,2) NOT NULL DEFAULT 0");
CALL _addcol('leases', 'deposit_amount', "deposit_amount DECIMAL(12,2) NOT NULL DEFAULT 0");
CALL _addcol('leases', 'deposit_type',   "deposit_type ENUM('cash','check') NULL");
CALL _addcol('leases', 'deposit_notes',  "deposit_notes VARCHAR(255) NULL");
CALL _addcol('leases', 'terminated_at',  "terminated_at DATE NULL DEFAULT NULL");

-- ── الدفعات: إلغاء القسط + مَن سجّل الدفعة ──
CALL _addcol('lease_installments',   'is_cancelled', "is_cancelled TINYINT(1) NOT NULL DEFAULT 0");
CALL _addcol('installment_payments', 'created_by',   "created_by BIGINT NULL");

-- ── المستأجرون: رقم السيارة ──
CALL _addcol('tenants', 'car_number', "car_number VARCHAR(50) NULL");

DROP PROCEDURE IF EXISTS _addcol;

-- ── المخزن: جداول جديدة (CREATE IF NOT EXISTS آمن) ──
CREATE TABLE IF NOT EXISTS suppliers (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  phone VARCHAR(50) NULL,
  notes TEXT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) CHARACTER SET utf8mb4;

CREATE TABLE IF NOT EXISTS inventory_items (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  unit VARCHAR(30) NOT NULL DEFAULT 'قطعة',
  category VARCHAR(80) NULL,
  reorder_level DECIMAL(12,2) NOT NULL DEFAULT 0,
  notes TEXT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) CHARACTER SET utf8mb4;

CREATE TABLE IF NOT EXISTS stock_movements (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  item_id BIGINT NOT NULL,
  type ENUM('purchase','consume','adjust') NOT NULL,
  quantity DECIMAL(12,2) NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL DEFAULT 0,
  total_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
  movement_date DATE NOT NULL,
  supplier_id BIGINT NULL,
  villa_id BIGINT NULL,
  record_id BIGINT NULL,
  notes TEXT NULL,
  created_by BIGINT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_mov_item     FOREIGN KEY (item_id)     REFERENCES inventory_items(id) ON DELETE CASCADE,
  CONSTRAINT fk_mov_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(id)       ON DELETE SET NULL,
  CONSTRAINT fk_mov_villa    FOREIGN KEY (villa_id)    REFERENCES villas(id)          ON DELETE SET NULL
) CHARACTER SET utf8mb4;

-- ── صلاحيات المشرف: أضف المخزن للصفحات المسموحة (اختياري) ──
-- UPDATE role_permissions
--   SET allowed_pages = JSON_ARRAY_APPEND(allowed_pages,'$','inventory')
--   WHERE role='SUPERVISOR' AND JSON_SEARCH(allowed_pages,'one','inventory') IS NULL;

-- ============================================================================
-- Migration: Lease termination + deposit/fees fields
-- Date: 2026-07-08
-- Safe/idempotent: only adds columns that don't already exist.
-- Run against the PRODUCTION database (e.g. maintenance-db).
-- ============================================================================

DELIMITER $$

DROP PROCEDURE IF EXISTS _add_col_if_missing $$
CREATE PROCEDURE _add_col_if_missing(
  IN p_table VARCHAR(64), IN p_col VARCHAR(64), IN p_def TEXT)
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = p_table
      AND COLUMN_NAME = p_col
  ) THEN
    SET @ddl = CONCAT('ALTER TABLE `', p_table, '` ADD COLUMN `', p_col, '` ', p_def);
    PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;
  END IF;
END $$

DELIMITER ;

-- leases: fees, deposit, termination
CALL _add_col_if_missing('leases', 'fees_amount',   "DECIMAL(12,2) NOT NULL DEFAULT 0");
CALL _add_col_if_missing('leases', 'deposit_amount', "DECIMAL(12,2) NOT NULL DEFAULT 0");
CALL _add_col_if_missing('leases', 'deposit_type',   "ENUM('cash','check') NULL");
CALL _add_col_if_missing('leases', 'deposit_notes',  "VARCHAR(255) NULL");
CALL _add_col_if_missing('leases', 'terminated_at',  "DATE NULL DEFAULT NULL");

-- lease_installments: cancellation flag
CALL _add_col_if_missing('lease_installments', 'is_cancelled', "TINYINT(1) NOT NULL DEFAULT 0");

-- apartments: type / bathrooms / balcony / rental status (needed by import + apt CRUD)
CALL _add_col_if_missing('apartments', 'apt_type',      "VARCHAR(50) NULL");
CALL _add_col_if_missing('apartments', 'bathrooms',     "TINYINT UNSIGNED NOT NULL DEFAULT 1");
CALL _add_col_if_missing('apartments', 'has_balcony',   "BOOLEAN NOT NULL DEFAULT FALSE");
CALL _add_col_if_missing('apartments', 'rental_status', "ENUM('available','rented') NOT NULL DEFAULT 'available'");

DROP PROCEDURE IF EXISTS _add_col_if_missing;

-- Verify
SELECT 'leases' tbl, COLUMN_NAME, COLUMN_TYPE
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'leases'
  AND COLUMN_NAME IN ('fees_amount','deposit_amount','deposit_type','deposit_notes','terminated_at')
UNION ALL
SELECT 'lease_installments', COLUMN_NAME, COLUMN_TYPE
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'lease_installments'
  AND COLUMN_NAME = 'is_cancelled'
UNION ALL
SELECT 'apartments', COLUMN_NAME, COLUMN_TYPE
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'apartments'
  AND COLUMN_NAME IN ('apt_type','bathrooms','has_balcony','rental_status');

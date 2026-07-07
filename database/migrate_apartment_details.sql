-- Run this once on existing databases
ALTER TABLE apartments
  ADD COLUMN apt_type VARCHAR(50) NULL AFTER apartment_no,
  ADD COLUMN bathrooms TINYINT UNSIGNED NOT NULL DEFAULT 1 AFTER apt_type,
  ADD COLUMN has_balcony BOOLEAN NOT NULL DEFAULT FALSE AFTER bathrooms,
  ADD COLUMN rental_status ENUM('available','rented') NOT NULL DEFAULT 'available' AFTER has_balcony;

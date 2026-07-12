-- ملف ديمو كامل: قاعدة + جداول + بيانات تجريبية — الصقه مرة واحدة في MySQL
CREATE DATABASE IF NOT EXISTS `demo-db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `demo-db`;


CREATE TABLE users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('ADMIN','SUPERVISOR') NOT NULL DEFAULT 'SUPERVISOR',
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE villas (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  area VARCHAR(150),
  notes TEXT,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE apartments (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  villa_id BIGINT NOT NULL,
  apartment_no VARCHAR(60) NOT NULL,
  apt_type VARCHAR(50) NULL,
  bathrooms TINYINT UNSIGNED NOT NULL DEFAULT 1,
  has_balcony BOOLEAN NOT NULL DEFAULT FALSE,
  rental_status ENUM('available','rented') NOT NULL DEFAULT 'available',
  floor VARCHAR(60),
  notes TEXT,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_apartments_villa FOREIGN KEY (villa_id) REFERENCES villas(id) ON DELETE CASCADE,
  UNIQUE KEY unique_apartment_per_villa (villa_id, apartment_no)
);

CREATE TABLE technicians (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  specialty VARCHAR(100),
  phone VARCHAR(50),
  notes TEXT,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE maintenance_records (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  record_date DATE NOT NULL,
  villa_id BIGINT NOT NULL,
  apartment_id BIGINT NULL,
  description TEXT NOT NULL,
  issue_type VARCHAR(20) NULL,
  technician_id BIGINT NOT NULL,
  reported_time TIME NULL,
  completed_time TIME NULL,
  spare_part VARCHAR(150),
  spare_part_cost DECIMAL(10,2) NOT NULL DEFAULT 0,
  notes TEXT,
  created_by BIGINT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_records_villa FOREIGN KEY (villa_id) REFERENCES villas(id),
  CONSTRAINT fk_records_apartment FOREIGN KEY (apartment_id) REFERENCES apartments(id),
  CONSTRAINT fk_records_technician FOREIGN KEY (technician_id) REFERENCES technicians(id),
  CONSTRAINT fk_records_user FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE record_technicians (
  record_id BIGINT NOT NULL,
  technician_id BIGINT NOT NULL,
  PRIMARY KEY (record_id, technician_id),
  CONSTRAINT fk_rt_record FOREIGN KEY (record_id) REFERENCES maintenance_records(id) ON DELETE CASCADE,
  CONSTRAINT fk_rt_technician FOREIGN KEY (technician_id) REFERENCES technicians(id)
);

CREATE TABLE role_permissions (
  role VARCHAR(20) PRIMARY KEY,
  allowed_pages JSON NOT NULL
);

INSERT INTO role_permissions (role, allowed_pages) VALUES
('SUPERVISOR', '["dashboard","records","villas","apartments","technicians","tenants_mgmt","leases","payments_tracker"]');

CREATE TABLE tenants (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  phone VARCHAR(30) NULL,
  national_id VARCHAR(50) NULL,
  car_number VARCHAR(50) NULL,
  email VARCHAR(150) NULL,
  notes TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE leases (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  apartment_id BIGINT NOT NULL,
  tenant_id BIGINT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  total_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
  fees_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
  deposit_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
  deposit_type ENUM('cash','check') NULL,
  deposit_notes VARCHAR(255) NULL,
  notes TEXT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  terminated_at DATE NULL DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_lease_apt FOREIGN KEY (apartment_id) REFERENCES apartments(id),
  CONSTRAINT fk_lease_tenant FOREIGN KEY (tenant_id) REFERENCES tenants(id)
);

CREATE TABLE lease_installments (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  lease_id BIGINT NOT NULL,
  due_date DATE NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  notes TEXT NULL,
  is_cancelled TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_inst_lease FOREIGN KEY (lease_id) REFERENCES leases(id) ON DELETE CASCADE
);

CREATE TABLE installment_payments (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  installment_id BIGINT NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  payment_date DATE NOT NULL,
  notes TEXT NULL,
  created_by BIGINT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_pay_inst FOREIGN KEY (installment_id) REFERENCES lease_installments(id) ON DELETE CASCADE
);

INSERT INTO users (name,email,password_hash,role) VALUES
('System Admin','admin@maintenance.local','$2a$10$aYeVnct/d.iH8u9uJMvmY.7yw692laU.Br.4qouKtjo4oM9slKNtS','ADMIN');
-- password: Admin@12345

INSERT INTO villas(name, area) VALUES ('فيلا التميمي','دبي'),('فيلا الجوهري','دبي'),('فيلا المنصوري','دبي');
INSERT INTO apartments(villa_id, apartment_no, floor) VALUES (1,'1','أرضي'),(1,'2','أول'),(2,'1','أرضي'),(3,'4','ثاني');
INSERT INTO technicians(name, specialty) VALUES ('غزال','تكييف'),('سند','تكييف'),('فريد','سباكة'),('معاذ','كهرباء'),('عبد الرافع','عام');


-- ═══ Inventory / Warehouse (المخزن) ═══
CREATE TABLE suppliers (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  phone VARCHAR(50) NULL,
  notes TEXT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE inventory_items (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  unit VARCHAR(30) NOT NULL DEFAULT 'قطعة',
  category VARCHAR(80) NULL,
  reorder_level DECIMAL(12,2) NOT NULL DEFAULT 0,
  notes TEXT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE stock_movements (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  item_id BIGINT NOT NULL,
  type ENUM('purchase','consume','adjust') NOT NULL,
  quantity DECIMAL(12,2) NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL DEFAULT 0,
  total_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
  movement_date DATE NOT NULL,
  supplier_id BIGINT NULL,
  villa_id BIGINT NULL,
  apartment_id BIGINT NULL,
  record_id BIGINT NULL,
  notes TEXT NULL,
  created_by BIGINT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_mov_item FOREIGN KEY (item_id) REFERENCES inventory_items(id) ON DELETE CASCADE,
  CONSTRAINT fk_mov_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(id) ON DELETE SET NULL,
  CONSTRAINT fk_mov_villa FOREIGN KEY (villa_id) REFERENCES villas(id) ON DELETE SET NULL
);

-- ═══════════════════════════════════════════════════════════════════════════
-- بيانات تجريبية (Demo) — تُشغَّل بعد schema.sql على قاعدة بيانات نظيفة للديمو.
-- تفترض أن schema.sql أنشأ: admin(1)، villas(1-3)، apartments(1-4)، technicians(1-5).
--   mysql -u USER -p DEMO_DB < database/schema.sql
--   mysql -u USER -p DEMO_DB < database/demo-seed.sql
-- ملاحظة: التواريخ مضبوطة لإظهار كل الحالات (نشط/منتهي/قيد التدقيق/متأخر).
-- ═══════════════════════════════════════════════════════════════════════════

-- ── شقق إضافية ──
INSERT INTO apartments (villa_id, apartment_no, apt_type, bathrooms, has_balcony, floor) VALUES
 (1,'3','غرفتان وصالة',2,1,'ثاني'),      -- id 5
 (2,'2','ثلاث غرف وصالة',3,1,'أول'),      -- id 6
 (2,'3','استوديو',1,0,'أرضي'),            -- id 7
 (3,'1','غرفتان وصالة',2,1,'أرضي'),       -- id 8
 (3,'2','غرفة وصالة',1,0,'أول');          -- id 9

-- ── مستأجرون (مع رقم السيارة) ──
INSERT INTO tenants (name, phone, national_id, car_number, email, notes) VALUES
 ('أحمد خالد المطيري','0501112233','784-1988-1234567-1','دبي A 45231','ahmed@demo.com',''),   -- 1
 ('سارة محمد النعيمي','0559876543','784-1990-7654321-2','دبي B 12098','sara@demo.com',''),     -- 2
 ('عبدالله يوسف الشامسي','0521234567','784-1985-1122334-3','أبوظبي 55210','',''),              -- 3
 ('نورة سالم الكعبي','0563334455','784-1992-9988776-4','دبي C 78450','noura@demo.com','عميلة مميزة'), -- 4
 ('فيصل راشد الظاهري','0509998877','784-1987-4455667-5','الشارقة 33019','',''),                -- 5
 ('مريم علي البلوشي','0554445566','784-1995-6677889-6','دبي D 90210','maryam@demo.com','');    -- 6

-- ── عقود + دفعات + مدفوعات (تُظهر كل الحالات) ──

-- عقد 1: نشط على المسار — فيلا التميمي شقة 1، أحمد. (سنوي 60000، ربع سنوي 15000)
INSERT INTO leases (apartment_id,tenant_id,start_date,end_date,total_amount,fees_amount,deposit_amount,deposit_type,deposit_notes,is_active) VALUES
 (1,1,'2026-04-01','2027-03-31',60000,1000,15000,'cash','تأمين نقدي',1);
SET @l1=LAST_INSERT_ID();
INSERT INTO lease_installments (lease_id,due_date,amount) VALUES
 (@l1,'2026-04-01',15000),(@l1,'2026-07-01',15000),(@l1,'2026-10-01',15000),(@l1,'2027-01-01',15000);
INSERT INTO installment_payments (installment_id,amount,payment_date,created_by)
 SELECT id,15000,'2026-04-03',1 FROM lease_installments WHERE lease_id=@l1 AND due_date='2026-04-01';

-- عقد 2: نشط به متأخرات — فيلا الجوهري شقة 1، سارة.
INSERT INTO leases (apartment_id,tenant_id,start_date,end_date,total_amount,is_active) VALUES
 (3,2,'2026-01-01','2026-12-31',48000,1);
SET @l2=LAST_INSERT_ID();
INSERT INTO lease_installments (lease_id,due_date,amount) VALUES
 (@l2,'2026-01-01',12000),(@l2,'2026-04-01',12000),(@l2,'2026-07-01',12000),(@l2,'2026-10-01',12000);
INSERT INTO installment_payments (installment_id,amount,payment_date,created_by)
 SELECT id,12000,'2026-01-05',1 FROM lease_installments WHERE lease_id=@l2 AND due_date='2026-01-01';

-- عقد 3: منتهٍ ومدفوع بالكامل — فيلا التميمي شقة 2، عبدالله.
INSERT INTO leases (apartment_id,tenant_id,start_date,end_date,total_amount,is_active) VALUES
 (2,3,'2025-01-01','2026-01-01',36000,0);
SET @l3=LAST_INSERT_ID();
INSERT INTO lease_installments (lease_id,due_date,amount) VALUES
 (@l3,'2025-01-01',9000),(@l3,'2025-04-01',9000),(@l3,'2025-07-01',9000),(@l3,'2025-10-01',9000);
INSERT INTO installment_payments (installment_id,amount,payment_date,created_by)
 SELECT id,9000,DATE_ADD(due_date,INTERVAL 3 DAY),1 FROM lease_installments WHERE lease_id=@l3;

-- عقد 4: قيد التدقيق (منتهت المدة + متأخرات غير محصّلة) — فيلا المنصوري شقة 1، نورة.
INSERT INTO leases (apartment_id,tenant_id,start_date,end_date,total_amount,is_active) VALUES
 (8,4,'2025-06-01','2026-06-01',48000,1);
SET @l4=LAST_INSERT_ID();
INSERT INTO lease_installments (lease_id,due_date,amount) VALUES
 (@l4,'2025-06-01',12000),(@l4,'2025-09-01',12000),(@l4,'2025-12-01',12000),(@l4,'2026-03-01',12000);
INSERT INTO installment_payments (installment_id,amount,payment_date,created_by)
 SELECT id,12000,'2025-06-04',1 FROM lease_installments WHERE lease_id=@l4 AND due_date='2025-06-01';

-- عقد 5: نشط بتأمين شيك — فيلا الجوهري شقة 2، فيصل.
INSERT INTO leases (apartment_id,tenant_id,start_date,end_date,total_amount,fees_amount,deposit_amount,deposit_type,deposit_notes,is_active) VALUES
 (6,5,'2026-06-01','2027-05-31',72000,1500,8000,'check','شيك بنكي رقم 4471',1);
SET @l5=LAST_INSERT_ID();
INSERT INTO lease_installments (lease_id,due_date,amount) VALUES
 (@l5,'2026-06-01',18000),(@l5,'2026-09-01',18000),(@l5,'2026-12-01',18000),(@l5,'2027-03-01',18000);
INSERT INTO installment_payments (installment_id,amount,payment_date,created_by)
 SELECT id,18000,'2026-06-02',1 FROM lease_installments WHERE lease_id=@l5 AND due_date='2026-06-01';

-- ── سجلات صيانة ──
INSERT INTO maintenance_records (record_date,villa_id,apartment_id,description,issue_type,technician_id,reported_time,completed_time,spare_part,spare_part_cost,created_by) VALUES
 ('2026-07-02',1,1,'تسريب مياه أسفل الحوض','plumbing',3,'09:00','10:30','وصلة مرنة',45,1),
 ('2026-07-05',2,3,'انقطاع كهرباء في غرفة النوم','electricity',4,'14:00','15:15','قاطع كهرباء',120,1),
 ('2026-07-08',1,2,'صيانة دورية للتكييف','ac',1,'11:00','12:00','فلتر تكييف',80,1),
 ('2026-07-09',3,8,'باب المدخل لا يغلق','general',5,'16:00','16:45','قفل باب',150,1),
 ('2026-07-10',2,6,'دهان جدار الصالة','general',5,'10:00','13:00','دهان أبيض',200,1);
INSERT INTO record_technicians (record_id,technician_id)
 SELECT id,technician_id FROM maintenance_records;

-- ═══ المخزن ═══
INSERT INTO suppliers (name,phone,notes) VALUES
 ('مؤسسة النور للأدوات الصحية','0501112222','مورد رئيسي'),
 ('شركة الإمداد للكهربائيات','0509998888',''),
 ('معرض الخليج للدهانات','0561234567','');

INSERT INTO inventory_items (name,unit,category,reorder_level,notes) VALUES
 ('مواسير PVC 2 بوصة','متر','سباكة',20,''),          -- 1
 ('كابل كهرباء 2.5مم','لفة','كهرباء',5,''),           -- 2
 ('دهان أبيض','علبة','دهانات',10,''),                 -- 3
 ('صنبور مياه','قطعة','سباكة',8,''),                  -- 4
 ('لمبة LED 9 واط','قطعة','كهرباء',30,''),            -- 5
 ('قفل باب','قطعة','عام',6,'');                        -- 6

-- مشتريات (تبني المخزون والقيمة)
INSERT INTO stock_movements (item_id,type,quantity,unit_price,total_amount,movement_date,supplier_id,created_by) VALUES
 (1,'purchase',100,8,800,'2026-06-01',1,1),
 (2,'purchase',15,120,1800,'2026-06-01',2,1),
 (3,'purchase',40,45,1800,'2026-06-05',3,1),
 (4,'purchase',30,35,1050,'2026-06-10',1,1),
 (5,'purchase',120,6,720,'2026-06-12',2,1),
 (6,'purchase',20,55,1100,'2026-06-15',1,1);

-- صرف (بعضه لفيلا عامة، بعضه لشقة محددة)
INSERT INTO stock_movements (item_id,type,quantity,unit_price,total_amount,movement_date,villa_id,apartment_id,notes,created_by) VALUES
 (1,'consume',12,8,96,'2026-07-02',1,1,'إصلاح تسريب',1),
 (4,'consume',2,35,70,'2026-07-02',1,1,'استبدال صنبور',1),
 (2,'consume',3,120,360,'2026-07-05',2,3,'إصلاح كهرباء',1),
 (3,'consume',5,45,225,'2026-07-10',2,6,'دهان الصالة',1),
 (5,'consume',25,6,150,'2026-07-06',3,NULL,'استبدال إنارة عامة للفيلا',1),
 (6,'consume',1,55,55,'2026-07-09',3,8,'استبدال قفل',1);

CREATE DATABASE IF NOT EXISTS maintenance_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE maintenance_db;

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
('SUPERVISOR', '["dashboard","records","villas","apartments","technicians","tenants_mgmt","leases"]');

CREATE TABLE tenants (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  phone VARCHAR(30) NULL,
  national_id VARCHAR(50) NULL,
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
  notes TEXT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
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
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_inst_lease FOREIGN KEY (lease_id) REFERENCES leases(id) ON DELETE CASCADE
);

CREATE TABLE installment_payments (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  installment_id BIGINT NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  payment_date DATE NOT NULL,
  notes TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_pay_inst FOREIGN KEY (installment_id) REFERENCES lease_installments(id) ON DELETE CASCADE
);

INSERT INTO users (name,email,password_hash,role) VALUES
('System Admin','admin@maintenance.local','$2a$10$aYeVnct/d.iH8u9uJMvmY.7yw692laU.Br.4qouKtjo4oM9slKNtS','ADMIN');
-- password: Admin@12345

INSERT INTO villas(name, area) VALUES ('فيلا التميمي','دبي'),('فيلا الجوهري','دبي'),('فيلا المنصوري','دبي');
INSERT INTO apartments(villa_id, apartment_no, floor) VALUES (1,'1','أرضي'),(1,'2','أول'),(2,'1','أرضي'),(3,'4','ثاني');
INSERT INTO technicians(name, specialty) VALUES ('غزال','تكييف'),('سند','تكييف'),('فريد','سباكة'),('معاذ','كهرباء'),('عبد الرافع','عام');

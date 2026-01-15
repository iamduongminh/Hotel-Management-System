-- =====================================================
-- HOTEL MANAGEMENT SYSTEM - DATABASE INITIALIZATION (VALUES ONLY)
-- TƯƠNG THÍCH MySQL 5.7+ (KHÔNG dùng WITH/CTE)
-- Sinh dữ liệu cho 16 chi nhánh (HN=5, DN=4, HCM=5, PQ=2)
-- Mỗi chi nhánh: 1 BRANCH_MANAGER, 7 ADMIN, 10 RECEPTIONIST, 8 HOUSEKEEPER
-- Mỗi chi nhánh: 50 phòng (chia hết cho 10, <=70)
-- ID đều là BIGINT và là PRIMARY KEY theo yêu cầu
-- =====================================================
-- Quy tac anh xa ID nguoi dung:
-- HN=29, DN=43, HCM=79, PQ=83
-- ROLE: RM=1, BM=2, ADM=3, REC=4, HSK=5
-- Loai bo cac dau thua nhu -, _.
-- =====================================================

DROP DATABASE IF EXISTS hotel_db;
CREATE DATABASE hotel_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hotel_db;

-- SELECT VERSION();
-- =========================
-- CREATE TABLES
-- =========================
CREATE TABLE users (
  id BIGINT PRIMARY KEY,
  username VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  role VARCHAR(50) NOT NULL,
  city VARCHAR(100) NOT NULL,
  branch_name VARCHAR(100),
  birthday DATE,
  phone_number VARCHAR(20),
  email VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE rooms (
  id BIGINT PRIMARY KEY,
  room_number VARCHAR(50) NOT NULL,
  price DECIMAL(19,2) NOT NULL,
  type VARCHAR(50) NOT NULL,
  status VARCHAR(50) NOT NULL,
  city VARCHAR(100) NOT NULL,
  branch_name VARCHAR(100) NOT NULL,
  UNIQUE KEY uq_room_per_branch (city, branch_name, room_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE customers (
  id BIGINT PRIMARY KEY,
  full_name VARCHAR(255),
  phone VARCHAR(20),
  identity_number VARCHAR(50) UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE bookings (
  id BIGINT PRIMARY KEY,
  customer_id BIGINT,
  customer_name VARCHAR(255),
  check_in_date DATETIME,
  check_out_date DATETIME,
  total_amount DECIMAL(19,2),
  status VARCHAR(50),
  room_id BIGINT,
  city VARCHAR(100),
  branch_name VARCHAR(100),
  FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE SET NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE invoices (
  id BIGINT PRIMARY KEY,
  booking_id BIGINT UNIQUE,
  total_amount DECIMAL(19,2),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  payment_type VARCHAR(50),
  FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE approval_requests (
  id BIGINT PRIMARY KEY,
  type VARCHAR(255) NOT NULL,
  target_id BIGINT NOT NULL,
  request_data TEXT,
  reason TEXT,
  status VARCHAR(50),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  created_by VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE approval_log (
  id BIGINT PRIMARY KEY,
  command_name VARCHAR(255),
  description TEXT,
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- INSERT CUSTOMERS (ID = CCCD)
-- =========================
INSERT INTO customers (id, full_name, phone, identity_number) VALUES
(1234567890,'Nguyễn Văn A','0912345678','001234567890'),
(1234567891,'Trần Thị B','0923456789','001234567891'),
(1234567892,'Lê Văn C','0934567890','001234567892'),
(1234567893,'Phạm Thị D','0945678901','001234567893'),
(1234567894,'Hoàng Văn E','0956789012','001234567894'),
(1234567895,'Vũ Văn F','0961112223','001234567895'),
(1234567896,'Đặng Thị G','0972223334','001234567896'),
(1234567897,'Phan Văn H','0983334445','001234567897'),
(1234567898,'Đỗ Thị I','0988889991','001234567898'),
(1234567899,'Ngô Văn K','0999990002','001234567899');

-- =========================
-- INSERT USERS
-- =========================
-- REGIONAL_MANAGER (1) - HN=29, RM=1 => 291
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(291,'MinhRM','$2a$10$2tALBpxsA1Dx9ztRBHQi2.F2WpU6n5cBIoLaRrm5nAAPJMkdzt.Ii','Dương Quang Minh','REGIONAL_MANAGER','Hà Nội',NULL,'1985-05-15','0901234567','minh@hotel.vn');

-- ===== Chi nhánh HN01 (Hà Nội - Ba Đình Hotel) =====
-- HN=29, BM=2, 001 => 292001
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(292001,'AnhBM','$2a$10$cZz/2xo0J9oZ8TovDes8Xem/zAojjezdYdv2FBmJNUlaOCEua/vfK','Quản lý chi nhánh HN01','BRANCH_MANAGER','Hà Nội','Ba Đình Hotel','1988-04-12','0910000001','manager@hn01.hotel.vn');
-- HN=29, ADM=3, 001-007 => 293001-293007
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(293001,'admin','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN01 #1','ADMIN','Hà Nội','Ba Đình Hotel','1992-03-12','0910000002','admin01@hn01.hotel.vn'),
(293002,'HN01_admin02','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN01 #2','ADMIN','Hà Nội','Ba Đình Hotel','1992-03-12','0910000003','admin02@hn01.hotel.vn'),
(293003,'HN01_admin03','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN01 #3','ADMIN','Hà Nội','Ba Đình Hotel','1992-03-12','0910000004','admin03@hn01.hotel.vn'),
(293004,'HN01_admin04','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN01 #4','ADMIN','Hà Nội','Ba Đình Hotel','1992-03-12','0910000005','admin04@hn01.hotel.vn'),
(293005,'HN01_admin05','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN01 #5','ADMIN','Hà Nội','Ba Đình Hotel','1992-03-12','0910000006','admin05@hn01.hotel.vn'),
(293006,'HN01_admin06','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN01 #6','ADMIN','Hà Nội','Ba Đình Hotel','1992-03-12','0910000007','admin06@hn01.hotel.vn'),
(293007,'HN01_admin07','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN01 #7','ADMIN','Hà Nội','Ba Đình Hotel','1992-03-12','0910000008','admin07@hn01.hotel.vn');
-- HN=29, REC=4, 001-010 => 294001-294010
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(294001,'staff','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN01 #1','RECEPTIONIST','Hà Nội','Ba Đình Hotel','1995-06-15','0910000009','staff01@hn01.hotel.vn'),
(294002,'HN01_staff02','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN01 #2','RECEPTIONIST','Hà Nội','Ba Đình Hotel','1995-06-15','0910000010','staff02@hn01.hotel.vn'),
(294003,'HN01_staff03','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN01 #3','RECEPTIONIST','Hà Nội','Ba Đình Hotel','1995-06-15','0910000011','staff03@hn01.hotel.vn'),
(294004,'HN01_staff04','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN01 #4','RECEPTIONIST','Hà Nội','Ba Đình Hotel','1995-06-15','0910000012','staff04@hn01.hotel.vn'),
(294005,'HN01_staff05','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN01 #5','RECEPTIONIST','Hà Nội','Ba Đình Hotel','1995-06-15','0910000013','staff05@hn01.hotel.vn'),
(294006,'HN01_staff06','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN01 #6','RECEPTIONIST','Hà Nội','Ba Đình Hotel','1995-06-15','0910000014','staff06@hn01.hotel.vn'),
(294007,'HN01_staff07','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN01 #7','RECEPTIONIST','Hà Nội','Ba Đình Hotel','1995-06-15','0910000015','staff07@hn01.hotel.vn'),
(294008,'HN01_staff08','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN01 #8','RECEPTIONIST','Hà Nội','Ba Đình Hotel','1995-06-15','0910000016','staff08@hn01.hotel.vn'),
(294009,'HN01_staff09','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN01 #9','RECEPTIONIST','Hà Nội','Ba Đình Hotel','1995-06-15','0910000017','staff09@hn01.hotel.vn'),
(294010,'HN01_staff10','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN01 #10','RECEPTIONIST','Hà Nội','Ba Đình Hotel','1995-06-15','0910000018','staff10@hn01.hotel.vn');
-- HN=29, HSK=5, 001-008 => 295001-295008
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(295001,'housekeeper','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN01 #1','HOUSEKEEPER','Hà Nội','Ba Đình Hotel','1994-09-27','0910000019','hsk01@hn01.hotel.vn'),
(295002,'HN01_hsk02','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN01 #2','HOUSEKEEPER','Hà Nội','Ba Đình Hotel','1994-09-27','0910000020','hsk02@hn01.hotel.vn'),
(295003,'HN01_hsk03','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN01 #3','HOUSEKEEPER','Hà Nội','Ba Đình Hotel','1994-09-27','0910000021','hsk03@hn01.hotel.vn'),
(295004,'HN01_hsk04','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN01 #4','HOUSEKEEPER','Hà Nội','Ba Đình Hotel','1994-09-27','0910000022','hsk04@hn01.hotel.vn'),
(295005,'HN01_hsk05','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN01 #5','HOUSEKEEPER','Hà Nội','Ba Đình Hotel','1994-09-27','0910000023','hsk05@hn01.hotel.vn'),
(295006,'HN01_hsk06','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN01 #6','HOUSEKEEPER','Hà Nội','Ba Đình Hotel','1994-09-27','0910000024','hsk06@hn01.hotel.vn'),
(295007,'HN01_hsk07','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN01 #7','HOUSEKEEPER','Hà Nội','Ba Đình Hotel','1994-09-27','0910000025','hsk07@hn01.hotel.vn'),
(295008,'HN01_hsk08','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN01 #8','HOUSEKEEPER','Hà Nội','Ba Đình Hotel','1994-09-27','0910000026','hsk08@hn01.hotel.vn');

-- ===== Chi nhánh HN02 (Hà Nội - Cầu Giấy Hotel) =====
-- HN=29, BM=2, 002 => 292002
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(292002,'HN02_manager','$2a$10$cZz/2xo0J9oZ8TovDes8Xem/zAojjezdYdv2FBmJNUlaOCEua/vfK','Quản lý chi nhánh HN02','BRANCH_MANAGER','Hà Nội','Cầu Giấy Hotel','1988-04-12','0910000027','manager@hn02.hotel.vn');
-- HN=29, ADM=3, 008-014 => 293008-293014
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(293008,'HN02_admin01','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN02 #1','ADMIN','Hà Nội','Cầu Giấy Hotel','1992-03-12','0910000028','admin01@hn02.hotel.vn'),
(293009,'HN02_admin02','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN02 #2','ADMIN','Hà Nội','Cầu Giấy Hotel','1992-03-12','0910000029','admin02@hn02.hotel.vn'),
(293010,'HN02_admin03','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN02 #3','ADMIN','Hà Nội','Cầu Giấy Hotel','1992-03-12','0910000030','admin03@hn02.hotel.vn'),
(293011,'HN02_admin04','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN02 #4','ADMIN','Hà Nội','Cầu Giấy Hotel','1992-03-12','0910000031','admin04@hn02.hotel.vn'),
(293012,'HN02_admin05','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN02 #5','ADMIN','Hà Nội','Cầu Giấy Hotel','1992-03-12','0910000032','admin05@hn02.hotel.vn'),
(293013,'HN02_admin06','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN02 #6','ADMIN','Hà Nội','Cầu Giấy Hotel','1992-03-12','0910000033','admin06@hn02.hotel.vn'),
(293014,'HN02_admin07','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN02 #7','ADMIN','Hà Nội','Cầu Giấy Hotel','1992-03-12','0910000034','admin07@hn02.hotel.vn');
-- HN=29, REC=4, 011-020 => 294011-294020
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(294011,'HN02_staff01','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN02 #1','RECEPTIONIST','Hà Nội','Cầu Giấy Hotel','1995-06-15','0910000035','staff01@hn02.hotel.vn'),
(294012,'HN02_staff02','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN02 #2','RECEPTIONIST','Hà Nội','Cầu Giấy Hotel','1995-06-15','0910000036','staff02@hn02.hotel.vn'),
(294013,'HN02_staff03','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN02 #3','RECEPTIONIST','Hà Nội','Cầu Giấy Hotel','1995-06-15','0910000037','staff03@hn02.hotel.vn'),
(294014,'HN02_staff04','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN02 #4','RECEPTIONIST','Hà Nội','Cầu Giấy Hotel','1995-06-15','0910000038','staff04@hn02.hotel.vn'),
(294015,'HN02_staff05','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN02 #5','RECEPTIONIST','Hà Nội','Cầu Giấy Hotel','1995-06-15','0910000039','staff05@hn02.hotel.vn'),
(294016,'HN02_staff06','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN02 #6','RECEPTIONIST','Hà Nội','Cầu Giấy Hotel','1995-06-15','0910000040','staff06@hn02.hotel.vn'),
(294017,'HN02_staff07','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN02 #7','RECEPTIONIST','Hà Nội','Cầu Giấy Hotel','1995-06-15','0910000041','staff07@hn02.hotel.vn'),
(294018,'HN02_staff08','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN02 #8','RECEPTIONIST','Hà Nội','Cầu Giấy Hotel','1995-06-15','0910000042','staff08@hn02.hotel.vn'),
(294019,'HN02_staff09','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN02 #9','RECEPTIONIST','Hà Nội','Cầu Giấy Hotel','1995-06-15','0910000043','staff09@hn02.hotel.vn'),
(294020,'HN02_staff10','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN02 #10','RECEPTIONIST','Hà Nội','Cầu Giấy Hotel','1995-06-15','0910000044','staff10@hn02.hotel.vn');
-- HN=29, HSK=5, 009-016 => 295009-295016
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(295009,'HN02_hsk01','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN02 #1','HOUSEKEEPER','Hà Nội','Cầu Giấy Hotel','1994-09-27','0910000045','hsk01@hn02.hotel.vn'),
(295010,'HN02_hsk02','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN02 #2','HOUSEKEEPER','Hà Nội','Cầu Giấy Hotel','1994-09-27','0910000046','hsk02@hn02.hotel.vn'),
(295011,'HN02_hsk03','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN02 #3','HOUSEKEEPER','Hà Nội','Cầu Giấy Hotel','1994-09-27','0910000047','hsk03@hn02.hotel.vn'),
(295012,'HN02_hsk04','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN02 #4','HOUSEKEEPER','Hà Nội','Cầu Giấy Hotel','1994-09-27','0910000048','hsk04@hn02.hotel.vn'),
(295013,'HN02_hsk05','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN02 #5','HOUSEKEEPER','Hà Nội','Cầu Giấy Hotel','1994-09-27','0910000049','hsk05@hn02.hotel.vn'),
(295014,'HN02_hsk06','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN02 #6','HOUSEKEEPER','Hà Nội','Cầu Giấy Hotel','1994-09-27','0910000050','hsk06@hn02.hotel.vn'),
(295015,'HN02_hsk07','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN02 #7','HOUSEKEEPER','Hà Nội','Cầu Giấy Hotel','1994-09-27','0910000051','hsk07@hn02.hotel.vn'),
(295016,'HN02_hsk08','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN02 #8','HOUSEKEEPER','Hà Nội','Cầu Giấy Hotel','1994-09-27','0910000052','hsk08@hn02.hotel.vn');

-- ===== Chi nhánh HN03 (Hà Nội - Đống Đa Hotel) =====
-- HN=29, BM=2, 003 => 292003
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(292003,'HN03_manager','$2a$10$cZz/2xo0J9oZ8TovDes8Xem/zAojjezdYdv2FBmJNUlaOCEua/vfK','Quản lý chi nhánh HN03','BRANCH_MANAGER','Hà Nội','Đống Đa Hotel','1988-04-12','0910000053','manager@hn03.hotel.vn');
-- HN=29, ADM=3, 015-021 => 293015-293021
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(293015,'HN03_admin01','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN03 #1','ADMIN','Hà Nội','Đống Đa Hotel','1992-03-12','0910000054','admin01@hn03.hotel.vn'),
(293016,'HN03_admin02','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN03 #2','ADMIN','Hà Nội','Đống Đa Hotel','1992-03-12','0910000055','admin02@hn03.hotel.vn'),
(293017,'HN03_admin03','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN03 #3','ADMIN','Hà Nội','Đống Đa Hotel','1992-03-12','0910000056','admin03@hn03.hotel.vn'),
(293018,'HN03_admin04','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN03 #4','ADMIN','Hà Nội','Đống Đa Hotel','1992-03-12','0910000057','admin04@hn03.hotel.vn'),
(293019,'HN03_admin05','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN03 #5','ADMIN','Hà Nội','Đống Đa Hotel','1992-03-12','0910000058','admin05@hn03.hotel.vn'),
(293020,'HN03_admin06','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN03 #6','ADMIN','Hà Nội','Đống Đa Hotel','1992-03-12','0910000059','admin06@hn03.hotel.vn'),
(293021,'HN03_admin07','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN03 #7','ADMIN','Hà Nội','Đống Đa Hotel','1992-03-12','0910000060','admin07@hn03.hotel.vn');
-- HN=29, REC=4, 021-030 => 294021-294030
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(294021,'HN03_staff01','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN03 #1','RECEPTIONIST','Hà Nội','Đống Đa Hotel','1995-06-15','0910000061','staff01@hn03.hotel.vn'),
(294022,'HN03_staff02','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN03 #2','RECEPTIONIST','Hà Nội','Đống Đa Hotel','1995-06-15','0910000062','staff02@hn03.hotel.vn'),
(294023,'HN03_staff03','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN03 #3','RECEPTIONIST','Hà Nội','Đống Đa Hotel','1995-06-15','0910000063','staff03@hn03.hotel.vn'),
(294024,'HN03_staff04','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN03 #4','RECEPTIONIST','Hà Nội','Đống Đa Hotel','1995-06-15','0910000064','staff04@hn03.hotel.vn'),
(294025,'HN03_staff05','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN03 #5','RECEPTIONIST','Hà Nội','Đống Đa Hotel','1995-06-15','0910000065','staff05@hn03.hotel.vn'),
(294026,'HN03_staff06','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN03 #6','RECEPTIONIST','Hà Nội','Đống Đa Hotel','1995-06-15','0910000066','staff06@hn03.hotel.vn'),
(294027,'HN03_staff07','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN03 #7','RECEPTIONIST','Hà Nội','Đống Đa Hotel','1995-06-15','0910000067','staff07@hn03.hotel.vn'),
(294028,'HN03_staff08','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN03 #8','RECEPTIONIST','Hà Nội','Đống Đa Hotel','1995-06-15','0910000068','staff08@hn03.hotel.vn'),
(294029,'HN03_staff09','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN03 #9','RECEPTIONIST','Hà Nội','Đống Đa Hotel','1995-06-15','0910000069','staff09@hn03.hotel.vn'),
(294030,'HN03_staff10','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN03 #10','RECEPTIONIST','Hà Nội','Đống Đa Hotel','1995-06-15','0910000070','staff10@hn03.hotel.vn');
-- HN=29, HSK=5, 017-024 => 295017-295024
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(295017,'HN03_hsk01','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN03 #1','HOUSEKEEPER','Hà Nội','Đống Đa Hotel','1994-09-27','0910000071','hsk01@hn03.hotel.vn'),
(295018,'HN03_hsk02','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN03 #2','HOUSEKEEPER','Hà Nội','Đống Đa Hotel','1994-09-27','0910000072','hsk02@hn03.hotel.vn'),
(295019,'HN03_hsk03','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN03 #3','HOUSEKEEPER','Hà Nội','Đống Đa Hotel','1994-09-27','0910000073','hsk03@hn03.hotel.vn'),
(295020,'HN03_hsk04','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN03 #4','HOUSEKEEPER','Hà Nội','Đống Đa Hotel','1994-09-27','0910000074','hsk04@hn03.hotel.vn'),
(295021,'HN03_hsk05','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN03 #5','HOUSEKEEPER','Hà Nội','Đống Đa Hotel','1994-09-27','0910000075','hsk05@hn03.hotel.vn'),
(295022,'HN03_hsk06','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN03 #6','HOUSEKEEPER','Hà Nội','Đống Đa Hotel','1994-09-27','0910000076','hsk06@hn03.hotel.vn'),
(295023,'HN03_hsk07','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN03 #7','HOUSEKEEPER','Hà Nội','Đống Đa Hotel','1994-09-27','0910000077','hsk07@hn03.hotel.vn'),
(295024,'HN03_hsk08','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN03 #8','HOUSEKEEPER','Hà Nội','Đống Đa Hotel','1994-09-27','0910000078','hsk08@hn03.hotel.vn');

-- ===== Chi nhánh HN04 (Hà Nội - Hai Bà Trưng Hotel) =====
-- HN=29, BM=2, 004 => 292004
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(292004,'HN04_manager','$2a$10$cZz/2xo0J9oZ8TovDes8Xem/zAojjezdYdv2FBmJNUlaOCEua/vfK','Quản lý chi nhánh HN04','BRANCH_MANAGER','Hà Nội','Hai Bà Trưng Hotel','1988-04-12','0910000079','manager@hn04.hotel.vn');
-- HN=29, ADM=3, 022-028 => 293022-293028
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(293022,'HN04_admin01','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN04 #1','ADMIN','Hà Nội','Hai Bà Trưng Hotel','1992-03-12','0910000080','admin01@hn04.hotel.vn'),
(293023,'HN04_admin02','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN04 #2','ADMIN','Hà Nội','Hai Bà Trưng Hotel','1992-03-12','0910000081','admin02@hn04.hotel.vn'),
(293024,'HN04_admin03','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN04 #3','ADMIN','Hà Nội','Hai Bà Trưng Hotel','1992-03-12','0910000082','admin03@hn04.hotel.vn'),
(293025,'HN04_admin04','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN04 #4','ADMIN','Hà Nội','Hai Bà Trưng Hotel','1992-03-12','0910000083','admin04@hn04.hotel.vn'),
(293026,'HN04_admin05','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN04 #5','ADMIN','Hà Nội','Hai Bà Trưng Hotel','1992-03-12','0910000084','admin05@hn04.hotel.vn'),
(293027,'HN04_admin06','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN04 #6','ADMIN','Hà Nội','Hai Bà Trưng Hotel','1992-03-12','0910000085','admin06@hn04.hotel.vn'),
(293028,'HN04_admin07','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN04 #7','ADMIN','Hà Nội','Hai Bà Trưng Hotel','1992-03-12','0910000086','admin07@hn04.hotel.vn');
-- HN=29, REC=4, 031-040 => 294031-294040
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(294031,'HN04_staff01','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN04 #1','RECEPTIONIST','Hà Nội','Hai Bà Trưng Hotel','1995-06-15','0910000087','staff01@hn04.hotel.vn'),
(294032,'HN04_staff02','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN04 #2','RECEPTIONIST','Hà Nội','Hai Bà Trưng Hotel','1995-06-15','0910000088','staff02@hn04.hotel.vn'),
(294033,'HN04_staff03','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN04 #3','RECEPTIONIST','Hà Nội','Hai Bà Trưng Hotel','1995-06-15','0910000089','staff03@hn04.hotel.vn'),
(294034,'HN04_staff04','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN04 #4','RECEPTIONIST','Hà Nội','Hai Bà Trưng Hotel','1995-06-15','0910000090','staff04@hn04.hotel.vn'),
(294035,'HN04_staff05','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN04 #5','RECEPTIONIST','Hà Nội','Hai Bà Trưng Hotel','1995-06-15','0910000091','staff05@hn04.hotel.vn'),
(294036,'HN04_staff06','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN04 #6','RECEPTIONIST','Hà Nội','Hai Bà Trưng Hotel','1995-06-15','0910000092','staff06@hn04.hotel.vn'),
(294037,'HN04_staff07','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN04 #7','RECEPTIONIST','Hà Nội','Hai Bà Trưng Hotel','1995-06-15','0910000093','staff07@hn04.hotel.vn'),
(294038,'HN04_staff08','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN04 #8','RECEPTIONIST','Hà Nội','Hai Bà Trưng Hotel','1995-06-15','0910000094','staff08@hn04.hotel.vn'),
(294039,'HN04_staff09','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN04 #9','RECEPTIONIST','Hà Nội','Hai Bà Trưng Hotel','1995-06-15','0910000095','staff09@hn04.hotel.vn'),
(294040,'HN04_staff10','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN04 #10','RECEPTIONIST','Hà Nội','Hai Bà Trưng Hotel','1995-06-15','0910000096','staff10@hn04.hotel.vn');
-- HN=29, HSK=5, 025-032 => 295025-295032
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(295025,'HN04_hsk01','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN04 #1','HOUSEKEEPER','Hà Nội','Hai Bà Trưng Hotel','1994-09-27','0910000097','hsk01@hn04.hotel.vn'),
(295026,'HN04_hsk02','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN04 #2','HOUSEKEEPER','Hà Nội','Hai Bà Trưng Hotel','1994-09-27','0910000098','hsk02@hn04.hotel.vn'),
(295027,'HN04_hsk03','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN04 #3','HOUSEKEEPER','Hà Nội','Hai Bà Trưng Hotel','1994-09-27','0910000099','hsk03@hn04.hotel.vn'),
(295028,'HN04_hsk04','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN04 #4','HOUSEKEEPER','Hà Nội','Hai Bà Trưng Hotel','1994-09-27','0910000100','hsk04@hn04.hotel.vn'),
(295029,'HN04_hsk05','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN04 #5','HOUSEKEEPER','Hà Nội','Hai Bà Trưng Hotel','1994-09-27','0910000101','hsk05@hn04.hotel.vn'),
(295030,'HN04_hsk06','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN04 #6','HOUSEKEEPER','Hà Nội','Hai Bà Trưng Hotel','1994-09-27','0910000102','hsk06@hn04.hotel.vn'),
(295031,'HN04_hsk07','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN04 #7','HOUSEKEEPER','Hà Nội','Hai Bà Trưng Hotel','1994-09-27','0910000103','hsk07@hn04.hotel.vn'),
(295032,'HN04_hsk08','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN04 #8','HOUSEKEEPER','Hà Nội','Hai Bà Trưng Hotel','1994-09-27','0910000104','hsk08@hn04.hotel.vn');

-- ===== Chi nhánh HN05 (Hà Nội - Hoàn Kiếm Hotel) =====
-- HN=29, BM=2, 005 => 292005
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(292005,'HN05_manager','$2a$10$cZz/2xo0J9oZ8TovDes8Xem/zAojjezdYdv2FBmJNUlaOCEua/vfK','Quản lý chi nhánh HN05','BRANCH_MANAGER','Hà Nội','Hoàn Kiếm Hotel','1988-04-12','0910000105','manager@hn05.hotel.vn');
-- HN=29, ADM=3, 029-035 => 293029-293035
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(293029,'HN05_admin01','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN05 #1','ADMIN','Hà Nội','Hoàn Kiếm Hotel','1992-03-12','0910000106','admin01@hn05.hotel.vn'),
(293030,'HN05_admin02','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN05 #2','ADMIN','Hà Nội','Hoàn Kiếm Hotel','1992-03-12','0910000107','admin02@hn05.hotel.vn'),
(293031,'HN05_admin03','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN05 #3','ADMIN','Hà Nội','Hoàn Kiếm Hotel','1992-03-12','0910000108','admin03@hn05.hotel.vn'),
(293032,'HN05_admin04','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN05 #4','ADMIN','Hà Nội','Hoàn Kiếm Hotel','1992-03-12','0910000109','admin04@hn05.hotel.vn'),
(293033,'HN05_admin05','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN05 #5','ADMIN','Hà Nội','Hoàn Kiếm Hotel','1992-03-12','0910000110','admin05@hn05.hotel.vn'),
(293034,'HN05_admin06','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN05 #6','ADMIN','Hà Nội','Hoàn Kiếm Hotel','1992-03-12','0910000111','admin06@hn05.hotel.vn'),
(293035,'HN05_admin07','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HN05 #7','ADMIN','Hà Nội','Hoàn Kiếm Hotel','1992-03-12','0910000112','admin07@hn05.hotel.vn');
-- HN=29, REC=4, 041-050 => 294041-294050
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(294041,'HN05_staff01','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN05 #1','RECEPTIONIST','Hà Nội','Hoàn Kiếm Hotel','1995-06-15','0910000113','staff01@hn05.hotel.vn'),
(294042,'HN05_staff02','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN05 #2','RECEPTIONIST','Hà Nội','Hoàn Kiếm Hotel','1995-06-15','0910000114','staff02@hn05.hotel.vn'),
(294043,'HN05_staff03','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN05 #3','RECEPTIONIST','Hà Nội','Hoàn Kiếm Hotel','1995-06-15','0910000115','staff03@hn05.hotel.vn'),
(294044,'HN05_staff04','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN05 #4','RECEPTIONIST','Hà Nội','Hoàn Kiếm Hotel','1995-06-15','0910000116','staff04@hn05.hotel.vn'),
(294045,'HN05_staff05','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN05 #5','RECEPTIONIST','Hà Nội','Hoàn Kiếm Hotel','1995-06-15','0910000117','staff05@hn05.hotel.vn'),
(294046,'HN05_staff06','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN05 #6','RECEPTIONIST','Hà Nội','Hoàn Kiếm Hotel','1995-06-15','0910000118','staff06@hn05.hotel.vn'),
(294047,'HN05_staff07','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN05 #7','RECEPTIONIST','Hà Nội','Hoàn Kiếm Hotel','1995-06-15','0910000119','staff07@hn05.hotel.vn'),
(294048,'HN05_staff08','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN05 #8','RECEPTIONIST','Hà Nội','Hoàn Kiếm Hotel','1995-06-15','0910000120','staff08@hn05.hotel.vn'),
(294049,'HN05_staff09','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN05 #9','RECEPTIONIST','Hà Nội','Hoàn Kiếm Hotel','1995-06-15','0910000121','staff09@hn05.hotel.vn'),
(294050,'HN05_staff10','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HN05 #10','RECEPTIONIST','Hà Nội','Hoàn Kiếm Hotel','1995-06-15','0910000122','staff10@hn05.hotel.vn');
-- HN=29, HSK=5, 033-040 => 295033-295040
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(295033,'HN05_hsk01','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN05 #1','HOUSEKEEPER','Hà Nội','Hoàn Kiếm Hotel','1994-09-27','0910000123','hsk01@hn05.hotel.vn'),
(295034,'HN05_hsk02','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN05 #2','HOUSEKEEPER','Hà Nội','Hoàn Kiếm Hotel','1994-09-27','0910000124','hsk02@hn05.hotel.vn'),
(295035,'HN05_hsk03','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN05 #3','HOUSEKEEPER','Hà Nội','Hoàn Kiếm Hotel','1994-09-27','0910000125','hsk03@hn05.hotel.vn'),
(295036,'HN05_hsk04','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN05 #4','HOUSEKEEPER','Hà Nội','Hoàn Kiếm Hotel','1994-09-27','0910000126','hsk04@hn05.hotel.vn'),
(295037,'HN05_hsk05','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN05 #5','HOUSEKEEPER','Hà Nội','Hoàn Kiếm Hotel','1994-09-27','0910000127','hsk05@hn05.hotel.vn'),
(295038,'HN05_hsk06','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN05 #6','HOUSEKEEPER','Hà Nội','Hoàn Kiếm Hotel','1994-09-27','0910000128','hsk06@hn05.hotel.vn'),
(295039,'HN05_hsk07','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN05 #7','HOUSEKEEPER','Hà Nội','Hoàn Kiếm Hotel','1994-09-27','0910000129','hsk07@hn05.hotel.vn'),
(295040,'HN05_hsk08','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HN05 #8','HOUSEKEEPER','Hà Nội','Hoàn Kiếm Hotel','1994-09-27','0910000130','hsk08@hn05.hotel.vn');

-- ===== Chi nhánh DN01 (Đà Nẵng - Hải Châu Hotel) =====
-- DN=43, BM=2, 001 => 432001
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(432001,'DN01_manager','$2a$10$cZz/2xo0J9oZ8TovDes8Xem/zAojjezdYdv2FBmJNUlaOCEua/vfK','Quản lý chi nhánh DN01','BRANCH_MANAGER','Đà Nẵng','Hải Châu Hotel','1988-04-12','0910000131','manager@dn01.hotel.vn');
-- DN=43, ADM=3, 001-007 => 433001-433007
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(433001,'DN01_admin01','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN01 #1','ADMIN','Đà Nẵng','Hải Châu Hotel','1992-03-12','0910000132','admin01@dn01.hotel.vn'),
(433002,'DN01_admin02','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN01 #2','ADMIN','Đà Nẵng','Hải Châu Hotel','1992-03-12','0910000133','admin02@dn01.hotel.vn'),
(433003,'DN01_admin03','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN01 #3','ADMIN','Đà Nẵng','Hải Châu Hotel','1992-03-12','0910000134','admin03@dn01.hotel.vn'),
(433004,'DN01_admin04','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN01 #4','ADMIN','Đà Nẵng','Hải Châu Hotel','1992-03-12','0910000135','admin04@dn01.hotel.vn'),
(433005,'DN01_admin05','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN01 #5','ADMIN','Đà Nẵng','Hải Châu Hotel','1992-03-12','0910000136','admin05@dn01.hotel.vn'),
(433006,'DN01_admin06','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN01 #6','ADMIN','Đà Nẵng','Hải Châu Hotel','1992-03-12','0910000137','admin06@dn01.hotel.vn'),
(433007,'DN01_admin07','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN01 #7','ADMIN','Đà Nẵng','Hải Châu Hotel','1992-03-12','0910000138','admin07@dn01.hotel.vn');
-- DN=43, REC=4, 001-010 => 434001-434010
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(434001,'DN01_staff01','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN01 #1','RECEPTIONIST','Đà Nẵng','Hải Châu Hotel','1995-06-15','0910000139','staff01@dn01.hotel.vn'),
(434002,'DN01_staff02','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN01 #2','RECEPTIONIST','Đà Nẵng','Hải Châu Hotel','1995-06-15','0910000140','staff02@dn01.hotel.vn'),
(434003,'DN01_staff03','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN01 #3','RECEPTIONIST','Đà Nẵng','Hải Châu Hotel','1995-06-15','0910000141','staff03@dn01.hotel.vn'),
(434004,'DN01_staff04','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN01 #4','RECEPTIONIST','Đà Nẵng','Hải Châu Hotel','1995-06-15','0910000142','staff04@dn01.hotel.vn'),
(434005,'DN01_staff05','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN01 #5','RECEPTIONIST','Đà Nẵng','Hải Châu Hotel','1995-06-15','0910000143','staff05@dn01.hotel.vn'),
(434006,'DN01_staff06','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN01 #6','RECEPTIONIST','Đà Nẵng','Hải Châu Hotel','1995-06-15','0910000144','staff06@dn01.hotel.vn'),
(434007,'DN01_staff07','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN01 #7','RECEPTIONIST','Đà Nẵng','Hải Châu Hotel','1995-06-15','0910000145','staff07@dn01.hotel.vn'),
(434008,'DN01_staff08','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN01 #8','RECEPTIONIST','Đà Nẵng','Hải Châu Hotel','1995-06-15','0910000146','staff08@dn01.hotel.vn'),
(434009,'DN01_staff09','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN01 #9','RECEPTIONIST','Đà Nẵng','Hải Châu Hotel','1995-06-15','0910000147','staff09@dn01.hotel.vn'),
(434010,'DN01_staff10','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN01 #10','RECEPTIONIST','Đà Nẵng','Hải Châu Hotel','1995-06-15','0910000148','staff10@dn01.hotel.vn');
-- DN=43, HSK=5, 001-008 => 435001-435008
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(435001,'DN01_hsk01','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN01 #1','HOUSEKEEPER','Đà Nẵng','Hải Châu Hotel','1994-09-27','0910000149','hsk01@dn01.hotel.vn'),
(435002,'DN01_hsk02','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN01 #2','HOUSEKEEPER','Đà Nẵng','Hải Châu Hotel','1994-09-27','0910000150','hsk02@dn01.hotel.vn'),
(435003,'DN01_hsk03','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN01 #3','HOUSEKEEPER','Đà Nẵng','Hải Châu Hotel','1994-09-27','0910000151','hsk03@dn01.hotel.vn'),
(435004,'DN01_hsk04','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN01 #4','HOUSEKEEPER','Đà Nẵng','Hải Châu Hotel','1994-09-27','0910000152','hsk04@dn01.hotel.vn'),
(435005,'DN01_hsk05','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN01 #5','HOUSEKEEPER','Đà Nẵng','Hải Châu Hotel','1994-09-27','0910000153','hsk05@dn01.hotel.vn'),
(435006,'DN01_hsk06','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN01 #6','HOUSEKEEPER','Đà Nẵng','Hải Châu Hotel','1994-09-27','0910000154','hsk06@dn01.hotel.vn'),
(435007,'DN01_hsk07','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN01 #7','HOUSEKEEPER','Đà Nẵng','Hải Châu Hotel','1994-09-27','0910000155','hsk07@dn01.hotel.vn'),
(435008,'DN01_hsk08','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN01 #8','HOUSEKEEPER','Đà Nẵng','Hải Châu Hotel','1994-09-27','0910000156','hsk08@dn01.hotel.vn');

-- ===== Chi nhánh DN02 (Đà Nẵng - Sơn Trà Hotel) =====
-- DN=43, BM=2, 002 => 432002
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(432002,'DN02_manager','$2a$10$cZz/2xo0J9oZ8TovDes8Xem/zAojjezdYdv2FBmJNUlaOCEua/vfK','Quản lý chi nhánh DN02','BRANCH_MANAGER','Đà Nẵng','Sơn Trà Hotel','1988-04-12','0910000157','manager@dn02.hotel.vn');
-- DN=43, ADM=3, 008-014 => 433008-433014
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(433008,'DN02_admin01','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN02 #1','ADMIN','Đà Nẵng','Sơn Trà Hotel','1992-03-12','0910000158','admin01@dn02.hotel.vn'),
(433009,'DN02_admin02','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN02 #2','ADMIN','Đà Nẵng','Sơn Trà Hotel','1992-03-12','0910000159','admin02@dn02.hotel.vn'),
(433010,'DN02_admin03','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN02 #3','ADMIN','Đà Nẵng','Sơn Trà Hotel','1992-03-12','0910000160','admin03@dn02.hotel.vn'),
(433011,'DN02_admin04','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN02 #4','ADMIN','Đà Nẵng','Sơn Trà Hotel','1992-03-12','0910000161','admin04@dn02.hotel.vn'),
(433012,'DN02_admin05','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN02 #5','ADMIN','Đà Nẵng','Sơn Trà Hotel','1992-03-12','0910000162','admin05@dn02.hotel.vn'),
(433013,'DN02_admin06','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN02 #6','ADMIN','Đà Nẵng','Sơn Trà Hotel','1992-03-12','0910000163','admin06@dn02.hotel.vn'),
(433014,'DN02_admin07','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN02 #7','ADMIN','Đà Nẵng','Sơn Trà Hotel','1992-03-12','0910000164','admin07@dn02.hotel.vn');
-- DN=43, REC=4, 011-020 => 434011-434020
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(434011,'DN02_staff01','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN02 #1','RECEPTIONIST','Đà Nẵng','Sơn Trà Hotel','1995-06-15','0910000165','staff01@dn02.hotel.vn'),
(434012,'DN02_staff02','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN02 #2','RECEPTIONIST','Đà Nẵng','Sơn Trà Hotel','1995-06-15','0910000166','staff02@dn02.hotel.vn'),
(434013,'DN02_staff03','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN02 #3','RECEPTIONIST','Đà Nẵng','Sơn Trà Hotel','1995-06-15','0910000167','staff03@dn02.hotel.vn'),
(434014,'DN02_staff04','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN02 #4','RECEPTIONIST','Đà Nẵng','Sơn Trà Hotel','1995-06-15','0910000168','staff04@dn02.hotel.vn'),
(434015,'DN02_staff05','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN02 #5','RECEPTIONIST','Đà Nẵng','Sơn Trà Hotel','1995-06-15','0910000169','staff05@dn02.hotel.vn'),
(434016,'DN02_staff06','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN02 #6','RECEPTIONIST','Đà Nẵng','Sơn Trà Hotel','1995-06-15','0910000170','staff06@dn02.hotel.vn'),
(434017,'DN02_staff07','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN02 #7','RECEPTIONIST','Đà Nẵng','Sơn Trà Hotel','1995-06-15','0910000171','staff07@dn02.hotel.vn'),
(434018,'DN02_staff08','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN02 #8','RECEPTIONIST','Đà Nẵng','Sơn Trà Hotel','1995-06-15','0910000172','staff08@dn02.hotel.vn'),
(434019,'DN02_staff09','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN02 #9','RECEPTIONIST','Đà Nẵng','Sơn Trà Hotel','1995-06-15','0910000173','staff09@dn02.hotel.vn'),
(434020,'DN02_staff10','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN02 #10','RECEPTIONIST','Đà Nẵng','Sơn Trà Hotel','1995-06-15','0910000174','staff10@dn02.hotel.vn');
-- DN=43, HSK=5, 009-016 => 435009-435016
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(435009,'DN02_hsk01','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN02 #1','HOUSEKEEPER','Đà Nẵng','Sơn Trà Hotel','1994-09-27','0910000175','hsk01@dn02.hotel.vn'),
(435010,'DN02_hsk02','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN02 #2','HOUSEKEEPER','Đà Nẵng','Sơn Trà Hotel','1994-09-27','0910000176','hsk02@dn02.hotel.vn'),
(435011,'DN02_hsk03','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN02 #3','HOUSEKEEPER','Đà Nẵng','Sơn Trà Hotel','1994-09-27','0910000177','hsk03@dn02.hotel.vn'),
(435012,'DN02_hsk04','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN02 #4','HOUSEKEEPER','Đà Nẵng','Sơn Trà Hotel','1994-09-27','0910000178','hsk04@dn02.hotel.vn'),
(435013,'DN02_hsk05','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN02 #5','HOUSEKEEPER','Đà Nẵng','Sơn Trà Hotel','1994-09-27','0910000179','hsk05@dn02.hotel.vn'),
(435014,'DN02_hsk06','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN02 #6','HOUSEKEEPER','Đà Nẵng','Sơn Trà Hotel','1994-09-27','0910000180','hsk06@dn02.hotel.vn'),
(435015,'DN02_hsk07','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN02 #7','HOUSEKEEPER','Đà Nẵng','Sơn Trà Hotel','1994-09-27','0910000181','hsk07@dn02.hotel.vn'),
(435016,'DN02_hsk08','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN02 #8','HOUSEKEEPER','Đà Nẵng','Sơn Trà Hotel','1994-09-27','0910000182','hsk08@dn02.hotel.vn');

-- ===== Chi nhánh DN03 (Đà Nẵng - Ngũ Hành Sơn Hotel) =====
-- DN=43, BM=2, 003 => 432003
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(432003,'DN03_manager','$2a$10$cZz/2xo0J9oZ8TovDes8Xem/zAojjezdYdv2FBmJNUlaOCEua/vfK','Quản lý chi nhánh DN03','BRANCH_MANAGER','Đà Nẵng','Ngũ Hành Sơn Hotel','1988-04-12','0910000183','manager@dn03.hotel.vn');
-- DN=43, ADM=3, 015-021 => 433015-433021
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(433015,'DN03_admin01','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN03 #1','ADMIN','Đà Nẵng','Ngũ Hành Sơn Hotel','1992-03-12','0910000184','admin01@dn03.hotel.vn'),
(433016,'DN03_admin02','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN03 #2','ADMIN','Đà Nẵng','Ngũ Hành Sơn Hotel','1992-03-12','0910000185','admin02@dn03.hotel.vn'),
(433017,'DN03_admin03','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN03 #3','ADMIN','Đà Nẵng','Ngũ Hành Sơn Hotel','1992-03-12','0910000186','admin03@dn03.hotel.vn'),
(433018,'DN03_admin04','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN03 #4','ADMIN','Đà Nẵng','Ngũ Hành Sơn Hotel','1992-03-12','0910000187','admin04@dn03.hotel.vn'),
(433019,'DN03_admin05','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN03 #5','ADMIN','Đà Nẵng','Ngũ Hành Sơn Hotel','1992-03-12','0910000188','admin05@dn03.hotel.vn'),
(433020,'DN03_admin06','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN03 #6','ADMIN','Đà Nẵng','Ngũ Hành Sơn Hotel','1992-03-12','0910000189','admin06@dn03.hotel.vn'),
(433021,'DN03_admin07','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN03 #7','ADMIN','Đà Nẵng','Ngũ Hành Sơn Hotel','1992-03-12','0910000190','admin07@dn03.hotel.vn');
-- DN=43, REC=4, 021-030 => 434021-434030
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(434021,'DN03_staff01','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN03 #1','RECEPTIONIST','Đà Nẵng','Ngũ Hành Sơn Hotel','1995-06-15','0910000191','staff01@dn03.hotel.vn'),
(434022,'DN03_staff02','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN03 #2','RECEPTIONIST','Đà Nẵng','Ngũ Hành Sơn Hotel','1995-06-15','0910000192','staff02@dn03.hotel.vn'),
(434023,'DN03_staff03','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN03 #3','RECEPTIONIST','Đà Nẵng','Ngũ Hành Sơn Hotel','1995-06-15','0910000193','staff03@dn03.hotel.vn'),
(434024,'DN03_staff04','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN03 #4','RECEPTIONIST','Đà Nẵng','Ngũ Hành Sơn Hotel','1995-06-15','0910000194','staff04@dn03.hotel.vn'),
(434025,'DN03_staff05','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN03 #5','RECEPTIONIST','Đà Nẵng','Ngũ Hành Sơn Hotel','1995-06-15','0910000195','staff05@dn03.hotel.vn'),
(434026,'DN03_staff06','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN03 #6','RECEPTIONIST','Đà Nẵng','Ngũ Hành Sơn Hotel','1995-06-15','0910000196','staff06@dn03.hotel.vn'),
(434027,'DN03_staff07','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN03 #7','RECEPTIONIST','Đà Nẵng','Ngũ Hành Sơn Hotel','1995-06-15','0910000197','staff07@dn03.hotel.vn'),
(434028,'DN03_staff08','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN03 #8','RECEPTIONIST','Đà Nẵng','Ngũ Hành Sơn Hotel','1995-06-15','0910000198','staff08@dn03.hotel.vn'),
(434029,'DN03_staff09','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN03 #9','RECEPTIONIST','Đà Nẵng','Ngũ Hành Sơn Hotel','1995-06-15','0910000199','staff09@dn03.hotel.vn'),
(434030,'DN03_staff10','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN03 #10','RECEPTIONIST','Đà Nẵng','Ngũ Hành Sơn Hotel','1995-06-15','0910000200','staff10@dn03.hotel.vn');
-- DN=43, HSK=5, 017-024 => 435017-435024
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(435017,'DN03_hsk01','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN03 #1','HOUSEKEEPER','Đà Nẵng','Ngũ Hành Sơn Hotel','1994-09-27','0910000201','hsk01@dn03.hotel.vn'),
(435018,'DN03_hsk02','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN03 #2','HOUSEKEEPER','Đà Nẵng','Ngũ Hành Sơn Hotel','1994-09-27','0910000202','hsk02@dn03.hotel.vn'),
(435019,'DN03_hsk03','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN03 #3','HOUSEKEEPER','Đà Nẵng','Ngũ Hành Sơn Hotel','1994-09-27','0910000203','hsk03@dn03.hotel.vn'),
(435020,'DN03_hsk04','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN03 #4','HOUSEKEEPER','Đà Nẵng','Ngũ Hành Sơn Hotel','1994-09-27','0910000204','hsk04@dn03.hotel.vn'),
(435021,'DN03_hsk05','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN03 #5','HOUSEKEEPER','Đà Nẵng','Ngũ Hành Sơn Hotel','1994-09-27','0910000205','hsk05@dn03.hotel.vn'),
(435022,'DN03_hsk06','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN03 #6','HOUSEKEEPER','Đà Nẵng','Ngũ Hành Sơn Hotel','1994-09-27','0910000206','hsk06@dn03.hotel.vn'),
(435023,'DN03_hsk07','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN03 #7','HOUSEKEEPER','Đà Nẵng','Ngũ Hành Sơn Hotel','1994-09-27','0910000207','hsk07@dn03.hotel.vn'),
(435024,'DN03_hsk08','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN03 #8','HOUSEKEEPER','Đà Nẵng','Ngũ Hành Sơn Hotel','1994-09-27','0910000208','hsk08@dn03.hotel.vn');

-- ===== Chi nhánh DN04 (Đà Nẵng - Thanh Khê Hotel) =====
-- DN=43, BM=2, 004 => 432004
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(432004,'DN04_manager','$2a$10$cZz/2xo0J9oZ8TovDes8Xem/zAojjezdYdv2FBmJNUlaOCEua/vfK','Quản lý chi nhánh DN04','BRANCH_MANAGER','Đà Nẵng','Thanh Khê Hotel','1988-04-12','0910000209','manager@dn04.hotel.vn');
-- DN=43, ADM=3, 022-028 => 433022-433028
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(433022,'DN04_admin01','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN04 #1','ADMIN','Đà Nẵng','Thanh Khê Hotel','1992-03-12','0910000210','admin01@dn04.hotel.vn'),
(433023,'DN04_admin02','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN04 #2','ADMIN','Đà Nẵng','Thanh Khê Hotel','1992-03-12','0910000211','admin02@dn04.hotel.vn'),
(433024,'DN04_admin03','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN04 #3','ADMIN','Đà Nẵng','Thanh Khê Hotel','1992-03-12','0910000212','admin03@dn04.hotel.vn'),
(433025,'DN04_admin04','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN04 #4','ADMIN','Đà Nẵng','Thanh Khê Hotel','1992-03-12','0910000213','admin04@dn04.hotel.vn'),
(433026,'DN04_admin05','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN04 #5','ADMIN','Đà Nẵng','Thanh Khê Hotel','1992-03-12','0910000214','admin05@dn04.hotel.vn'),
(433027,'DN04_admin06','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN04 #6','ADMIN','Đà Nẵng','Thanh Khê Hotel','1992-03-12','0910000215','admin06@dn04.hotel.vn'),
(433028,'DN04_admin07','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin DN04 #7','ADMIN','Đà Nẵng','Thanh Khê Hotel','1992-03-12','0910000216','admin07@dn04.hotel.vn');
-- DN=43, REC=4, 031-040 => 434031-434040
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(434031,'DN04_staff01','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN04 #1','RECEPTIONIST','Đà Nẵng','Thanh Khê Hotel','1995-06-15','0910000217','staff01@dn04.hotel.vn'),
(434032,'DN04_staff02','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN04 #2','RECEPTIONIST','Đà Nẵng','Thanh Khê Hotel','1995-06-15','0910000218','staff02@dn04.hotel.vn'),
(434033,'DN04_staff03','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN04 #3','RECEPTIONIST','Đà Nẵng','Thanh Khê Hotel','1995-06-15','0910000219','staff03@dn04.hotel.vn'),
(434034,'DN04_staff04','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN04 #4','RECEPTIONIST','Đà Nẵng','Thanh Khê Hotel','1995-06-15','0910000220','staff04@dn04.hotel.vn'),
(434035,'DN04_staff05','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN04 #5','RECEPTIONIST','Đà Nẵng','Thanh Khê Hotel','1995-06-15','0910000221','staff05@dn04.hotel.vn'),
(434036,'DN04_staff06','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN04 #6','RECEPTIONIST','Đà Nẵng','Thanh Khê Hotel','1995-06-15','0910000222','staff06@dn04.hotel.vn'),
(434037,'DN04_staff07','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN04 #7','RECEPTIONIST','Đà Nẵng','Thanh Khê Hotel','1995-06-15','0910000223','staff07@dn04.hotel.vn'),
(434038,'DN04_staff08','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN04 #8','RECEPTIONIST','Đà Nẵng','Thanh Khê Hotel','1995-06-15','0910000224','staff08@dn04.hotel.vn'),
(434039,'DN04_staff09','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN04 #9','RECEPTIONIST','Đà Nẵng','Thanh Khê Hotel','1995-06-15','0910000225','staff09@dn04.hotel.vn'),
(434040,'DN04_staff10','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân DN04 #10','RECEPTIONIST','Đà Nẵng','Thanh Khê Hotel','1995-06-15','0910000226','staff10@dn04.hotel.vn');
-- DN=43, HSK=5, 025-032 => 435025-435032
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(435025,'DN04_hsk01','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN04 #1','HOUSEKEEPER','Đà Nẵng','Thanh Khê Hotel','1994-09-27','0910000227','hsk01@dn04.hotel.vn'),
(435026,'DN04_hsk02','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN04 #2','HOUSEKEEPER','Đà Nẵng','Thanh Khê Hotel','1994-09-27','0910000228','hsk02@dn04.hotel.vn'),
(435027,'DN04_hsk03','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN04 #3','HOUSEKEEPER','Đà Nẵng','Thanh Khê Hotel','1994-09-27','0910000229','hsk03@dn04.hotel.vn'),
(435028,'DN04_hsk04','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN04 #4','HOUSEKEEPER','Đà Nẵng','Thanh Khê Hotel','1994-09-27','0910000230','hsk04@dn04.hotel.vn'),
(435029,'DN04_hsk05','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN04 #5','HOUSEKEEPER','Đà Nẵng','Thanh Khê Hotel','1994-09-27','0910000231','hsk05@dn04.hotel.vn'),
(435030,'DN04_hsk06','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN04 #6','HOUSEKEEPER','Đà Nẵng','Thanh Khê Hotel','1994-09-27','0910000232','hsk06@dn04.hotel.vn'),
(435031,'DN04_hsk07','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN04 #7','HOUSEKEEPER','Đà Nẵng','Thanh Khê Hotel','1994-09-27','0910000233','hsk07@dn04.hotel.vn'),
(435032,'DN04_hsk08','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng DN04 #8','HOUSEKEEPER','Đà Nẵng','Thanh Khê Hotel','1994-09-27','0910000234','hsk08@dn04.hotel.vn');

-- ===== Chi nhánh HCM01 (Thành phố Hồ Chí Minh - Quận 1 Hotel) =====
-- HCM=79, BM=2, 001 => 792001
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(792001,'HCM01_manager','$2a$10$cZz/2xo0J9oZ8TovDes8Xem/zAojjezdYdv2FBmJNUlaOCEua/vfK','Quản lý chi nhánh HCM01','BRANCH_MANAGER','Thành phố Hồ Chí Minh','Quận 1 Hotel','1988-04-12','0910000235','manager@hcm01.hotel.vn');
-- HCM=79, ADM=3, 001-007 => 793001-793007
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(793001,'HCM01_admin01','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM01 #1','ADMIN','Thành phố Hồ Chí Minh','Quận 1 Hotel','1992-03-12','0910000236','admin01@hcm01.hotel.vn'),
(793002,'HCM01_admin02','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM01 #2','ADMIN','Thành phố Hồ Chí Minh','Quận 1 Hotel','1992-03-12','0910000237','admin02@hcm01.hotel.vn'),
(793003,'HCM01_admin03','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM01 #3','ADMIN','Thành phố Hồ Chí Minh','Quận 1 Hotel','1992-03-12','0910000238','admin03@hcm01.hotel.vn'),
(793004,'HCM01_admin04','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM01 #4','ADMIN','Thành phố Hồ Chí Minh','Quận 1 Hotel','1992-03-12','0910000239','admin04@hcm01.hotel.vn'),
(793005,'HCM01_admin05','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM01 #5','ADMIN','Thành phố Hồ Chí Minh','Quận 1 Hotel','1992-03-12','0910000240','admin05@hcm01.hotel.vn'),
(793006,'HCM01_admin06','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM01 #6','ADMIN','Thành phố Hồ Chí Minh','Quận 1 Hotel','1992-03-12','0910000241','admin06@hcm01.hotel.vn'),
(793007,'HCM01_admin07','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM01 #7','ADMIN','Thành phố Hồ Chí Minh','Quận 1 Hotel','1992-03-12','0910000242','admin07@hcm01.hotel.vn');
-- HCM=79, REC=4, 001-010 => 794001-794010
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(794001,'HCM01_staff01','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM01 #1','RECEPTIONIST','Thành phố Hồ Chí Minh','Quận 1 Hotel','1995-06-15','0910000243','staff01@hcm01.hotel.vn'),
(794002,'HCM01_staff02','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM01 #2','RECEPTIONIST','Thành phố Hồ Chí Minh','Quận 1 Hotel','1995-06-15','0910000244','staff02@hcm01.hotel.vn'),
(794003,'HCM01_staff03','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM01 #3','RECEPTIONIST','Thành phố Hồ Chí Minh','Quận 1 Hotel','1995-06-15','0910000245','staff03@hcm01.hotel.vn'),
(794004,'HCM01_staff04','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM01 #4','RECEPTIONIST','Thành phố Hồ Chí Minh','Quận 1 Hotel','1995-06-15','0910000246','staff04@hcm01.hotel.vn'),
(794005,'HCM01_staff05','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM01 #5','RECEPTIONIST','Thành phố Hồ Chí Minh','Quận 1 Hotel','1995-06-15','0910000247','staff05@hcm01.hotel.vn'),
(794006,'HCM01_staff06','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM01 #6','RECEPTIONIST','Thành phố Hồ Chí Minh','Quận 1 Hotel','1995-06-15','0910000248','staff06@hcm01.hotel.vn'),
(794007,'HCM01_staff07','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM01 #7','RECEPTIONIST','Thành phố Hồ Chí Minh','Quận 1 Hotel','1995-06-15','0910000249','staff07@hcm01.hotel.vn'),
(794008,'HCM01_staff08','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM01 #8','RECEPTIONIST','Thành phố Hồ Chí Minh','Quận 1 Hotel','1995-06-15','0910000250','staff08@hcm01.hotel.vn'),
(794009,'HCM01_staff09','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM01 #9','RECEPTIONIST','Thành phố Hồ Chí Minh','Quận 1 Hotel','1995-06-15','0910000251','staff09@hcm01.hotel.vn'),
(794010,'HCM01_staff10','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM01 #10','RECEPTIONIST','Thành phố Hồ Chí Minh','Quận 1 Hotel','1995-06-15','0910000252','staff10@hcm01.hotel.vn');
-- HCM=79, HSK=5, 001-008 => 795001-795008
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(795001,'HCM01_hsk01','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM01 #1','HOUSEKEEPER','Thành phố Hồ Chí Minh','Quận 1 Hotel','1994-09-27','0910000253','hsk01@hcm01.hotel.vn'),
(795002,'HCM01_hsk02','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM01 #2','HOUSEKEEPER','Thành phố Hồ Chí Minh','Quận 1 Hotel','1994-09-27','0910000254','hsk02@hcm01.hotel.vn'),
(795003,'HCM01_hsk03','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM01 #3','HOUSEKEEPER','Thành phố Hồ Chí Minh','Quận 1 Hotel','1994-09-27','0910000255','hsk03@hcm01.hotel.vn'),
(795004,'HCM01_hsk04','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM01 #4','HOUSEKEEPER','Thành phố Hồ Chí Minh','Quận 1 Hotel','1994-09-27','0910000256','hsk04@hcm01.hotel.vn'),
(795005,'HCM01_hsk05','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM01 #5','HOUSEKEEPER','Thành phố Hồ Chí Minh','Quận 1 Hotel','1994-09-27','0910000257','hsk05@hcm01.hotel.vn'),
(795006,'HCM01_hsk06','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM01 #6','HOUSEKEEPER','Thành phố Hồ Chí Minh','Quận 1 Hotel','1994-09-27','0910000258','hsk06@hcm01.hotel.vn'),
(795007,'HCM01_hsk07','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM01 #7','HOUSEKEEPER','Thành phố Hồ Chí Minh','Quận 1 Hotel','1994-09-27','0910000259','hsk07@hcm01.hotel.vn'),
(795008,'HCM01_hsk08','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM01 #8','HOUSEKEEPER','Thành phố Hồ Chí Minh','Quận 1 Hotel','1994-09-27','0910000260','hsk08@hcm01.hotel.vn');

-- ===== Chi nhánh HCM02 (Thành phố Hồ Chí Minh - Quận 3 Hotel) =====
-- HCM=79, BM=2, 002 => 792002
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(792002,'HCM02_manager','$2a$10$cZz/2xo0J9oZ8TovDes8Xem/zAojjezdYdv2FBmJNUlaOCEua/vfK','Quản lý chi nhánh HCM02','BRANCH_MANAGER','Thành phố Hồ Chí Minh','Quận 3 Hotel','1988-04-12','0910000261','manager@hcm02.hotel.vn');
-- HCM=79, ADM=3, 008-014 => 793008-793014
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(793008,'HCM02_admin01','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM02 #1','ADMIN','Thành phố Hồ Chí Minh','Quận 3 Hotel','1992-03-12','0910000262','admin01@hcm02.hotel.vn'),
(793009,'HCM02_admin02','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM02 #2','ADMIN','Thành phố Hồ Chí Minh','Quận 3 Hotel','1992-03-12','0910000263','admin02@hcm02.hotel.vn'),
(793010,'HCM02_admin03','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM02 #3','ADMIN','Thành phố Hồ Chí Minh','Quận 3 Hotel','1992-03-12','0910000264','admin03@hcm02.hotel.vn'),
(793011,'HCM02_admin04','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM02 #4','ADMIN','Thành phố Hồ Chí Minh','Quận 3 Hotel','1992-03-12','0910000265','admin04@hcm02.hotel.vn'),
(793012,'HCM02_admin05','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM02 #5','ADMIN','Thành phố Hồ Chí Minh','Quận 3 Hotel','1992-03-12','0910000266','admin05@hcm02.hotel.vn'),
(793013,'HCM02_admin06','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM02 #6','ADMIN','Thành phố Hồ Chí Minh','Quận 3 Hotel','1992-03-12','0910000267','admin06@hcm02.hotel.vn'),
(793014,'HCM02_admin07','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM02 #7','ADMIN','Thành phố Hồ Chí Minh','Quận 3 Hotel','1992-03-12','0910000268','admin07@hcm02.hotel.vn');
-- HCM=79, REC=4, 011-020 => 794011-794020
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(794011,'HCM02_staff01','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM02 #1','RECEPTIONIST','Thành phố Hồ Chí Minh','Quận 3 Hotel','1995-06-15','0910000269','staff01@hcm02.hotel.vn'),
(794012,'HCM02_staff02','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM02 #2','RECEPTIONIST','Thành phố Hồ Chí Minh','Quận 3 Hotel','1995-06-15','0910000270','staff02@hcm02.hotel.vn'),
(794013,'HCM02_staff03','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM02 #3','RECEPTIONIST','Thành phố Hồ Chí Minh','Quận 3 Hotel','1995-06-15','0910000271','staff03@hcm02.hotel.vn'),
(794014,'HCM02_staff04','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM02 #4','RECEPTIONIST','Thành phố Hồ Chí Minh','Quận 3 Hotel','1995-06-15','0910000272','staff04@hcm02.hotel.vn'),
(794015,'HCM02_staff05','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM02 #5','RECEPTIONIST','Thành phố Hồ Chí Minh','Quận 3 Hotel','1995-06-15','0910000273','staff05@hcm02.hotel.vn'),
(794016,'HCM02_staff06','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM02 #6','RECEPTIONIST','Thành phố Hồ Chí Minh','Quận 3 Hotel','1995-06-15','0910000274','staff06@hcm02.hotel.vn'),
(794017,'HCM02_staff07','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM02 #7','RECEPTIONIST','Thành phố Hồ Chí Minh','Quận 3 Hotel','1995-06-15','0910000275','staff07@hcm02.hotel.vn'),
(794018,'HCM02_staff08','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM02 #8','RECEPTIONIST','Thành phố Hồ Chí Minh','Quận 3 Hotel','1995-06-15','0910000276','staff08@hcm02.hotel.vn'),
(794019,'HCM02_staff09','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM02 #9','RECEPTIONIST','Thành phố Hồ Chí Minh','Quận 3 Hotel','1995-06-15','0910000277','staff09@hcm02.hotel.vn'),
(794020,'HCM02_staff10','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM02 #10','RECEPTIONIST','Thành phố Hồ Chí Minh','Quận 3 Hotel','1995-06-15','0910000278','staff10@hcm02.hotel.vn');
-- HCM=79, HSK=5, 009-016 => 795009-795016
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(795009,'HCM02_hsk01','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM02 #1','HOUSEKEEPER','Thành phố Hồ Chí Minh','Quận 3 Hotel','1994-09-27','0910000279','hsk01@hcm02.hotel.vn'),
(795010,'HCM02_hsk02','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM02 #2','HOUSEKEEPER','Thành phố Hồ Chí Minh','Quận 3 Hotel','1994-09-27','0910000280','hsk02@hcm02.hotel.vn'),
(795011,'HCM02_hsk03','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM02 #3','HOUSEKEEPER','Thành phố Hồ Chí Minh','Quận 3 Hotel','1994-09-27','0910000281','hsk03@hcm02.hotel.vn'),
(795012,'HCM02_hsk04','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM02 #4','HOUSEKEEPER','Thành phố Hồ Chí Minh','Quận 3 Hotel','1994-09-27','0910000282','hsk04@hcm02.hotel.vn'),
(795013,'HCM02_hsk05','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM02 #5','HOUSEKEEPER','Thành phố Hồ Chí Minh','Quận 3 Hotel','1994-09-27','0910000283','hsk05@hcm02.hotel.vn'),
(795014,'HCM02_hsk06','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM02 #6','HOUSEKEEPER','Thành phố Hồ Chí Minh','Quận 3 Hotel','1994-09-27','0910000284','hsk06@hcm02.hotel.vn'),
(795015,'HCM02_hsk07','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM02 #7','HOUSEKEEPER','Thành phố Hồ Chí Minh','Quận 3 Hotel','1994-09-27','0910000285','hsk07@hcm02.hotel.vn'),
(795016,'HCM02_hsk08','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM02 #8','HOUSEKEEPER','Thành phố Hồ Chí Minh','Quận 3 Hotel','1994-09-27','0910000286','hsk08@hcm02.hotel.vn');

-- ===== Chi nhánh HCM03 (Thành phố Hồ Chí Minh - Phú Nhuận Hotel) =====
-- HCM=79, BM=2, 003 => 792003
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(792003,'HCM03_manager','$2a$10$cZz/2xo0J9oZ8TovDes8Xem/zAojjezdYdv2FBmJNUlaOCEua/vfK','Quản lý chi nhánh HCM03','BRANCH_MANAGER','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1988-04-12','0910000287','manager@hcm03.hotel.vn');
-- HCM=79, ADM=3, 015-021 => 793015-793021
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(793015,'HCM03_admin01','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM03 #1','ADMIN','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1992-03-12','0910000288','admin01@hcm03.hotel.vn'),
(793016,'HCM03_admin02','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM03 #2','ADMIN','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1992-03-12','0910000289','admin02@hcm03.hotel.vn'),
(793017,'HCM03_admin03','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM03 #3','ADMIN','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1992-03-12','0910000290','admin03@hcm03.hotel.vn'),
(793018,'HCM03_admin04','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM03 #4','ADMIN','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1992-03-12','0910000291','admin04@hcm03.hotel.vn'),
(793019,'HCM03_admin05','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM03 #5','ADMIN','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1992-03-12','0910000292','admin05@hcm03.hotel.vn'),
(793020,'HCM03_admin06','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM03 #6','ADMIN','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1992-03-12','0910000293','admin06@hcm03.hotel.vn'),
(793021,'HCM03_admin07','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM03 #7','ADMIN','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1992-03-12','0910000294','admin07@hcm03.hotel.vn');
-- HCM=79, REC=4, 021-030 => 794021-794030
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(794021,'HCM03_staff01','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM03 #1','RECEPTIONIST','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1995-06-15','0910000295','staff01@hcm03.hotel.vn'),
(794022,'HCM03_staff02','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM03 #2','RECEPTIONIST','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1995-06-15','0910000296','staff02@hcm03.hotel.vn'),
(794023,'HCM03_staff03','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM03 #3','RECEPTIONIST','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1995-06-15','0910000297','staff03@hcm03.hotel.vn'),
(794024,'HCM03_staff04','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM03 #4','RECEPTIONIST','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1995-06-15','0910000298','staff04@hcm03.hotel.vn'),
(794025,'HCM03_staff05','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM03 #5','RECEPTIONIST','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1995-06-15','0910000299','staff05@hcm03.hotel.vn'),
(794026,'HCM03_staff06','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM03 #6','RECEPTIONIST','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1995-06-15','0910000300','staff06@hcm03.hotel.vn'),
(794027,'HCM03_staff07','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM03 #7','RECEPTIONIST','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1995-06-15','0910000301','staff07@hcm03.hotel.vn'),
(794028,'HCM03_staff08','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM03 #8','RECEPTIONIST','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1995-06-15','0910000302','staff08@hcm03.hotel.vn'),
(794029,'HCM03_staff09','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM03 #9','RECEPTIONIST','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1995-06-15','0910000303','staff09@hcm03.hotel.vn'),
(794030,'HCM03_staff10','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM03 #10','RECEPTIONIST','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1995-06-15','0910000304','staff10@hcm03.hotel.vn');
-- HCM=79, HSK=5, 017-024 => 795017-795024
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(795017,'HCM03_hsk01','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM03 #1','HOUSEKEEPER','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1994-09-27','0910000305','hsk01@hcm03.hotel.vn'),
(795018,'HCM03_hsk02','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM03 #2','HOUSEKEEPER','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1994-09-27','0910000306','hsk02@hcm03.hotel.vn'),
(795019,'HCM03_hsk03','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM03 #3','HOUSEKEEPER','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1994-09-27','0910000307','hsk03@hcm03.hotel.vn'),
(795020,'HCM03_hsk04','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM03 #4','HOUSEKEEPER','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1994-09-27','0910000308','hsk04@hcm03.hotel.vn'),
(795021,'HCM03_hsk05','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM03 #5','HOUSEKEEPER','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1994-09-27','0910000309','hsk05@hcm03.hotel.vn'),
(795022,'HCM03_hsk06','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM03 #6','HOUSEKEEPER','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1994-09-27','0910000310','hsk06@hcm03.hotel.vn'),
(795023,'HCM03_hsk07','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM03 #7','HOUSEKEEPER','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1994-09-27','0910000311','hsk07@hcm03.hotel.vn'),
(795024,'HCM03_hsk08','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM03 #8','HOUSEKEEPER','Thành phố Hồ Chí Minh','Phú Nhuận Hotel','1994-09-27','0910000312','hsk08@hcm03.hotel.vn');

-- ===== Chi nhánh HCM04 (Thành phố Hồ Chí Minh - Tân Bình Hotel) =====
-- HCM=79, BM=2, 004 => 792004
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(792004,'HCM04_manager','$2a$10$cZz/2xo0J9oZ8TovDes8Xem/zAojjezdYdv2FBmJNUlaOCEua/vfK','Quản lý chi nhánh HCM04','BRANCH_MANAGER','Thành phố Hồ Chí Minh','Tân Bình Hotel','1988-04-12','0910000313','manager@hcm04.hotel.vn');
-- HCM=79, ADM=3, 022-028 => 793022-793028
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(793022,'HCM04_admin01','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM04 #1','ADMIN','Thành phố Hồ Chí Minh','Tân Bình Hotel','1992-03-12','0910000314','admin01@hcm04.hotel.vn'),
(793023,'HCM04_admin02','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM04 #2','ADMIN','Thành phố Hồ Chí Minh','Tân Bình Hotel','1992-03-12','0910000315','admin02@hcm04.hotel.vn'),
(793024,'HCM04_admin03','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM04 #3','ADMIN','Thành phố Hồ Chí Minh','Tân Bình Hotel','1992-03-12','0910000316','admin03@hcm04.hotel.vn'),
(793025,'HCM04_admin04','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM04 #4','ADMIN','Thành phố Hồ Chí Minh','Tân Bình Hotel','1992-03-12','0910000317','admin04@hcm04.hotel.vn'),
(793026,'HCM04_admin05','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM04 #5','ADMIN','Thành phố Hồ Chí Minh','Tân Bình Hotel','1992-03-12','0910000318','admin05@hcm04.hotel.vn'),
(793027,'HCM04_admin06','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM04 #6','ADMIN','Thành phố Hồ Chí Minh','Tân Bình Hotel','1992-03-12','0910000319','admin06@hcm04.hotel.vn'),
(793028,'HCM04_admin07','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM04 #7','ADMIN','Thành phố Hồ Chí Minh','Tân Bình Hotel','1992-03-12','0910000320','admin07@hcm04.hotel.vn');
-- HCM=79, REC=4, 031-040 => 794031-794040
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(794031,'HCM04_staff01','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM04 #1','RECEPTIONIST','Thành phố Hồ Chí Minh','Tân Bình Hotel','1995-06-15','0910000321','staff01@hcm04.hotel.vn'),
(794032,'HCM04_staff02','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM04 #2','RECEPTIONIST','Thành phố Hồ Chí Minh','Tân Bình Hotel','1995-06-15','0910000322','staff02@hcm04.hotel.vn'),
(794033,'HCM04_staff03','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM04 #3','RECEPTIONIST','Thành phố Hồ Chí Minh','Tân Bình Hotel','1995-06-15','0910000323','staff03@hcm04.hotel.vn'),
(794034,'HCM04_staff04','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM04 #4','RECEPTIONIST','Thành phố Hồ Chí Minh','Tân Bình Hotel','1995-06-15','0910000324','staff04@hcm04.hotel.vn'),
(794035,'HCM04_staff05','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM04 #5','RECEPTIONIST','Thành phố Hồ Chí Minh','Tân Bình Hotel','1995-06-15','0910000325','staff05@hcm04.hotel.vn'),
(794036,'HCM04_staff06','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM04 #6','RECEPTIONIST','Thành phố Hồ Chí Minh','Tân Bình Hotel','1995-06-15','0910000326','staff06@hcm04.hotel.vn'),
(794037,'HCM04_staff07','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM04 #7','RECEPTIONIST','Thành phố Hồ Chí Minh','Tân Bình Hotel','1995-06-15','0910000327','staff07@hcm04.hotel.vn'),
(794038,'HCM04_staff08','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM04 #8','RECEPTIONIST','Thành phố Hồ Chí Minh','Tân Bình Hotel','1995-06-15','0910000328','staff08@hcm04.hotel.vn'),
(794039,'HCM04_staff09','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM04 #9','RECEPTIONIST','Thành phố Hồ Chí Minh','Tân Bình Hotel','1995-06-15','0910000329','staff09@hcm04.hotel.vn'),
(794040,'HCM04_staff10','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM04 #10','RECEPTIONIST','Thành phố Hồ Chí Minh','Tân Bình Hotel','1995-06-15','0910000330','staff10@hcm04.hotel.vn');
-- HCM=79, HSK=5, 025-032 => 795025-795032
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(795025,'HCM04_hsk01','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM04 #1','HOUSEKEEPER','Thành phố Hồ Chí Minh','Tân Bình Hotel','1994-09-27','0910000331','hsk01@hcm04.hotel.vn'),
(795026,'HCM04_hsk02','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM04 #2','HOUSEKEEPER','Thành phố Hồ Chí Minh','Tân Bình Hotel','1994-09-27','0910000332','hsk02@hcm04.hotel.vn'),
(795027,'HCM04_hsk03','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM04 #3','HOUSEKEEPER','Thành phố Hồ Chí Minh','Tân Bình Hotel','1994-09-27','0910000333','hsk03@hcm04.hotel.vn'),
(795028,'HCM04_hsk04','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM04 #4','HOUSEKEEPER','Thành phố Hồ Chí Minh','Tân Bình Hotel','1994-09-27','0910000334','hsk04@hcm04.hotel.vn'),
(795029,'HCM04_hsk05','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM04 #5','HOUSEKEEPER','Thành phố Hồ Chí Minh','Tân Bình Hotel','1994-09-27','0910000335','hsk05@hcm04.hotel.vn'),
(795030,'HCM04_hsk06','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM04 #6','HOUSEKEEPER','Thành phố Hồ Chí Minh','Tân Bình Hotel','1994-09-27','0910000336','hsk06@hcm04.hotel.vn'),
(795031,'HCM04_hsk07','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM04 #7','HOUSEKEEPER','Thành phố Hồ Chí Minh','Tân Bình Hotel','1994-09-27','0910000337','hsk07@hcm04.hotel.vn'),
(795032,'HCM04_hsk08','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM04 #8','HOUSEKEEPER','Thành phố Hồ Chí Minh','Tân Bình Hotel','1994-09-27','0910000338','hsk08@hcm04.hotel.vn');

-- ===== Chi nhánh HCM05 (Thành phố Hồ Chí Minh - Thủ Đức Hotel) =====
-- HCM=79, BM=2, 005 => 792005
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(792005,'HCM05_manager','$2a$10$cZz/2xo0J9oZ8TovDes8Xem/zAojjezdYdv2FBmJNUlaOCEua/vfK','Quản lý chi nhánh HCM05','BRANCH_MANAGER','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1988-04-12','0910000339','manager@hcm05.hotel.vn');
-- HCM=79, ADM=3, 029-035 => 793029-793035
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(793029,'HCM05_admin01','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM05 #1','ADMIN','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1992-03-12','0910000340','admin01@hcm05.hotel.vn'),
(793030,'HCM05_admin02','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM05 #2','ADMIN','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1992-03-12','0910000341','admin02@hcm05.hotel.vn'),
(793031,'HCM05_admin03','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM05 #3','ADMIN','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1992-03-12','0910000342','admin03@hcm05.hotel.vn'),
(793032,'HCM05_admin04','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM05 #4','ADMIN','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1992-03-12','0910000343','admin04@hcm05.hotel.vn'),
(793033,'HCM05_admin05','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM05 #5','ADMIN','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1992-03-12','0910000344','admin05@hcm05.hotel.vn'),
(793034,'HCM05_admin06','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM05 #6','ADMIN','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1992-03-12','0910000345','admin06@hcm05.hotel.vn'),
(793035,'HCM05_admin07','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin HCM05 #7','ADMIN','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1992-03-12','0910000346','admin07@hcm05.hotel.vn');
-- HCM=79, REC=4, 041-050 => 794041-794050
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(794041,'HCM05_staff01','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM05 #1','RECEPTIONIST','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1995-06-15','0910000347','staff01@hcm05.hotel.vn'),
(794042,'HCM05_staff02','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM05 #2','RECEPTIONIST','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1995-06-15','0910000348','staff02@hcm05.hotel.vn'),
(794043,'HCM05_staff03','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM05 #3','RECEPTIONIST','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1995-06-15','0910000349','staff03@hcm05.hotel.vn'),
(794044,'HCM05_staff04','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM05 #4','RECEPTIONIST','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1995-06-15','0910000336','staff04@hcm05.hotel.vn'),
(794045,'HCM05_staff05','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM05 #5','RECEPTIONIST','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1995-06-15','0910000337','staff05@hcm05.hotel.vn'),
(794046,'HCM05_staff06','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM05 #6','RECEPTIONIST','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1995-06-15','0910000338','staff06@hcm05.hotel.vn'),
(794047,'HCM05_staff07','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM05 #7','RECEPTIONIST','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1995-06-15','0910000339','staff07@hcm05.hotel.vn'),
(794048,'HCM05_staff08','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM05 #8','RECEPTIONIST','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1995-06-15','0910000340','staff08@hcm05.hotel.vn'),
(794049,'HCM05_staff09','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM05 #9','RECEPTIONIST','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1995-06-15','0910000341','staff09@hcm05.hotel.vn'),
(794050,'HCM05_staff10','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân HCM05 #10','RECEPTIONIST','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1995-06-15','0910000342','staff10@hcm05.hotel.vn');
-- HCM=79, HSK=5, 033-040 => 795033-795040
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(795033,'HCM05_hsk01','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM05 #1','HOUSEKEEPER','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1994-09-27','0910000343','hsk01@hcm05.hotel.vn'),
(795034,'HCM05_hsk02','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM05 #2','HOUSEKEEPER','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1994-09-27','0910000344','hsk02@hcm05.hotel.vn'),
(795035,'HCM05_hsk03','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM05 #3','HOUSEKEEPER','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1994-09-27','0910000345','hsk03@hcm05.hotel.vn'),
(795036,'HCM05_hsk04','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM05 #4','HOUSEKEEPER','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1994-09-27','0910000346','hsk04@hcm05.hotel.vn'),
(795037,'HCM05_hsk05','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM05 #5','HOUSEKEEPER','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1994-09-27','0910000347','hsk05@hcm05.hotel.vn'),
(795038,'HCM05_hsk06','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM05 #6','HOUSEKEEPER','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1994-09-27','0910000348','hsk06@hcm05.hotel.vn'),
(795039,'HCM05_hsk07','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM05 #7','HOUSEKEEPER','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1994-09-27','0910000349','hsk07@hcm05.hotel.vn'),
(795040,'HCM05_hsk08','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng HCM05 #8','HOUSEKEEPER','Thành phố Hồ Chí Minh','Thủ Đức Hotel','1994-09-27','0910000350','hsk08@hcm05.hotel.vn');

-- ===== Chi nhánh PQ01 (Phú Quốc - Dương Đông Hotel) =====
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(91012001,'PQ01_manager','$2a$10$cZz/2xo0J9oZ8TovDes8Xem/zAojjezdYdv2FBmJNUlaOCEua/vfK','Quản lý chi nhánh PQ01','BRANCH_MANAGER','Phú Quốc','Dương Đông Hotel','1988-04-12','0910000351','manager@pq01.hotel.vn');

INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(91013001,'PQ01_admin01','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin PQ01 #1','ADMIN','Phú Quốc','Dương Đông Hotel','1992-03-12','0910000352','admin01@pq01.hotel.vn'),
(91013002,'PQ01_admin02','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin PQ01 #2','ADMIN','Phú Quốc','Dương Đông Hotel','1992-03-12','0910000353','admin02@pq01.hotel.vn'),
(91013003,'PQ01_admin03','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin PQ01 #3','ADMIN','Phú Quốc','Dương Đông Hotel','1992-03-12','0910000354','admin03@pq01.hotel.vn'),
(91013004,'PQ01_admin04','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin PQ01 #4','ADMIN','Phú Quốc','Dương Đông Hotel','1992-03-12','0910000355','admin04@pq01.hotel.vn'),
(91013005,'PQ01_admin05','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin PQ01 #5','ADMIN','Phú Quốc','Dương Đông Hotel','1992-03-12','0910000356','admin05@pq01.hotel.vn'),
(91013006,'PQ01_admin06','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin PQ01 #6','ADMIN','Phú Quốc','Dương Đông Hotel','1992-03-12','0910000357','admin06@pq01.hotel.vn'),
(91013007,'PQ01_admin07','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin PQ01 #7','ADMIN','Phú Quốc','Dương Đông Hotel','1992-03-12','0910000358','admin07@pq01.hotel.vn');

INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(91014001,'PQ01_staff01','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân PQ01 #1','RECEPTIONIST','Phú Quốc','Dương Đông Hotel','1995-06-15','0910000359','staff01@pq01.hotel.vn'),
(91014002,'PQ01_staff02','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân PQ01 #2','RECEPTIONIST','Phú Quốc','Dương Đông Hotel','1995-06-15','0910000360','staff02@pq01.hotel.vn'),
(91014003,'PQ01_staff03','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân PQ01 #3','RECEPTIONIST','Phú Quốc','Dương Đông Hotel','1995-06-15','0910000361','staff03@pq01.hotel.vn'),
(91014004,'PQ01_staff04','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân PQ01 #4','RECEPTIONIST','Phú Quốc','Dương Đông Hotel','1995-06-15','0910000362','staff04@pq01.hotel.vn'),
(91014005,'PQ01_staff05','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân PQ01 #5','RECEPTIONIST','Phú Quốc','Dương Đông Hotel','1995-06-15','0910000363','staff05@pq01.hotel.vn'),
(91014006,'PQ01_staff06','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân PQ01 #6','RECEPTIONIST','Phú Quốc','Dương Đông Hotel','1995-06-15','0910000364','staff06@pq01.hotel.vn'),
(91014007,'PQ01_staff07','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân PQ01 #7','RECEPTIONIST','Phú Quốc','Dương Đông Hotel','1995-06-15','0910000365','staff07@pq01.hotel.vn'),
(91014008,'PQ01_staff08','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân PQ01 #8','RECEPTIONIST','Phú Quốc','Dương Đông Hotel','1995-06-15','0910000366','staff08@pq01.hotel.vn'),
(91014009,'PQ01_staff09','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân PQ01 #9','RECEPTIONIST','Phú Quốc','Dương Đông Hotel','1995-06-15','0910000367','staff09@pq01.hotel.vn'),
(91014010,'PQ01_staff10','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân PQ01 #10','RECEPTIONIST','Phú Quốc','Dương Đông Hotel','1995-06-15','0910000368','staff10@pq01.hotel.vn');

INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(91015001,'PQ01_hsk01','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng PQ01 #1','HOUSEKEEPER','Phú Quốc','Dương Đông Hotel','1994-09-27','0910000369','hsk01@pq01.hotel.vn'),
(91015002,'PQ01_hsk02','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng PQ01 #2','HOUSEKEEPER','Phú Quốc','Dương Đông Hotel','1994-09-27','0910000370','hsk02@pq01.hotel.vn'),
(91015003,'PQ01_hsk03','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng PQ01 #3','HOUSEKEEPER','Phú Quốc','Dương Đông Hotel','1994-09-27','0910000371','hsk03@pq01.hotel.vn'),
(91015004,'PQ01_hsk04','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng PQ01 #4','HOUSEKEEPER','Phú Quốc','Dương Đông Hotel','1994-09-27','0910000372','hsk04@pq01.hotel.vn'),
(91015005,'PQ01_hsk05','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng PQ01 #5','HOUSEKEEPER','Phú Quốc','Dương Đông Hotel','1994-09-27','0910000373','hsk05@pq01.hotel.vn'),
(91015006,'PQ01_hsk06','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng PQ01 #6','HOUSEKEEPER','Phú Quốc','Dương Đông Hotel','1994-09-27','0910000374','hsk06@pq01.hotel.vn'),
(91015007,'PQ01_hsk07','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng PQ01 #7','HOUSEKEEPER','Phú Quốc','Dương Đông Hotel','1994-09-27','0910000375','hsk07@pq01.hotel.vn'),
(91015008,'PQ01_hsk08','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng PQ01 #8','HOUSEKEEPER','Phú Quốc','Dương Đông Hotel','1994-09-27','0910000376','hsk08@pq01.hotel.vn');

-- ===== Chi nhánh PQ02 (Phú Quốc - An Thới Hotel) =====
INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(91022001,'PQ02_manager','$2a$10$cZz/2xo0J9oZ8TovDes8Xem/zAojjezdYdv2FBmJNUlaOCEua/vfK','Quản lý chi nhánh PQ02','BRANCH_MANAGER','Phú Quốc','An Thới Hotel','1988-04-12','0910000377','manager@pq02.hotel.vn');

INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(91023001,'PQ02_admin01','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin PQ02 #1','ADMIN','Phú Quốc','An Thới Hotel','1992-03-12','0910000378','admin01@pq02.hotel.vn'),
(91023002,'PQ02_admin02','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin PQ02 #2','ADMIN','Phú Quốc','An Thới Hotel','1992-03-12','0910000379','admin02@pq02.hotel.vn'),
(91023003,'PQ02_admin03','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin PQ02 #3','ADMIN','Phú Quốc','An Thới Hotel','1992-03-12','0910000380','admin03@pq02.hotel.vn'),
(91023004,'PQ02_admin04','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin PQ02 #4','ADMIN','Phú Quốc','An Thới Hotel','1992-03-12','0910000381','admin04@pq02.hotel.vn'),
(91023005,'PQ02_admin05','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin PQ02 #5','ADMIN','Phú Quốc','An Thới Hotel','1992-03-12','0910000382','admin05@pq02.hotel.vn'),
(91023006,'PQ02_admin06','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin PQ02 #6','ADMIN','Phú Quốc','An Thới Hotel','1992-03-12','0910000383','admin06@pq02.hotel.vn'),
(91023007,'PQ02_admin07','$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q','Admin PQ02 #7','ADMIN','Phú Quốc','An Thới Hotel','1992-03-12','0910000384','admin07@pq02.hotel.vn');

INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(91024001,'PQ02_staff01','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân PQ02 #1','RECEPTIONIST','Phú Quốc','An Thới Hotel','1995-06-15','0910000385','staff01@pq02.hotel.vn'),
(91024002,'PQ02_staff02','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân PQ02 #2','RECEPTIONIST','Phú Quốc','An Thới Hotel','1995-06-15','0910000386','staff02@pq02.hotel.vn'),
(91024003,'PQ02_staff03','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân PQ02 #3','RECEPTIONIST','Phú Quốc','An Thới Hotel','1995-06-15','0910000387','staff03@pq02.hotel.vn'),
(91024004,'PQ02_staff04','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân PQ02 #4','RECEPTIONIST','Phú Quốc','An Thới Hotel','1995-06-15','0910000388','staff04@pq02.hotel.vn'),
(91024005,'PQ02_staff05','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân PQ02 #5','RECEPTIONIST','Phú Quốc','An Thới Hotel','1995-06-15','0910000389','staff05@pq02.hotel.vn'),
(91024006,'PQ02_staff06','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân PQ02 #6','RECEPTIONIST','Phú Quốc','An Thới Hotel','1995-06-15','0910000390','staff06@pq02.hotel.vn'),
(91024007,'PQ02_staff07','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân PQ02 #7','RECEPTIONIST','Phú Quốc','An Thới Hotel','1995-06-15','0910000391','staff07@pq02.hotel.vn'),
(91024008,'PQ02_staff08','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân PQ02 #8','RECEPTIONIST','Phú Quốc','An Thới Hotel','1995-06-15','0910000392','staff08@pq02.hotel.vn'),
(91024009,'PQ02_staff09','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân PQ02 #9','RECEPTIONIST','Phú Quốc','An Thới Hotel','1995-06-15','0910000393','staff09@pq02.hotel.vn'),
(91024010,'PQ02_staff10','$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2','Lễ tân PQ02 #10','RECEPTIONIST','Phú Quốc','An Thới Hotel','1995-06-15','0910000394','staff10@pq02.hotel.vn');

INSERT INTO users (id, username, password, full_name, role, city, branch_name, birthday, phone_number, email) VALUES
(91025001,'PQ02_hsk01','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng PQ02 #1','HOUSEKEEPER','Phú Quốc','An Thới Hotel','1994-09-27','0910000395','hsk01@pq02.hotel.vn'),
(91025002,'PQ02_hsk02','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng PQ02 #2','HOUSEKEEPER','Phú Quốc','An Thới Hotel','1994-09-27','0910000396','hsk02@pq02.hotel.vn'),
(91025003,'PQ02_hsk03','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng PQ02 #3','HOUSEKEEPER','Phú Quốc','An Thới Hotel','1994-09-27','0910000397','hsk03@pq02.hotel.vn'),
(91025004,'PQ02_hsk04','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng PQ02 #4','HOUSEKEEPER','Phú Quốc','An Thới Hotel','1994-09-27','0910000398','hsk04@pq02.hotel.vn'),
(91025005,'PQ02_hsk05','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng PQ02 #5','HOUSEKEEPER','Phú Quốc','An Thới Hotel','1994-09-27','0910000399','hsk05@pq02.hotel.vn'),
(91025006,'PQ02_hsk06','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng PQ02 #6','HOUSEKEEPER','Phú Quốc','An Thới Hotel','1994-09-27','0910000400','hsk06@pq02.hotel.vn'),
(91025007,'PQ02_hsk07','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng PQ02 #7','HOUSEKEEPER','Phú Quốc','An Thới Hotel','1994-09-27','0910000401','hsk07@pq02.hotel.vn'),
(91025008,'PQ02_hsk08','$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO','Dọn phòng PQ02 #8','HOUSEKEEPER','Phú Quốc','An Thới Hotel','1994-09-27','0910000402','hsk08@pq02.hotel.vn');

-- =========================
-- INSERT ROOMS (50 phòng / chi nhánh)
-- rooms.id = <BRANCH_CODE>-<ROOM_CODE> ; room_number = <ROOM_CODE>
-- =========================
INSERT INTO rooms (id, room_number, price, type, status, city, branch_name) VALUES
(29101,'101',500000.00,'STANDARD','AVAILABLE','Hà Nội','Ba Đình Hotel'),
(29102,'102',500000.00,'STANDARD','OCCUPIED','Hà Nội','Ba Đình Hotel'),
(29103,'103',500000.00,'STANDARD','CLEANING','Hà Nội','Ba Đình Hotel'),
(29104,'104',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Ba Đình Hotel'),
(29105,'105',500000.00,'STANDARD','AVAILABLE','Hà Nội','Ba Đình Hotel'),
(29106,'106',500000.00,'STANDARD','OCCUPIED','Hà Nội','Ba Đình Hotel'),
(29107,'107',500000.00,'STANDARD','CLEANING','Hà Nội','Ba Đình Hotel'),
(29108,'108',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Ba Đình Hotel'),
(29109,'109',500000.00,'STANDARD','AVAILABLE','Hà Nội','Ba Đình Hotel'),
(29110,'110',500000.00,'STANDARD','OCCUPIED','Hà Nội','Ba Đình Hotel'),
(29201,'201',500000.00,'STANDARD','CLEANING','Hà Nội','Ba Đình Hotel'),
(29202,'202',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Ba Đình Hotel'),
(29203,'203',500000.00,'STANDARD','AVAILABLE','Hà Nội','Ba Đình Hotel'),
(29204,'204',500000.00,'STANDARD','OCCUPIED','Hà Nội','Ba Đình Hotel'),
(29205,'205',500000.00,'STANDARD','CLEANING','Hà Nội','Ba Đình Hotel'),
(29206,'206',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Ba Đình Hotel'),
(29207,'207',500000.00,'STANDARD','AVAILABLE','Hà Nội','Ba Đình Hotel'),
(29208,'208',500000.00,'STANDARD','OCCUPIED','Hà Nội','Ba Đình Hotel'),
(29209,'209',500000.00,'STANDARD','CLEANING','Hà Nội','Ba Đình Hotel'),
(29210,'210',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Ba Đình Hotel'),
(29301,'301',800000.00,'DELUXE','AVAILABLE','Hà Nội','Ba Đình Hotel'),
(29302,'302',800000.00,'DELUXE','OCCUPIED','Hà Nội','Ba Đình Hotel'),
(29303,'303',800000.00,'DELUXE','CLEANING','Hà Nội','Ba Đình Hotel'),
(29304,'304',800000.00,'DELUXE','MAINTENANCE','Hà Nội','Ba Đình Hotel'),
(29305,'305',800000.00,'DELUXE','AVAILABLE','Hà Nội','Ba Đình Hotel'),
(29306,'306',800000.00,'DELUXE','OCCUPIED','Hà Nội','Ba Đình Hotel'),
(29307,'307',800000.00,'DELUXE','CLEANING','Hà Nội','Ba Đình Hotel'),
(29308,'308',800000.00,'DELUXE','MAINTENANCE','Hà Nội','Ba Đình Hotel'),
(29309,'309',800000.00,'DELUXE','AVAILABLE','Hà Nội','Ba Đình Hotel'),
(29310,'310',800000.00,'DELUXE','OCCUPIED','Hà Nội','Ba Đình Hotel'),
(29401,'401',1200000.00,'SUITE','CLEANING','Hà Nội','Ba Đình Hotel'),
(29402,'402',1200000.00,'SUITE','MAINTENANCE','Hà Nội','Ba Đình Hotel'),
(29403,'403',1200000.00,'SUITE','AVAILABLE','Hà Nội','Ba Đình Hotel'),
(29404,'404',1200000.00,'SUITE','OCCUPIED','Hà Nội','Ba Đình Hotel'),
(29405,'405',1200000.00,'SUITE','CLEANING','Hà Nội','Ba Đình Hotel'),
(29406,'406',1200000.00,'SUITE','MAINTENANCE','Hà Nội','Ba Đình Hotel'),
(29407,'407',1200000.00,'SUITE','AVAILABLE','Hà Nội','Ba Đình Hotel'),
(29408,'408',1200000.00,'SUITE','OCCUPIED','Hà Nội','Ba Đình Hotel'),
(29409,'409',1200000.00,'SUITE','CLEANING','Hà Nội','Ba Đình Hotel'),
(29410,'410',1200000.00,'SUITE','MAINTENANCE','Hà Nội','Ba Đình Hotel'),
(29501,'501',1500000.00,'SUITE','AVAILABLE','Hà Nội','Ba Đình Hotel'),
(29502,'502',1500000.00,'SUITE','OCCUPIED','Hà Nội','Ba Đình Hotel'),
(29503,'503',1500000.00,'SUITE','CLEANING','Hà Nội','Ba Đình Hotel'),
(29504,'504',1500000.00,'SUITE','MAINTENANCE','Hà Nội','Ba Đình Hotel'),
(29505,'505',1500000.00,'SUITE','AVAILABLE','Hà Nội','Ba Đình Hotel'),
(29506,'506',1500000.00,'SUITE','OCCUPIED','Hà Nội','Ba Đình Hotel'),
(29507,'507',1500000.00,'SUITE','CLEANING','Hà Nội','Ba Đình Hotel'),
(29508,'508',1500000.00,'SUITE','MAINTENANCE','Hà Nội','Ba Đình Hotel'),
(29509,'509',1500000.00,'SUITE','AVAILABLE','Hà Nội','Ba Đình Hotel'),
(29510,'510',1500000.00,'SUITE','OCCUPIED','Hà Nội','Ba Đình Hotel'),
(29601,'101',500000.00,'STANDARD','AVAILABLE','Hà Nội','Cầu Giấy Hotel'),
(29602,'102',500000.00,'STANDARD','OCCUPIED','Hà Nội','Cầu Giấy Hotel'),
(29603,'103',500000.00,'STANDARD','CLEANING','Hà Nội','Cầu Giấy Hotel'),
(29604,'104',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Cầu Giấy Hotel'),
(29605,'105',500000.00,'STANDARD','AVAILABLE','Hà Nội','Cầu Giấy Hotel'),
(29606,'106',500000.00,'STANDARD','OCCUPIED','Hà Nội','Cầu Giấy Hotel'),
(29607,'107',500000.00,'STANDARD','CLEANING','Hà Nội','Cầu Giấy Hotel'),
(29608,'108',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Cầu Giấy Hotel'),
(29609,'109',500000.00,'STANDARD','AVAILABLE','Hà Nội','Cầu Giấy Hotel'),
(29610,'110',500000.00,'STANDARD','OCCUPIED','Hà Nội','Cầu Giấy Hotel'),
(29701,'201',500000.00,'STANDARD','CLEANING','Hà Nội','Cầu Giấy Hotel'),
(29702,'202',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Cầu Giấy Hotel'),
(29703,'203',500000.00,'STANDARD','AVAILABLE','Hà Nội','Cầu Giấy Hotel'),
(29704,'204',500000.00,'STANDARD','OCCUPIED','Hà Nội','Cầu Giấy Hotel'),
(29705,'205',500000.00,'STANDARD','CLEANING','Hà Nội','Cầu Giấy Hotel'),
(29706,'206',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Cầu Giấy Hotel'),
(29707,'207',500000.00,'STANDARD','AVAILABLE','Hà Nội','Cầu Giấy Hotel'),
(29708,'208',500000.00,'STANDARD','OCCUPIED','Hà Nội','Cầu Giấy Hotel'),
(29709,'209',500000.00,'STANDARD','CLEANING','Hà Nội','Cầu Giấy Hotel'),
(29710,'210',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Cầu Giấy Hotel'),
(29801,'301',800000.00,'DELUXE','AVAILABLE','Hà Nội','Cầu Giấy Hotel'),
(29802,'302',800000.00,'DELUXE','OCCUPIED','Hà Nội','Cầu Giấy Hotel'),
(29803,'303',800000.00,'DELUXE','CLEANING','Hà Nội','Cầu Giấy Hotel'),
(29804,'304',800000.00,'DELUXE','MAINTENANCE','Hà Nội','Cầu Giấy Hotel'),
(29805,'305',800000.00,'DELUXE','AVAILABLE','Hà Nội','Cầu Giấy Hotel'),
(29806,'306',800000.00,'DELUXE','OCCUPIED','Hà Nội','Cầu Giấy Hotel'),
(29807,'307',800000.00,'DELUXE','CLEANING','Hà Nội','Cầu Giấy Hotel'),
(29808,'308',800000.00,'DELUXE','MAINTENANCE','Hà Nội','Cầu Giấy Hotel'),
(29809,'309',800000.00,'DELUXE','AVAILABLE','Hà Nội','Cầu Giấy Hotel'),
(29810,'310',800000.00,'DELUXE','OCCUPIED','Hà Nội','Cầu Giấy Hotel'),
(29901,'401',1200000.00,'SUITE','CLEANING','Hà Nội','Cầu Giấy Hotel'),
(29902,'402',1200000.00,'SUITE','MAINTENANCE','Hà Nội','Cầu Giấy Hotel'),
(29903,'403',1200000.00,'SUITE','AVAILABLE','Hà Nội','Cầu Giấy Hotel'),
(29904,'404',1200000.00,'SUITE','OCCUPIED','Hà Nội','Cầu Giấy Hotel'),
(29905,'405',1200000.00,'SUITE','CLEANING','Hà Nội','Cầu Giấy Hotel'),
(29906,'406',1200000.00,'SUITE','MAINTENANCE','Hà Nội','Cầu Giấy Hotel'),
(29907,'407',1200000.00,'SUITE','AVAILABLE','Hà Nội','Cầu Giấy Hotel'),
(29908,'408',1200000.00,'SUITE','OCCUPIED','Hà Nội','Cầu Giấy Hotel'),
(29909,'409',1200000.00,'SUITE','CLEANING','Hà Nội','Cầu Giấy Hotel'),
(29910,'410',1200000.00,'SUITE','MAINTENANCE','Hà Nội','Cầu Giấy Hotel'),
(291001,'501',1500000.00,'SUITE','AVAILABLE','Hà Nội','Cầu Giấy Hotel'),
(291002,'502',1500000.00,'SUITE','OCCUPIED','Hà Nội','Cầu Giấy Hotel'),
(291003,'503',1500000.00,'SUITE','CLEANING','Hà Nội','Cầu Giấy Hotel'),
(291004,'504',1500000.00,'SUITE','MAINTENANCE','Hà Nội','Cầu Giấy Hotel'),
(291005,'505',1500000.00,'SUITE','AVAILABLE','Hà Nội','Cầu Giấy Hotel'),
(291006,'506',1500000.00,'SUITE','OCCUPIED','Hà Nội','Cầu Giấy Hotel'),
(291007,'507',1500000.00,'SUITE','CLEANING','Hà Nội','Cầu Giấy Hotel'),
(291008,'508',1500000.00,'SUITE','MAINTENANCE','Hà Nội','Cầu Giấy Hotel'),
(291009,'509',1500000.00,'SUITE','AVAILABLE','Hà Nội','Cầu Giấy Hotel'),
(291010,'510',1500000.00,'SUITE','OCCUPIED','Hà Nội','Cầu Giấy Hotel'),
(291101,'101',500000.00,'STANDARD','AVAILABLE','Hà Nội','Đống Đa Hotel'),
(291102,'102',500000.00,'STANDARD','OCCUPIED','Hà Nội','Đống Đa Hotel'),
(291103,'103',500000.00,'STANDARD','CLEANING','Hà Nội','Đống Đa Hotel'),
(291104,'104',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Đống Đa Hotel'),
(291105,'105',500000.00,'STANDARD','AVAILABLE','Hà Nội','Đống Đa Hotel'),
(291106,'106',500000.00,'STANDARD','OCCUPIED','Hà Nội','Đống Đa Hotel'),
(291107,'107',500000.00,'STANDARD','CLEANING','Hà Nội','Đống Đa Hotel'),
(291108,'108',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Đống Đa Hotel'),
(291109,'109',500000.00,'STANDARD','AVAILABLE','Hà Nội','Đống Đa Hotel'),
(291110,'110',500000.00,'STANDARD','OCCUPIED','Hà Nội','Đống Đa Hotel'),
(291201,'201',500000.00,'STANDARD','CLEANING','Hà Nội','Đống Đa Hotel'),
(291202,'202',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Đống Đa Hotel'),
(291203,'203',500000.00,'STANDARD','AVAILABLE','Hà Nội','Đống Đa Hotel'),
(291204,'204',500000.00,'STANDARD','OCCUPIED','Hà Nội','Đống Đa Hotel'),
(291205,'205',500000.00,'STANDARD','CLEANING','Hà Nội','Đống Đa Hotel'),
(291206,'206',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Đống Đa Hotel'),
(291207,'207',500000.00,'STANDARD','AVAILABLE','Hà Nội','Đống Đa Hotel'),
(291208,'208',500000.00,'STANDARD','OCCUPIED','Hà Nội','Đống Đa Hotel'),
(291209,'209',500000.00,'STANDARD','CLEANING','Hà Nội','Đống Đa Hotel'),
(291210,'210',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Đống Đa Hotel'),
(291301,'301',800000.00,'DELUXE','AVAILABLE','Hà Nội','Đống Đa Hotel'),
(291302,'302',800000.00,'DELUXE','OCCUPIED','Hà Nội','Đống Đa Hotel'),
(291303,'303',800000.00,'DELUXE','CLEANING','Hà Nội','Đống Đa Hotel'),
(291304,'304',800000.00,'DELUXE','MAINTENANCE','Hà Nội','Đống Đa Hotel'),
(291305,'305',800000.00,'DELUXE','AVAILABLE','Hà Nội','Đống Đa Hotel'),
(291306,'306',800000.00,'DELUXE','OCCUPIED','Hà Nội','Đống Đa Hotel'),
(291307,'307',800000.00,'DELUXE','CLEANING','Hà Nội','Đống Đa Hotel'),
(291308,'308',800000.00,'DELUXE','MAINTENANCE','Hà Nội','Đống Đa Hotel'),
(291309,'309',800000.00,'DELUXE','AVAILABLE','Hà Nội','Đống Đa Hotel'),
(291310,'310',800000.00,'DELUXE','OCCUPIED','Hà Nội','Đống Đa Hotel'),
(291401,'401',1200000.00,'SUITE','CLEANING','Hà Nội','Đống Đa Hotel'),
(291402,'402',1200000.00,'SUITE','MAINTENANCE','Hà Nội','Đống Đa Hotel'),
(291403,'403',1200000.00,'SUITE','AVAILABLE','Hà Nội','Đống Đa Hotel'),
(291404,'404',1200000.00,'SUITE','OCCUPIED','Hà Nội','Đống Đa Hotel'),
(291405,'405',1200000.00,'SUITE','CLEANING','Hà Nội','Đống Đa Hotel'),
(291406,'406',1200000.00,'SUITE','MAINTENANCE','Hà Nội','Đống Đa Hotel'),
(291407,'407',1200000.00,'SUITE','AVAILABLE','Hà Nội','Đống Đa Hotel'),
(291408,'408',1200000.00,'SUITE','OCCUPIED','Hà Nội','Đống Đa Hotel'),
(291409,'409',1200000.00,'SUITE','CLEANING','Hà Nội','Đống Đa Hotel'),
(291410,'410',1200000.00,'SUITE','MAINTENANCE','Hà Nội','Đống Đa Hotel'),
(291501,'501',1500000.00,'SUITE','AVAILABLE','Hà Nội','Đống Đa Hotel'),
(291502,'502',1500000.00,'SUITE','OCCUPIED','Hà Nội','Đống Đa Hotel'),
(291503,'503',1500000.00,'SUITE','CLEANING','Hà Nội','Đống Đa Hotel'),
(291504,'504',1500000.00,'SUITE','MAINTENANCE','Hà Nội','Đống Đa Hotel'),
(291505,'505',1500000.00,'SUITE','AVAILABLE','Hà Nội','Đống Đa Hotel'),
(291506,'506',1500000.00,'SUITE','OCCUPIED','Hà Nội','Đống Đa Hotel'),
(291507,'507',1500000.00,'SUITE','CLEANING','Hà Nội','Đống Đa Hotel'),
(291508,'508',1500000.00,'SUITE','MAINTENANCE','Hà Nội','Đống Đa Hotel'),
(291509,'509',1500000.00,'SUITE','AVAILABLE','Hà Nội','Đống Đa Hotel'),
(291510,'510',1500000.00,'SUITE','OCCUPIED','Hà Nội','Đống Đa Hotel'),
(291601,'101',500000.00,'STANDARD','AVAILABLE','Hà Nội','Hai Bà Trưng Hotel'),
(291602,'102',500000.00,'STANDARD','OCCUPIED','Hà Nội','Hai Bà Trưng Hotel'),
(291603,'103',500000.00,'STANDARD','CLEANING','Hà Nội','Hai Bà Trưng Hotel'),
(291604,'104',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Hai Bà Trưng Hotel'),
(291605,'105',500000.00,'STANDARD','AVAILABLE','Hà Nội','Hai Bà Trưng Hotel'),
(291606,'106',500000.00,'STANDARD','OCCUPIED','Hà Nội','Hai Bà Trưng Hotel'),
(291607,'107',500000.00,'STANDARD','CLEANING','Hà Nội','Hai Bà Trưng Hotel'),
(291608,'108',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Hai Bà Trưng Hotel'),
(291609,'109',500000.00,'STANDARD','AVAILABLE','Hà Nội','Hai Bà Trưng Hotel'),
(291610,'110',500000.00,'STANDARD','OCCUPIED','Hà Nội','Hai Bà Trưng Hotel'),
(291701,'201',500000.00,'STANDARD','CLEANING','Hà Nội','Hai Bà Trưng Hotel'),
(291702,'202',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Hai Bà Trưng Hotel'),
(291703,'203',500000.00,'STANDARD','AVAILABLE','Hà Nội','Hai Bà Trưng Hotel'),
(291704,'204',500000.00,'STANDARD','OCCUPIED','Hà Nội','Hai Bà Trưng Hotel'),
(291705,'205',500000.00,'STANDARD','CLEANING','Hà Nội','Hai Bà Trưng Hotel'),
(291706,'206',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Hai Bà Trưng Hotel'),
(291707,'207',500000.00,'STANDARD','AVAILABLE','Hà Nội','Hai Bà Trưng Hotel'),
(291708,'208',500000.00,'STANDARD','OCCUPIED','Hà Nội','Hai Bà Trưng Hotel'),
(291709,'209',500000.00,'STANDARD','CLEANING','Hà Nội','Hai Bà Trưng Hotel'),
(291710,'210',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Hai Bà Trưng Hotel'),
(291801,'301',800000.00,'DELUXE','AVAILABLE','Hà Nội','Hai Bà Trưng Hotel'),
(291802,'302',800000.00,'DELUXE','OCCUPIED','Hà Nội','Hai Bà Trưng Hotel'),
(291803,'303',800000.00,'DELUXE','CLEANING','Hà Nội','Hai Bà Trưng Hotel'),
(291804,'304',800000.00,'DELUXE','MAINTENANCE','Hà Nội','Hai Bà Trưng Hotel'),
(291805,'305',800000.00,'DELUXE','AVAILABLE','Hà Nội','Hai Bà Trưng Hotel'),
(291806,'306',800000.00,'DELUXE','OCCUPIED','Hà Nội','Hai Bà Trưng Hotel'),
(291807,'307',800000.00,'DELUXE','CLEANING','Hà Nội','Hai Bà Trưng Hotel'),
(291808,'308',800000.00,'DELUXE','MAINTENANCE','Hà Nội','Hai Bà Trưng Hotel'),
(291809,'309',800000.00,'DELUXE','AVAILABLE','Hà Nội','Hai Bà Trưng Hotel'),
(291810,'310',800000.00,'DELUXE','OCCUPIED','Hà Nội','Hai Bà Trưng Hotel'),
(291901,'401',1200000.00,'SUITE','CLEANING','Hà Nội','Hai Bà Trưng Hotel'),
(291902,'402',1200000.00,'SUITE','MAINTENANCE','Hà Nội','Hai Bà Trưng Hotel'),
(291903,'403',1200000.00,'SUITE','AVAILABLE','Hà Nội','Hai Bà Trưng Hotel'),
(291904,'404',1200000.00,'SUITE','OCCUPIED','Hà Nội','Hai Bà Trưng Hotel'),
(291905,'405',1200000.00,'SUITE','CLEANING','Hà Nội','Hai Bà Trưng Hotel'),
(291906,'406',1200000.00,'SUITE','MAINTENANCE','Hà Nội','Hai Bà Trưng Hotel'),
(291907,'407',1200000.00,'SUITE','AVAILABLE','Hà Nội','Hai Bà Trưng Hotel'),
(291908,'408',1200000.00,'SUITE','OCCUPIED','Hà Nội','Hai Bà Trưng Hotel'),
(291909,'409',1200000.00,'SUITE','CLEANING','Hà Nội','Hai Bà Trưng Hotel'),
(291910,'410',1200000.00,'SUITE','MAINTENANCE','Hà Nội','Hai Bà Trưng Hotel'),
(292001,'501',1500000.00,'SUITE','AVAILABLE','Hà Nội','Hai Bà Trưng Hotel'),
(292002,'502',1500000.00,'SUITE','OCCUPIED','Hà Nội','Hai Bà Trưng Hotel'),
(292003,'503',1500000.00,'SUITE','CLEANING','Hà Nội','Hai Bà Trưng Hotel'),
(292004,'504',1500000.00,'SUITE','MAINTENANCE','Hà Nội','Hai Bà Trưng Hotel'),
(292005,'505',1500000.00,'SUITE','AVAILABLE','Hà Nội','Hai Bà Trưng Hotel'),
(292006,'506',1500000.00,'SUITE','OCCUPIED','Hà Nội','Hai Bà Trưng Hotel'),
(292007,'507',1500000.00,'SUITE','CLEANING','Hà Nội','Hai Bà Trưng Hotel'),
(292008,'508',1500000.00,'SUITE','MAINTENANCE','Hà Nội','Hai Bà Trưng Hotel'),
(292009,'509',1500000.00,'SUITE','AVAILABLE','Hà Nội','Hai Bà Trưng Hotel'),
(292010,'510',1500000.00,'SUITE','OCCUPIED','Hà Nội','Hai Bà Trưng Hotel'),
(292101,'101',500000.00,'STANDARD','AVAILABLE','Hà Nội','Hoàn Kiếm Hotel'),
(292102,'102',500000.00,'STANDARD','OCCUPIED','Hà Nội','Hoàn Kiếm Hotel'),
(292103,'103',500000.00,'STANDARD','CLEANING','Hà Nội','Hoàn Kiếm Hotel'),
(292104,'104',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Hoàn Kiếm Hotel'),
(292105,'105',500000.00,'STANDARD','AVAILABLE','Hà Nội','Hoàn Kiếm Hotel'),
(292106,'106',500000.00,'STANDARD','OCCUPIED','Hà Nội','Hoàn Kiếm Hotel'),
(292107,'107',500000.00,'STANDARD','CLEANING','Hà Nội','Hoàn Kiếm Hotel'),
(292108,'108',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Hoàn Kiếm Hotel'),
(292109,'109',500000.00,'STANDARD','AVAILABLE','Hà Nội','Hoàn Kiếm Hotel'),
(292110,'110',500000.00,'STANDARD','OCCUPIED','Hà Nội','Hoàn Kiếm Hotel'),
(292201,'201',500000.00,'STANDARD','CLEANING','Hà Nội','Hoàn Kiếm Hotel'),
(292202,'202',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Hoàn Kiếm Hotel'),
(292203,'203',500000.00,'STANDARD','AVAILABLE','Hà Nội','Hoàn Kiếm Hotel'),
(292204,'204',500000.00,'STANDARD','OCCUPIED','Hà Nội','Hoàn Kiếm Hotel'),
(292205,'205',500000.00,'STANDARD','CLEANING','Hà Nội','Hoàn Kiếm Hotel'),
(292206,'206',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Hoàn Kiếm Hotel'),
(292207,'207',500000.00,'STANDARD','AVAILABLE','Hà Nội','Hoàn Kiếm Hotel'),
(292208,'208',500000.00,'STANDARD','OCCUPIED','Hà Nội','Hoàn Kiếm Hotel'),
(292209,'209',500000.00,'STANDARD','CLEANING','Hà Nội','Hoàn Kiếm Hotel'),
(292210,'210',500000.00,'STANDARD','MAINTENANCE','Hà Nội','Hoàn Kiếm Hotel'),
(292301,'301',800000.00,'DELUXE','AVAILABLE','Hà Nội','Hoàn Kiếm Hotel'),
(292302,'302',800000.00,'DELUXE','OCCUPIED','Hà Nội','Hoàn Kiếm Hotel'),
(292303,'303',800000.00,'DELUXE','CLEANING','Hà Nội','Hoàn Kiếm Hotel'),
(292304,'304',800000.00,'DELUXE','MAINTENANCE','Hà Nội','Hoàn Kiếm Hotel'),
(292305,'305',800000.00,'DELUXE','AVAILABLE','Hà Nội','Hoàn Kiếm Hotel'),
(292306,'306',800000.00,'DELUXE','OCCUPIED','Hà Nội','Hoàn Kiếm Hotel'),
(292307,'307',800000.00,'DELUXE','CLEANING','Hà Nội','Hoàn Kiếm Hotel'),
(292308,'308',800000.00,'DELUXE','MAINTENANCE','Hà Nội','Hoàn Kiếm Hotel'),
(292309,'309',800000.00,'DELUXE','AVAILABLE','Hà Nội','Hoàn Kiếm Hotel'),
(292310,'310',800000.00,'DELUXE','OCCUPIED','Hà Nội','Hoàn Kiếm Hotel'),
(292401,'401',1200000.00,'SUITE','CLEANING','Hà Nội','Hoàn Kiếm Hotel'),
(292402,'402',1200000.00,'SUITE','MAINTENANCE','Hà Nội','Hoàn Kiếm Hotel'),
(292403,'403',1200000.00,'SUITE','AVAILABLE','Hà Nội','Hoàn Kiếm Hotel'),
(292404,'404',1200000.00,'SUITE','OCCUPIED','Hà Nội','Hoàn Kiếm Hotel'),
(292405,'405',1200000.00,'SUITE','CLEANING','Hà Nội','Hoàn Kiếm Hotel'),
(292406,'406',1200000.00,'SUITE','MAINTENANCE','Hà Nội','Hoàn Kiếm Hotel'),
(292407,'407',1200000.00,'SUITE','AVAILABLE','Hà Nội','Hoàn Kiếm Hotel'),
(292408,'408',1200000.00,'SUITE','OCCUPIED','Hà Nội','Hoàn Kiếm Hotel'),
(292409,'409',1200000.00,'SUITE','CLEANING','Hà Nội','Hoàn Kiếm Hotel'),
(292410,'410',1200000.00,'SUITE','MAINTENANCE','Hà Nội','Hoàn Kiếm Hotel'),
(292501,'501',1500000.00,'SUITE','AVAILABLE','Hà Nội','Hoàn Kiếm Hotel'),
(292502,'502',1500000.00,'SUITE','OCCUPIED','Hà Nội','Hoàn Kiếm Hotel'),
(292503,'503',1500000.00,'SUITE','CLEANING','Hà Nội','Hoàn Kiếm Hotel'),
(292504,'504',1500000.00,'SUITE','MAINTENANCE','Hà Nội','Hoàn Kiếm Hotel'),
(292505,'505',1500000.00,'SUITE','AVAILABLE','Hà Nội','Hoàn Kiếm Hotel'),
(292506,'506',1500000.00,'SUITE','OCCUPIED','Hà Nội','Hoàn Kiếm Hotel'),
(292507,'507',1500000.00,'SUITE','CLEANING','Hà Nội','Hoàn Kiếm Hotel'),
(292508,'508',1500000.00,'SUITE','MAINTENANCE','Hà Nội','Hoàn Kiếm Hotel'),
(292509,'509',1500000.00,'SUITE','AVAILABLE','Hà Nội','Hoàn Kiếm Hotel'),
(292510,'510',1500000.00,'SUITE','OCCUPIED','Hà Nội','Hoàn Kiếm Hotel'),
(43101,'101',500000.00,'STANDARD','AVAILABLE','Đà Nẵng','Hải Châu Hotel'),
(43102,'102',500000.00,'STANDARD','OCCUPIED','Đà Nẵng','Hải Châu Hotel'),
(43103,'103',500000.00,'STANDARD','CLEANING','Đà Nẵng','Hải Châu Hotel'),
(43104,'104',500000.00,'STANDARD','MAINTENANCE','Đà Nẵng','Hải Châu Hotel'),
(43105,'105',500000.00,'STANDARD','AVAILABLE','Đà Nẵng','Hải Châu Hotel'),
(43106,'106',500000.00,'STANDARD','OCCUPIED','Đà Nẵng','Hải Châu Hotel'),
(43107,'107',500000.00,'STANDARD','CLEANING','Đà Nẵng','Hải Châu Hotel'),
(43108,'108',500000.00,'STANDARD','MAINTENANCE','Đà Nẵng','Hải Châu Hotel'),
(43109,'109',500000.00,'STANDARD','AVAILABLE','Đà Nẵng','Hải Châu Hotel'),
(43110,'110',500000.00,'STANDARD','OCCUPIED','Đà Nẵng','Hải Châu Hotel'),
(43201,'201',500000.00,'STANDARD','CLEANING','Đà Nẵng','Hải Châu Hotel'),
(43202,'202',500000.00,'STANDARD','MAINTENANCE','Đà Nẵng','Hải Châu Hotel'),
(43203,'203',500000.00,'STANDARD','AVAILABLE','Đà Nẵng','Hải Châu Hotel'),
(43204,'204',500000.00,'STANDARD','OCCUPIED','Đà Nẵng','Hải Châu Hotel'),
(43205,'205',500000.00,'STANDARD','CLEANING','Đà Nẵng','Hải Châu Hotel'),
(43206,'206',500000.00,'STANDARD','MAINTENANCE','Đà Nẵng','Hải Châu Hotel'),
(43207,'207',500000.00,'STANDARD','AVAILABLE','Đà Nẵng','Hải Châu Hotel'),
(43208,'208',500000.00,'STANDARD','OCCUPIED','Đà Nẵng','Hải Châu Hotel'),
(43209,'209',500000.00,'STANDARD','CLEANING','Đà Nẵng','Hải Châu Hotel'),
(43210,'210',500000.00,'STANDARD','MAINTENANCE','Đà Nẵng','Hải Châu Hotel'),
(43301,'301',800000.00,'DELUXE','AVAILABLE','Đà Nẵng','Hải Châu Hotel'),
(43302,'302',800000.00,'DELUXE','OCCUPIED','Đà Nẵng','Hải Châu Hotel'),
(43303,'303',800000.00,'DELUXE','CLEANING','Đà Nẵng','Hải Châu Hotel'),
(43304,'304',800000.00,'DELUXE','MAINTENANCE','Đà Nẵng','Hải Châu Hotel'),
(43305,'305',800000.00,'DELUXE','AVAILABLE','Đà Nẵng','Hải Châu Hotel'),
(43306,'306',800000.00,'DELUXE','OCCUPIED','Đà Nẵng','Hải Châu Hotel'),
(43307,'307',800000.00,'DELUXE','CLEANING','Đà Nẵng','Hải Châu Hotel'),
(43308,'308',800000.00,'DELUXE','MAINTENANCE','Đà Nẵng','Hải Châu Hotel'),
(43309,'309',800000.00,'DELUXE','AVAILABLE','Đà Nẵng','Hải Châu Hotel'),
(43310,'310',800000.00,'DELUXE','OCCUPIED','Đà Nẵng','Hải Châu Hotel'),
(43401,'401',1200000.00,'SUITE','CLEANING','Đà Nẵng','Hải Châu Hotel'),
(43402,'402',1200000.00,'SUITE','MAINTENANCE','Đà Nẵng','Hải Châu Hotel'),
(43403,'403',1200000.00,'SUITE','AVAILABLE','Đà Nẵng','Hải Châu Hotel'),
(43404,'404',1200000.00,'SUITE','OCCUPIED','Đà Nẵng','Hải Châu Hotel'),
(43405,'405',1200000.00,'SUITE','CLEANING','Đà Nẵng','Hải Châu Hotel'),
(43406,'406',1200000.00,'SUITE','MAINTENANCE','Đà Nẵng','Hải Châu Hotel'),
(43407,'407',1200000.00,'SUITE','AVAILABLE','Đà Nẵng','Hải Châu Hotel'),
(43408,'408',1200000.00,'SUITE','OCCUPIED','Đà Nẵng','Hải Châu Hotel'),
(43409,'409',1200000.00,'SUITE','CLEANING','Đà Nẵng','Hải Châu Hotel'),
(43410,'410',1200000.00,'SUITE','MAINTENANCE','Đà Nẵng','Hải Châu Hotel'),
(43501,'501',1500000.00,'SUITE','AVAILABLE','Đà Nẵng','Hải Châu Hotel'),
(43502,'502',1500000.00,'SUITE','OCCUPIED','Đà Nẵng','Hải Châu Hotel'),
(43503,'503',1500000.00,'SUITE','CLEANING','Đà Nẵng','Hải Châu Hotel'),
(43504,'504',1500000.00,'SUITE','MAINTENANCE','Đà Nẵng','Hải Châu Hotel'),
(43505,'505',1500000.00,'SUITE','AVAILABLE','Đà Nẵng','Hải Châu Hotel'),
(43506,'506',1500000.00,'SUITE','OCCUPIED','Đà Nẵng','Hải Châu Hotel'),
(43507,'507',1500000.00,'SUITE','CLEANING','Đà Nẵng','Hải Châu Hotel'),
(43508,'508',1500000.00,'SUITE','MAINTENANCE','Đà Nẵng','Hải Châu Hotel'),
(43509,'509',1500000.00,'SUITE','AVAILABLE','Đà Nẵng','Hải Châu Hotel'),
(43510,'510',1500000.00,'SUITE','OCCUPIED','Đà Nẵng','Hải Châu Hotel'),
(43601,'101',500000.00,'STANDARD','AVAILABLE','Đà Nẵng','Sơn Trà Hotel'),
(43602,'102',500000.00,'STANDARD','OCCUPIED','Đà Nẵng','Sơn Trà Hotel'),
(43603,'103',500000.00,'STANDARD','CLEANING','Đà Nẵng','Sơn Trà Hotel'),
(43604,'104',500000.00,'STANDARD','MAINTENANCE','Đà Nẵng','Sơn Trà Hotel'),
(43605,'105',500000.00,'STANDARD','AVAILABLE','Đà Nẵng','Sơn Trà Hotel'),
(43606,'106',500000.00,'STANDARD','OCCUPIED','Đà Nẵng','Sơn Trà Hotel'),
(43607,'107',500000.00,'STANDARD','CLEANING','Đà Nẵng','Sơn Trà Hotel'),
(43608,'108',500000.00,'STANDARD','MAINTENANCE','Đà Nẵng','Sơn Trà Hotel'),
(43609,'109',500000.00,'STANDARD','AVAILABLE','Đà Nẵng','Sơn Trà Hotel'),
(43610,'110',500000.00,'STANDARD','OCCUPIED','Đà Nẵng','Sơn Trà Hotel'),
(43701,'201',500000.00,'STANDARD','CLEANING','Đà Nẵng','Sơn Trà Hotel'),
(43702,'202',500000.00,'STANDARD','MAINTENANCE','Đà Nẵng','Sơn Trà Hotel'),
(43703,'203',500000.00,'STANDARD','AVAILABLE','Đà Nẵng','Sơn Trà Hotel'),
(43704,'204',500000.00,'STANDARD','OCCUPIED','Đà Nẵng','Sơn Trà Hotel'),
(43705,'205',500000.00,'STANDARD','CLEANING','Đà Nẵng','Sơn Trà Hotel'),
(43706,'206',500000.00,'STANDARD','MAINTENANCE','Đà Nẵng','Sơn Trà Hotel'),
(43707,'207',500000.00,'STANDARD','AVAILABLE','Đà Nẵng','Sơn Trà Hotel'),
(43708,'208',500000.00,'STANDARD','OCCUPIED','Đà Nẵng','Sơn Trà Hotel'),
(43709,'209',500000.00,'STANDARD','CLEANING','Đà Nẵng','Sơn Trà Hotel'),
(43710,'210',500000.00,'STANDARD','MAINTENANCE','Đà Nẵng','Sơn Trà Hotel'),
(43801,'301',800000.00,'DELUXE','AVAILABLE','Đà Nẵng','Sơn Trà Hotel'),
(43802,'302',800000.00,'DELUXE','OCCUPIED','Đà Nẵng','Sơn Trà Hotel'),
(43803,'303',800000.00,'DELUXE','CLEANING','Đà Nẵng','Sơn Trà Hotel'),
(43804,'304',800000.00,'DELUXE','MAINTENANCE','Đà Nẵng','Sơn Trà Hotel'),
(43805,'305',800000.00,'DELUXE','AVAILABLE','Đà Nẵng','Sơn Trà Hotel'),
(43806,'306',800000.00,'DELUXE','OCCUPIED','Đà Nẵng','Sơn Trà Hotel'),
(43807,'307',800000.00,'DELUXE','CLEANING','Đà Nẵng','Sơn Trà Hotel'),
(43808,'308',800000.00,'DELUXE','MAINTENANCE','Đà Nẵng','Sơn Trà Hotel'),
(43809,'309',800000.00,'DELUXE','AVAILABLE','Đà Nẵng','Sơn Trà Hotel'),
(43810,'310',800000.00,'DELUXE','OCCUPIED','Đà Nẵng','Sơn Trà Hotel'),
(43901,'401',1200000.00,'SUITE','CLEANING','Đà Nẵng','Sơn Trà Hotel'),
(43902,'402',1200000.00,'SUITE','MAINTENANCE','Đà Nẵng','Sơn Trà Hotel'),
(43903,'403',1200000.00,'SUITE','AVAILABLE','Đà Nẵng','Sơn Trà Hotel'),
(43904,'404',1200000.00,'SUITE','OCCUPIED','Đà Nẵng','Sơn Trà Hotel'),
(43905,'405',1200000.00,'SUITE','CLEANING','Đà Nẵng','Sơn Trà Hotel'),
(43906,'406',1200000.00,'SUITE','MAINTENANCE','Đà Nẵng','Sơn Trà Hotel'),
(43907,'407',1200000.00,'SUITE','AVAILABLE','Đà Nẵng','Sơn Trà Hotel'),
(43908,'408',1200000.00,'SUITE','OCCUPIED','Đà Nẵng','Sơn Trà Hotel'),
(43909,'409',1200000.00,'SUITE','CLEANING','Đà Nẵng','Sơn Trà Hotel'),
(43910,'410',1200000.00,'SUITE','MAINTENANCE','Đà Nẵng','Sơn Trà Hotel'),
(431001,'501',1500000.00,'SUITE','AVAILABLE','Đà Nẵng','Sơn Trà Hotel'),
(431002,'502',1500000.00,'SUITE','OCCUPIED','Đà Nẵng','Sơn Trà Hotel'),
(431003,'503',1500000.00,'SUITE','CLEANING','Đà Nẵng','Sơn Trà Hotel'),
(431004,'504',1500000.00,'SUITE','MAINTENANCE','Đà Nẵng','Sơn Trà Hotel'),
(431005,'505',1500000.00,'SUITE','AVAILABLE','Đà Nẵng','Sơn Trà Hotel'),
(431006,'506',1500000.00,'SUITE','OCCUPIED','Đà Nẵng','Sơn Trà Hotel'),
(431007,'507',1500000.00,'SUITE','CLEANING','Đà Nẵng','Sơn Trà Hotel'),
(431008,'508',1500000.00,'SUITE','MAINTENANCE','Đà Nẵng','Sơn Trà Hotel'),
(431009,'509',1500000.00,'SUITE','AVAILABLE','Đà Nẵng','Sơn Trà Hotel'),
(431010,'510',1500000.00,'SUITE','OCCUPIED','Đà Nẵng','Sơn Trà Hotel'),
(431101,'101',500000.00,'STANDARD','AVAILABLE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431102,'102',500000.00,'STANDARD','OCCUPIED','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431103,'103',500000.00,'STANDARD','CLEANING','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431104,'104',500000.00,'STANDARD','MAINTENANCE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431105,'105',500000.00,'STANDARD','AVAILABLE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431106,'106',500000.00,'STANDARD','OCCUPIED','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431107,'107',500000.00,'STANDARD','CLEANING','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431108,'108',500000.00,'STANDARD','MAINTENANCE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431109,'109',500000.00,'STANDARD','AVAILABLE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431110,'110',500000.00,'STANDARD','OCCUPIED','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431201,'201',500000.00,'STANDARD','CLEANING','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431202,'202',500000.00,'STANDARD','MAINTENANCE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431203,'203',500000.00,'STANDARD','AVAILABLE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431204,'204',500000.00,'STANDARD','OCCUPIED','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431205,'205',500000.00,'STANDARD','CLEANING','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431206,'206',500000.00,'STANDARD','MAINTENANCE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431207,'207',500000.00,'STANDARD','AVAILABLE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431208,'208',500000.00,'STANDARD','OCCUPIED','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431209,'209',500000.00,'STANDARD','CLEANING','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431210,'210',500000.00,'STANDARD','MAINTENANCE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431301,'301',800000.00,'DELUXE','AVAILABLE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431302,'302',800000.00,'DELUXE','OCCUPIED','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431303,'303',800000.00,'DELUXE','CLEANING','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431304,'304',800000.00,'DELUXE','MAINTENANCE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431305,'305',800000.00,'DELUXE','AVAILABLE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431306,'306',800000.00,'DELUXE','OCCUPIED','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431307,'307',800000.00,'DELUXE','CLEANING','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431308,'308',800000.00,'DELUXE','MAINTENANCE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431309,'309',800000.00,'DELUXE','AVAILABLE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431310,'310',800000.00,'DELUXE','OCCUPIED','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431401,'401',1200000.00,'SUITE','CLEANING','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431402,'402',1200000.00,'SUITE','MAINTENANCE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431403,'403',1200000.00,'SUITE','AVAILABLE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431404,'404',1200000.00,'SUITE','OCCUPIED','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431405,'405',1200000.00,'SUITE','CLEANING','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431406,'406',1200000.00,'SUITE','MAINTENANCE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431407,'407',1200000.00,'SUITE','AVAILABLE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431408,'408',1200000.00,'SUITE','OCCUPIED','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431409,'409',1200000.00,'SUITE','CLEANING','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431410,'410',1200000.00,'SUITE','MAINTENANCE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431501,'501',1500000.00,'SUITE','AVAILABLE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431502,'502',1500000.00,'SUITE','OCCUPIED','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431503,'503',1500000.00,'SUITE','CLEANING','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431504,'504',1500000.00,'SUITE','MAINTENANCE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431505,'505',1500000.00,'SUITE','AVAILABLE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431506,'506',1500000.00,'SUITE','OCCUPIED','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431507,'507',1500000.00,'SUITE','CLEANING','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431508,'508',1500000.00,'SUITE','MAINTENANCE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431509,'509',1500000.00,'SUITE','AVAILABLE','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431510,'510',1500000.00,'SUITE','OCCUPIED','Đà Nẵng','Ngũ Hành Sơn Hotel'),
(431601,'101',500000.00,'STANDARD','AVAILABLE','Đà Nẵng','Thanh Khê Hotel'),
(431602,'102',500000.00,'STANDARD','OCCUPIED','Đà Nẵng','Thanh Khê Hotel'),
(431603,'103',500000.00,'STANDARD','CLEANING','Đà Nẵng','Thanh Khê Hotel'),
(431604,'104',500000.00,'STANDARD','MAINTENANCE','Đà Nẵng','Thanh Khê Hotel'),
(431605,'105',500000.00,'STANDARD','AVAILABLE','Đà Nẵng','Thanh Khê Hotel'),
(431606,'106',500000.00,'STANDARD','OCCUPIED','Đà Nẵng','Thanh Khê Hotel'),
(431607,'107',500000.00,'STANDARD','CLEANING','Đà Nẵng','Thanh Khê Hotel'),
(431608,'108',500000.00,'STANDARD','MAINTENANCE','Đà Nẵng','Thanh Khê Hotel'),
(431609,'109',500000.00,'STANDARD','AVAILABLE','Đà Nẵng','Thanh Khê Hotel'),
(431610,'110',500000.00,'STANDARD','OCCUPIED','Đà Nẵng','Thanh Khê Hotel'),
(431701,'201',500000.00,'STANDARD','CLEANING','Đà Nẵng','Thanh Khê Hotel'),
(431702,'202',500000.00,'STANDARD','MAINTENANCE','Đà Nẵng','Thanh Khê Hotel'),
(431703,'203',500000.00,'STANDARD','AVAILABLE','Đà Nẵng','Thanh Khê Hotel'),
(431704,'204',500000.00,'STANDARD','OCCUPIED','Đà Nẵng','Thanh Khê Hotel'),
(431705,'205',500000.00,'STANDARD','CLEANING','Đà Nẵng','Thanh Khê Hotel'),
(431706,'206',500000.00,'STANDARD','MAINTENANCE','Đà Nẵng','Thanh Khê Hotel'),
(431707,'207',500000.00,'STANDARD','AVAILABLE','Đà Nẵng','Thanh Khê Hotel'),
(431708,'208',500000.00,'STANDARD','OCCUPIED','Đà Nẵng','Thanh Khê Hotel'),
(431709,'209',500000.00,'STANDARD','CLEANING','Đà Nẵng','Thanh Khê Hotel'),
(431710,'210',500000.00,'STANDARD','MAINTENANCE','Đà Nẵng','Thanh Khê Hotel'),
(431801,'301',800000.00,'DELUXE','AVAILABLE','Đà Nẵng','Thanh Khê Hotel'),
(431802,'302',800000.00,'DELUXE','OCCUPIED','Đà Nẵng','Thanh Khê Hotel'),
(431803,'303',800000.00,'DELUXE','CLEANING','Đà Nẵng','Thanh Khê Hotel'),
(431804,'304',800000.00,'DELUXE','MAINTENANCE','Đà Nẵng','Thanh Khê Hotel'),
(431805,'305',800000.00,'DELUXE','AVAILABLE','Đà Nẵng','Thanh Khê Hotel'),
(431806,'306',800000.00,'DELUXE','OCCUPIED','Đà Nẵng','Thanh Khê Hotel'),
(431807,'307',800000.00,'DELUXE','CLEANING','Đà Nẵng','Thanh Khê Hotel'),
(431808,'308',800000.00,'DELUXE','MAINTENANCE','Đà Nẵng','Thanh Khê Hotel'),
(431809,'309',800000.00,'DELUXE','AVAILABLE','Đà Nẵng','Thanh Khê Hotel'),
(431810,'310',800000.00,'DELUXE','OCCUPIED','Đà Nẵng','Thanh Khê Hotel'),
(431901,'401',1200000.00,'SUITE','CLEANING','Đà Nẵng','Thanh Khê Hotel'),
(431902,'402',1200000.00,'SUITE','MAINTENANCE','Đà Nẵng','Thanh Khê Hotel'),
(431903,'403',1200000.00,'SUITE','AVAILABLE','Đà Nẵng','Thanh Khê Hotel'),
(431904,'404',1200000.00,'SUITE','OCCUPIED','Đà Nẵng','Thanh Khê Hotel'),
(431905,'405',1200000.00,'SUITE','CLEANING','Đà Nẵng','Thanh Khê Hotel'),
(431906,'406',1200000.00,'SUITE','MAINTENANCE','Đà Nẵng','Thanh Khê Hotel'),
(431907,'407',1200000.00,'SUITE','AVAILABLE','Đà Nẵng','Thanh Khê Hotel'),
(431908,'408',1200000.00,'SUITE','OCCUPIED','Đà Nẵng','Thanh Khê Hotel'),
(431909,'409',1200000.00,'SUITE','CLEANING','Đà Nẵng','Thanh Khê Hotel'),
(431910,'410',1200000.00,'SUITE','MAINTENANCE','Đà Nẵng','Thanh Khê Hotel'),
(432001,'501',1500000.00,'SUITE','AVAILABLE','Đà Nẵng','Thanh Khê Hotel'),
(432002,'502',1500000.00,'SUITE','OCCUPIED','Đà Nẵng','Thanh Khê Hotel'),
(432003,'503',1500000.00,'SUITE','CLEANING','Đà Nẵng','Thanh Khê Hotel'),
(432004,'504',1500000.00,'SUITE','MAINTENANCE','Đà Nẵng','Thanh Khê Hotel'),
(432005,'505',1500000.00,'SUITE','AVAILABLE','Đà Nẵng','Thanh Khê Hotel'),
(432006,'506',1500000.00,'SUITE','OCCUPIED','Đà Nẵng','Thanh Khê Hotel'),
(432007,'507',1500000.00,'SUITE','CLEANING','Đà Nẵng','Thanh Khê Hotel'),
(432008,'508',1500000.00,'SUITE','MAINTENANCE','Đà Nẵng','Thanh Khê Hotel'),
(432009,'509',1500000.00,'SUITE','AVAILABLE','Đà Nẵng','Thanh Khê Hotel'),
(432010,'510',1500000.00,'SUITE','OCCUPIED','Đà Nẵng','Thanh Khê Hotel'),
(79101,'101',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79102,'102',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79103,'103',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79104,'104',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79105,'105',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79106,'106',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79107,'107',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79108,'108',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79109,'109',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79110,'110',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79201,'201',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79202,'202',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79203,'203',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79204,'204',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79205,'205',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79206,'206',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79207,'207',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79208,'208',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79209,'209',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79210,'210',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79301,'301',800000.00,'DELUXE','AVAILABLE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79302,'302',800000.00,'DELUXE','OCCUPIED','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79303,'303',800000.00,'DELUXE','CLEANING','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79304,'304',800000.00,'DELUXE','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79305,'305',800000.00,'DELUXE','AVAILABLE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79306,'306',800000.00,'DELUXE','OCCUPIED','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79307,'307',800000.00,'DELUXE','CLEANING','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79308,'308',800000.00,'DELUXE','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79309,'309',800000.00,'DELUXE','AVAILABLE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79310,'310',800000.00,'DELUXE','OCCUPIED','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79401,'401',1200000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79402,'402',1200000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79403,'403',1200000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79404,'404',1200000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79405,'405',1200000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79406,'406',1200000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79407,'407',1200000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79408,'408',1200000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79409,'409',1200000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79410,'410',1200000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79501,'501',1500000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79502,'502',1500000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79503,'503',1500000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79504,'504',1500000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79505,'505',1500000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79506,'506',1500000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79507,'507',1500000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79508,'508',1500000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79509,'509',1500000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79510,'510',1500000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(79601,'101',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79602,'102',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79603,'103',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79604,'104',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79605,'105',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79606,'106',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79607,'107',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79608,'108',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79609,'109',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79610,'110',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79701,'201',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79702,'202',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79703,'203',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79704,'204',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79705,'205',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79706,'206',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79707,'207',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79708,'208',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79709,'209',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79710,'210',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79801,'301',800000.00,'DELUXE','AVAILABLE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79802,'302',800000.00,'DELUXE','OCCUPIED','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79803,'303',800000.00,'DELUXE','CLEANING','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79804,'304',800000.00,'DELUXE','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79805,'305',800000.00,'DELUXE','AVAILABLE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79806,'306',800000.00,'DELUXE','OCCUPIED','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79807,'307',800000.00,'DELUXE','CLEANING','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79808,'308',800000.00,'DELUXE','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79809,'309',800000.00,'DELUXE','AVAILABLE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79810,'310',800000.00,'DELUXE','OCCUPIED','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79901,'401',1200000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79902,'402',1200000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79903,'403',1200000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79904,'404',1200000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79905,'405',1200000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79906,'406',1200000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79907,'407',1200000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79908,'408',1200000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79909,'409',1200000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(79910,'410',1200000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(791001,'501',1500000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(791002,'502',1500000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(791003,'503',1500000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(791004,'504',1500000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(791005,'505',1500000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(791006,'506',1500000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(791007,'507',1500000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(791008,'508',1500000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(791009,'509',1500000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(791010,'510',1500000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(791101,'101',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791102,'102',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791103,'103',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791104,'104',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791105,'105',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791106,'106',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791107,'107',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791108,'108',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791109,'109',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791110,'110',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791201,'201',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791202,'202',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791203,'203',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791204,'204',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791205,'205',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791206,'206',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791207,'207',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791208,'208',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791209,'209',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791210,'210',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791301,'301',800000.00,'DELUXE','AVAILABLE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791302,'302',800000.00,'DELUXE','OCCUPIED','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791303,'303',800000.00,'DELUXE','CLEANING','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791304,'304',800000.00,'DELUXE','MAINTENANCE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791305,'305',800000.00,'DELUXE','AVAILABLE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791306,'306',800000.00,'DELUXE','OCCUPIED','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791307,'307',800000.00,'DELUXE','CLEANING','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791308,'308',800000.00,'DELUXE','MAINTENANCE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791309,'309',800000.00,'DELUXE','AVAILABLE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791310,'310',800000.00,'DELUXE','OCCUPIED','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791401,'401',1200000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791402,'402',1200000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791403,'403',1200000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791404,'404',1200000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791405,'405',1200000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791406,'406',1200000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791407,'407',1200000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791408,'408',1200000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791409,'409',1200000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791410,'410',1200000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791501,'501',1500000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791502,'502',1500000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791503,'503',1500000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791504,'504',1500000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791505,'505',1500000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791506,'506',1500000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791507,'507',1500000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791508,'508',1500000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791509,'509',1500000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791510,'510',1500000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(791601,'101',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791602,'102',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791603,'103',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791604,'104',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791605,'105',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791606,'106',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791607,'107',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791608,'108',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791609,'109',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791610,'110',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791701,'201',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791702,'202',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791703,'203',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791704,'204',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791705,'205',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791706,'206',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791707,'207',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791708,'208',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791709,'209',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791710,'210',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791801,'301',800000.00,'DELUXE','AVAILABLE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791802,'302',800000.00,'DELUXE','OCCUPIED','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791803,'303',800000.00,'DELUXE','CLEANING','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791804,'304',800000.00,'DELUXE','MAINTENANCE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791805,'305',800000.00,'DELUXE','AVAILABLE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791806,'306',800000.00,'DELUXE','OCCUPIED','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791807,'307',800000.00,'DELUXE','CLEANING','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791808,'308',800000.00,'DELUXE','MAINTENANCE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791809,'309',800000.00,'DELUXE','AVAILABLE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791810,'310',800000.00,'DELUXE','OCCUPIED','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791901,'401',1200000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791902,'402',1200000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791903,'403',1200000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791904,'404',1200000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791905,'405',1200000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791906,'406',1200000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791907,'407',1200000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791908,'408',1200000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791909,'409',1200000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(791910,'410',1200000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(792001,'501',1500000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(792002,'502',1500000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(792003,'503',1500000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(792004,'504',1500000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(792005,'505',1500000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(792006,'506',1500000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(792007,'507',1500000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(792008,'508',1500000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(792009,'509',1500000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(792010,'510',1500000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(792101,'101',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792102,'102',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792103,'103',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792104,'104',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792105,'105',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792106,'106',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792107,'107',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792108,'108',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792109,'109',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792110,'110',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792201,'201',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792202,'202',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792203,'203',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792204,'204',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792205,'205',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792206,'206',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792207,'207',500000.00,'STANDARD','AVAILABLE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792208,'208',500000.00,'STANDARD','OCCUPIED','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792209,'209',500000.00,'STANDARD','CLEANING','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792210,'210',500000.00,'STANDARD','MAINTENANCE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792301,'301',800000.00,'DELUXE','AVAILABLE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792302,'302',800000.00,'DELUXE','OCCUPIED','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792303,'303',800000.00,'DELUXE','CLEANING','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792304,'304',800000.00,'DELUXE','MAINTENANCE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792305,'305',800000.00,'DELUXE','AVAILABLE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792306,'306',800000.00,'DELUXE','OCCUPIED','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792307,'307',800000.00,'DELUXE','CLEANING','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792308,'308',800000.00,'DELUXE','MAINTENANCE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792309,'309',800000.00,'DELUXE','AVAILABLE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792310,'310',800000.00,'DELUXE','OCCUPIED','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792401,'401',1200000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792402,'402',1200000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792403,'403',1200000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792404,'404',1200000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792405,'405',1200000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792406,'406',1200000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792407,'407',1200000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792408,'408',1200000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792409,'409',1200000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792410,'410',1200000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792501,'501',1500000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792502,'502',1500000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792503,'503',1500000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792504,'504',1500000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792505,'505',1500000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792506,'506',1500000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792507,'507',1500000.00,'SUITE','CLEANING','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792508,'508',1500000.00,'SUITE','MAINTENANCE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792509,'509',1500000.00,'SUITE','AVAILABLE','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(792510,'510',1500000.00,'SUITE','OCCUPIED','Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(91101,'101',500000.00,'STANDARD','AVAILABLE','Phú Quốc','Dương Đông Hotel'),
(91102,'102',500000.00,'STANDARD','OCCUPIED','Phú Quốc','Dương Đông Hotel'),
(91103,'103',500000.00,'STANDARD','CLEANING','Phú Quốc','Dương Đông Hotel'),
(91104,'104',500000.00,'STANDARD','MAINTENANCE','Phú Quốc','Dương Đông Hotel'),
(91105,'105',500000.00,'STANDARD','AVAILABLE','Phú Quốc','Dương Đông Hotel'),
(91106,'106',500000.00,'STANDARD','OCCUPIED','Phú Quốc','Dương Đông Hotel'),
(91107,'107',500000.00,'STANDARD','CLEANING','Phú Quốc','Dương Đông Hotel'),
(91108,'108',500000.00,'STANDARD','MAINTENANCE','Phú Quốc','Dương Đông Hotel'),
(91109,'109',500000.00,'STANDARD','AVAILABLE','Phú Quốc','Dương Đông Hotel'),
(91110,'110',500000.00,'STANDARD','OCCUPIED','Phú Quốc','Dương Đông Hotel'),
(91201,'201',500000.00,'STANDARD','CLEANING','Phú Quốc','Dương Đông Hotel'),
(91202,'202',500000.00,'STANDARD','MAINTENANCE','Phú Quốc','Dương Đông Hotel'),
(91203,'203',500000.00,'STANDARD','AVAILABLE','Phú Quốc','Dương Đông Hotel'),
(91204,'204',500000.00,'STANDARD','OCCUPIED','Phú Quốc','Dương Đông Hotel'),
(91205,'205',500000.00,'STANDARD','CLEANING','Phú Quốc','Dương Đông Hotel'),
(91206,'206',500000.00,'STANDARD','MAINTENANCE','Phú Quốc','Dương Đông Hotel'),
(91207,'207',500000.00,'STANDARD','AVAILABLE','Phú Quốc','Dương Đông Hotel'),
(91208,'208',500000.00,'STANDARD','OCCUPIED','Phú Quốc','Dương Đông Hotel'),
(91209,'209',500000.00,'STANDARD','CLEANING','Phú Quốc','Dương Đông Hotel'),
(91210,'210',500000.00,'STANDARD','MAINTENANCE','Phú Quốc','Dương Đông Hotel'),
(91301,'301',800000.00,'DELUXE','AVAILABLE','Phú Quốc','Dương Đông Hotel'),
(91302,'302',800000.00,'DELUXE','OCCUPIED','Phú Quốc','Dương Đông Hotel'),
(91303,'303',800000.00,'DELUXE','CLEANING','Phú Quốc','Dương Đông Hotel'),
(91304,'304',800000.00,'DELUXE','MAINTENANCE','Phú Quốc','Dương Đông Hotel'),
(91305,'305',800000.00,'DELUXE','AVAILABLE','Phú Quốc','Dương Đông Hotel'),
(91306,'306',800000.00,'DELUXE','OCCUPIED','Phú Quốc','Dương Đông Hotel'),
(91307,'307',800000.00,'DELUXE','CLEANING','Phú Quốc','Dương Đông Hotel'),
(91308,'308',800000.00,'DELUXE','MAINTENANCE','Phú Quốc','Dương Đông Hotel'),
(91309,'309',800000.00,'DELUXE','AVAILABLE','Phú Quốc','Dương Đông Hotel'),
(91310,'310',800000.00,'DELUXE','OCCUPIED','Phú Quốc','Dương Đông Hotel'),
(91401,'401',1200000.00,'SUITE','CLEANING','Phú Quốc','Dương Đông Hotel'),
(91402,'402',1200000.00,'SUITE','MAINTENANCE','Phú Quốc','Dương Đông Hotel'),
(91403,'403',1200000.00,'SUITE','AVAILABLE','Phú Quốc','Dương Đông Hotel'),
(91404,'404',1200000.00,'SUITE','OCCUPIED','Phú Quốc','Dương Đông Hotel'),
(91405,'405',1200000.00,'SUITE','CLEANING','Phú Quốc','Dương Đông Hotel'),
(91406,'406',1200000.00,'SUITE','MAINTENANCE','Phú Quốc','Dương Đông Hotel'),
(91407,'407',1200000.00,'SUITE','AVAILABLE','Phú Quốc','Dương Đông Hotel'),
(91408,'408',1200000.00,'SUITE','OCCUPIED','Phú Quốc','Dương Đông Hotel'),
(91409,'409',1200000.00,'SUITE','CLEANING','Phú Quốc','Dương Đông Hotel'),
(91410,'410',1200000.00,'SUITE','MAINTENANCE','Phú Quốc','Dương Đông Hotel'),
(91501,'501',1500000.00,'SUITE','AVAILABLE','Phú Quốc','Dương Đông Hotel'),
(91502,'502',1500000.00,'SUITE','OCCUPIED','Phú Quốc','Dương Đông Hotel'),
(91503,'503',1500000.00,'SUITE','CLEANING','Phú Quốc','Dương Đông Hotel'),
(91504,'504',1500000.00,'SUITE','MAINTENANCE','Phú Quốc','Dương Đông Hotel'),
(91505,'505',1500000.00,'SUITE','AVAILABLE','Phú Quốc','Dương Đông Hotel'),
(91506,'506',1500000.00,'SUITE','OCCUPIED','Phú Quốc','Dương Đông Hotel'),
(91507,'507',1500000.00,'SUITE','CLEANING','Phú Quốc','Dương Đông Hotel'),
(91508,'508',1500000.00,'SUITE','MAINTENANCE','Phú Quốc','Dương Đông Hotel'),
(91509,'509',1500000.00,'SUITE','AVAILABLE','Phú Quốc','Dương Đông Hotel'),
(91510,'510',1500000.00,'SUITE','OCCUPIED','Phú Quốc','Dương Đông Hotel'),
(91601,'101',500000.00,'STANDARD','AVAILABLE','Phú Quốc','An Thới Hotel'),
(91602,'102',500000.00,'STANDARD','OCCUPIED','Phú Quốc','An Thới Hotel'),
(91603,'103',500000.00,'STANDARD','CLEANING','Phú Quốc','An Thới Hotel'),
(91604,'104',500000.00,'STANDARD','MAINTENANCE','Phú Quốc','An Thới Hotel'),
(91605,'105',500000.00,'STANDARD','AVAILABLE','Phú Quốc','An Thới Hotel'),
(91606,'106',500000.00,'STANDARD','OCCUPIED','Phú Quốc','An Thới Hotel'),
(91607,'107',500000.00,'STANDARD','CLEANING','Phú Quốc','An Thới Hotel'),
(91608,'108',500000.00,'STANDARD','MAINTENANCE','Phú Quốc','An Thới Hotel'),
(91609,'109',500000.00,'STANDARD','AVAILABLE','Phú Quốc','An Thới Hotel'),
(91610,'110',500000.00,'STANDARD','OCCUPIED','Phú Quốc','An Thới Hotel'),
(91701,'201',500000.00,'STANDARD','CLEANING','Phú Quốc','An Thới Hotel'),
(91702,'202',500000.00,'STANDARD','MAINTENANCE','Phú Quốc','An Thới Hotel'),
(91703,'203',500000.00,'STANDARD','AVAILABLE','Phú Quốc','An Thới Hotel'),
(91704,'204',500000.00,'STANDARD','OCCUPIED','Phú Quốc','An Thới Hotel'),
(91705,'205',500000.00,'STANDARD','CLEANING','Phú Quốc','An Thới Hotel'),
(91706,'206',500000.00,'STANDARD','MAINTENANCE','Phú Quốc','An Thới Hotel'),
(91707,'207',500000.00,'STANDARD','AVAILABLE','Phú Quốc','An Thới Hotel'),
(91708,'208',500000.00,'STANDARD','OCCUPIED','Phú Quốc','An Thới Hotel'),
(91709,'209',500000.00,'STANDARD','CLEANING','Phú Quốc','An Thới Hotel'),
(91710,'210',500000.00,'STANDARD','MAINTENANCE','Phú Quốc','An Thới Hotel'),
(91801,'301',800000.00,'DELUXE','AVAILABLE','Phú Quốc','An Thới Hotel'),
(91802,'302',800000.00,'DELUXE','OCCUPIED','Phú Quốc','An Thới Hotel'),
(91803,'303',800000.00,'DELUXE','CLEANING','Phú Quốc','An Thới Hotel'),
(91804,'304',800000.00,'DELUXE','MAINTENANCE','Phú Quốc','An Thới Hotel'),
(91805,'305',800000.00,'DELUXE','AVAILABLE','Phú Quốc','An Thới Hotel'),
(91806,'306',800000.00,'DELUXE','OCCUPIED','Phú Quốc','An Thới Hotel'),
(91807,'307',800000.00,'DELUXE','CLEANING','Phú Quốc','An Thới Hotel'),
(91808,'308',800000.00,'DELUXE','MAINTENANCE','Phú Quốc','An Thới Hotel'),
(91809,'309',800000.00,'DELUXE','AVAILABLE','Phú Quốc','An Thới Hotel'),
(91810,'310',800000.00,'DELUXE','OCCUPIED','Phú Quốc','An Thới Hotel'),
(91901,'401',1200000.00,'SUITE','CLEANING','Phú Quốc','An Thới Hotel'),
(91902,'402',1200000.00,'SUITE','MAINTENANCE','Phú Quốc','An Thới Hotel'),
(91903,'403',1200000.00,'SUITE','AVAILABLE','Phú Quốc','An Thới Hotel'),
(91904,'404',1200000.00,'SUITE','OCCUPIED','Phú Quốc','An Thới Hotel'),
(91905,'405',1200000.00,'SUITE','CLEANING','Phú Quốc','An Thới Hotel'),
(91906,'406',1200000.00,'SUITE','MAINTENANCE','Phú Quốc','An Thới Hotel'),
(91907,'407',1200000.00,'SUITE','AVAILABLE','Phú Quốc','An Thới Hotel'),
(91908,'408',1200000.00,'SUITE','OCCUPIED','Phú Quốc','An Thới Hotel'),
(91909,'409',1200000.00,'SUITE','CLEANING','Phú Quốc','An Thới Hotel'),
(91910,'410',1200000.00,'SUITE','MAINTENANCE','Phú Quốc','An Thới Hotel'),
(911001,'501',1500000.00,'SUITE','AVAILABLE','Phú Quốc','An Thới Hotel'),
(911002,'502',1500000.00,'SUITE','OCCUPIED','Phú Quốc','An Thới Hotel'),
(911003,'503',1500000.00,'SUITE','CLEANING','Phú Quốc','An Thới Hotel'),
(911004,'504',1500000.00,'SUITE','MAINTENANCE','Phú Quốc','An Thới Hotel'),
(911005,'505',1500000.00,'SUITE','AVAILABLE','Phú Quốc','An Thới Hotel'),
(911006,'506',1500000.00,'SUITE','OCCUPIED','Phú Quốc','An Thới Hotel'),
(911007,'507',1500000.00,'SUITE','CLEANING','Phú Quốc','An Thới Hotel'),
(911008,'508',1500000.00,'SUITE','MAINTENANCE','Phú Quốc','An Thới Hotel'),
(911009,'509',1500000.00,'SUITE','AVAILABLE','Phú Quốc','An Thới Hotel'),
(911010,'510',1500000.00,'SUITE','OCCUPIED','Phú Quốc','An Thới Hotel');

-- =========================
-- INSERT BOOKINGS (3 / chi nhánh)
-- booking.id = <BRANCH><DDMMYYYY><CUSTOMER_ID>
-- (đã bỏ 6 chữ số HHMMSS trong booking.id)
-- =========================
INSERT INTO bookings (id, customer_id, customer_name, check_in_date, check_out_date, total_amount, status, room_id, city, branch_name) VALUES
(290115001234567890,'001234567890','Nguyễn Văn A','2026-01-15 14:00:00','2026-07-14 12:00:00',2500000.00,'CHECKED_IN',29102,'Hà Nội','Ba Đình Hotel'),
(290120001234567891,'001234567891','Trần Thị B','2026-01-20 14:00:00','2026-08-17 12:00:00',3000000.00,'BOOKED',29203,'Hà Nội','Ba Đình Hotel'),
(290110001234567892,'001234567892','Lê Văn C','2026-01-10 14:00:00','2026-09-05 12:00:00',3500000.00,'CHECKED_OUT',29104,'Hà Nội','Ba Đình Hotel'),
(290116001234567891,'001234567891','Trần Thị B','2026-01-16 14:00:00','2026-08-01 12:00:00',2500000.00,'CHECKED_IN',29602,'Hà Nội','Cầu Giấy Hotel'),
(290121001234567892,'001234567892','Lê Văn C','2026-01-21 14:00:00','2026-09-04 12:00:00',3000000.00,'BOOKED',29703,'Hà Nội','Cầu Giấy Hotel'),
(290111001234567893,'001234567893','Phạm Thị D','2026-01-11 14:00:00','2026-09-23 12:00:00',3500000.00,'CHECKED_OUT',29604,'Hà Nội','Cầu Giấy Hotel'),
(290117001234567892,'001234567892','Lê Văn C','2026-01-17 14:00:00','2026-08-19 12:00:00',2500000.00,'CHECKED_IN',291102,'Hà Nội','Đống Đa Hotel'),
(290122001234567893,'001234567893','Phạm Thị D','2026-01-22 14:00:00','2026-09-22 12:00:00',3000000.00,'BOOKED',291203,'Hà Nội','Đống Đa Hotel'),
(290112001234567894,'001234567894','Hoàng Văn E','2026-01-12 14:00:00','2026-10-11 12:00:00',3500000.00,'CHECKED_OUT',291104,'Hà Nội','Đống Đa Hotel'),
(290118001234567893,'001234567893','Phạm Thị D','2026-01-18 14:00:00','2026-09-06 12:00:00',2500000.00,'CHECKED_IN',291602,'Hà Nội','Hai Bà Trưng Hotel'),
(290123001234567894,'001234567894','Hoàng Văn E','2026-01-23 14:00:00','2026-10-10 12:00:00',3000000.00,'BOOKED',291703,'Hà Nội','Hai Bà Trưng Hotel'),
(290113001234567895,'001234567895','Vũ Văn F','2026-01-13 14:00:00','2026-10-29 12:00:00',3500000.00,'CHECKED_OUT',291604,'Hà Nội','Hai Bà Trưng Hotel'),
(290119001234567894,'001234567894','Hoàng Văn E','2026-01-19 14:00:00','2026-09-24 12:00:00',2500000.00,'CHECKED_IN',292102,'Hà Nội','Hoàn Kiếm Hotel'),
(290124001234567895,'001234567895','Vũ Văn F','2026-01-24 14:00:00','2026-10-28 12:00:00',3000000.00,'BOOKED',292203,'Hà Nội','Hoàn Kiếm Hotel'),
(290114001234567896,'001234567896','Đặng Thị G','2026-01-14 14:00:00','2026-11-16 12:00:00',3500000.00,'CHECKED_OUT',292104,'Hà Nội','Hoàn Kiếm Hotel'),
(430120001234567895,'001234567895','Vũ Văn F','2026-01-20 14:00:00','2026-10-12 12:00:00',2500000.00,'CHECKED_IN',43102,'Đà Nẵng','Hải Châu Hotel'),
(430125001234567896,'001234567896','Đặng Thị G','2026-01-25 14:00:00','2026-11-15 12:00:00',3000000.00,'BOOKED',43203,'Đà Nẵng','Hải Châu Hotel'),
(430115001234567897,'001234567897','Phan Văn H','2026-01-15 14:00:00','2026-12-04 12:00:00',3500000.00,'CHECKED_OUT',43104,'Đà Nẵng','Hải Châu Hotel'),
(430121001234567896,'001234567896','Đặng Thị G','2026-01-21 14:00:00','2026-10-30 12:00:00',2500000.00,'CHECKED_IN',43602,'Đà Nẵng','Sơn Trà Hotel'),
(430126001234567897,'001234567897','Phan Văn H','2026-01-26 14:00:00','2026-12-03 12:00:00',3000000.00,'BOOKED',43703,'Đà Nẵng','Sơn Trà Hotel'),
(430116001234567898,'001234567898','Đỗ Thị I','2026-01-16 14:00:00','2026-12-22 12:00:00',3500000.00,'CHECKED_OUT',43604,'Đà Nẵng','Sơn Trà Hotel'),
(430122001234567897,'001234567897','Phan Văn H','2026-01-22 14:00:00','2026-11-17 12:00:00',2500000.00,'CHECKED_IN',431102,'Đà Nẵng','Ngũ Hành Sơn Hotel'),
(430127001234567898,'001234567898','Đỗ Thị I','2026-01-27 14:00:00','2026-12-21 12:00:00',3000000.00,'BOOKED',431203,'Đà Nẵng','Ngũ Hành Sơn Hotel'),
(430117001234567899,'001234567899','Ngô Văn K','2026-01-17 14:00:00','2027-01-09 12:00:00',3500000.00,'CHECKED_OUT',431104,'Đà Nẵng','Ngũ Hành Sơn Hotel'),
(430123001234567898,'001234567898','Đỗ Thị I','2026-01-23 14:00:00','2026-12-05 12:00:00',2500000.00,'CHECKED_IN',431602,'Đà Nẵng','Thanh Khê Hotel'),
(430128001234567899,'001234567899','Ngô Văn K','2026-01-28 14:00:00','2027-01-08 12:00:00',3000000.00,'BOOKED',431703,'Đà Nẵng','Thanh Khê Hotel'),
(430118001234567890,'001234567890','Nguyễn Văn A','2026-01-18 14:00:00','2026-07-25 12:00:00',3500000.00,'CHECKED_OUT',431604,'Đà Nẵng','Thanh Khê Hotel'),
(790124001234567899,'001234567899','Ngô Văn K','2026-01-24 14:00:00','2026-12-23 12:00:00',2500000.00,'CHECKED_IN',79102,'Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(790129001234567890,'001234567890','Nguyễn Văn A','2026-01-29 14:00:00','2027-01-26 12:00:00',3000000.00,'BOOKED',79203,'Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(790119001234567891,'001234567891','Trần Thị B','2026-01-19 14:00:00','2026-08-12 12:00:00',3500000.00,'CHECKED_OUT',79104,'Thành phố Hồ Chí Minh','Quận 1 Hotel'),
(790125001234567890,'001234567890','Nguyễn Văn A','2026-01-25 14:00:00','2027-01-10 12:00:00',2500000.00,'CHECKED_IN',79602,'Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(790130001234567891,'001234567891','Trần Thị B','2026-01-30 14:00:00','2026-08-11 12:00:00',3000000.00,'BOOKED',79703,'Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(790120001234567892,'001234567892','Lê Văn C','2026-01-20 14:00:00','2026-08-30 12:00:00',3500000.00,'CHECKED_OUT',79604,'Thành phố Hồ Chí Minh','Quận 3 Hotel'),
(790126001234567891,'001234567891','Trần Thị B','2026-01-26 14:00:00','2026-07-26 12:00:00',2500000.00,'CHECKED_IN',791102,'Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(790131001234567892,'001234567892','Lê Văn C','2026-01-31 14:00:00','2026-08-29 12:00:00',3000000.00,'BOOKED',791203,'Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(790121001234567893,'001234567893','Phạm Thị D','2026-01-21 14:00:00','2026-09-17 12:00:00',3500000.00,'CHECKED_OUT',791104,'Thành phố Hồ Chí Minh','Phú Nhuận Hotel'),
(790127001234567892,'001234567892','Lê Văn C','2026-01-27 14:00:00','2026-08-13 12:00:00',2500000.00,'CHECKED_IN',791602,'Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(790102001234567893,'001234567893','Phạm Thị D','2026-02-01 14:00:00','2026-09-16 12:00:00',3000000.00,'BOOKED',791703,'Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(790122001234567894,'001234567894','Hoàng Văn E','2026-01-22 14:00:00','2026-10-05 12:00:00',3500000.00,'CHECKED_OUT',791604,'Thành phố Hồ Chí Minh','Tân Bình Hotel'),
(790128001234567893,'001234567893','Phạm Thị D','2026-01-28 14:00:00','2026-08-31 12:00:00',2500000.00,'CHECKED_IN',792102,'Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(790202001234567894,'001234567894','Hoàng Văn E','2026-02-02 14:00:00','2026-10-04 12:00:00',3000000.00,'BOOKED',792203,'Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(790123001234567895,'001234567895','Vũ Văn F','2026-01-23 14:00:00','2026-10-23 12:00:00',3500000.00,'CHECKED_OUT',792104,'Thành phố Hồ Chí Minh','Thủ Đức Hotel'),
(910129001234567894,'001234567894','Hoàng Văn E','2026-01-29 14:00:00','2026-09-18 12:00:00',2500000.00,'CHECKED_IN',91102,'Phú Quốc','Dương Đông Hotel'),
(910203001234567895,'001234567895','Vũ Văn F','2026-02-03 14:00:00','2026-10-22 12:00:00',3000000.00,'BOOKED',91203,'Phú Quốc','Dương Đông Hotel'),
(910124001234567896,'001234567896','Đặng Thị G','2026-01-24 14:00:00','2026-11-10 12:00:00',3500000.00,'CHECKED_OUT',91104,'Phú Quốc','Dương Đông Hotel'),
(910130001234567895,'001234567895','Vũ Văn F','2026-01-30 14:00:00','2026-10-06 12:00:00',2500000.00,'CHECKED_IN',91602,'Phú Quốc','An Thới Hotel'),
(910204001234567896,'001234567896','Đặng Thị G','2026-02-04 14:00:00','2026-11-09 12:00:00',3000000.00,'BOOKED',91703,'Phú Quốc','An Thới Hotel'),
(910125001234567897,'001234567897','Phan Văn H','2026-01-25 14:00:00','2026-11-28 12:00:00',3500000.00,'CHECKED_OUT',91604,'Phú Quốc','An Thới Hotel');

-- =========================
-- INSERT INVOICES (tạo cho các booking CHECKED_OUT)
-- invoices.id = booking_id
-- (đã đồng bộ theo booking.id mới)
-- =========================
INSERT INTO invoices (id, booking_id, total_amount, created_at, payment_type) VALUES
(290110001234567892,290110001234567892,3500000.00,'2026-09-05 13:00:00','CASH'),
(290111001234567893,290111001234567893,3500000.00,'2026-09-23 13:00:00','CASH'),
(290112001234567894,290112001234567894,3500000.00,'2026-10-11 13:00:00','CASH'),
(290113001234567895,290113001234567895,3500000.00,'2026-10-29 13:00:00','CASH'),
(290114001234567896,290114001234567896,3500000.00,'2026-11-16 13:00:00','CASH'),
(430115001234567897,430115001234567897,3500000.00,'2026-12-04 13:00:00','CASH'),
(430116001234567898,430116001234567898,3500000.00,'2026-12-22 13:00:00','CASH'),
(430117001234567899,430117001234567899,3500000.00,'2027-01-09 13:00:00','CASH'),
(430118001234567890,430118001234567890,3500000.00,'2026-07-25 13:00:00','CASH'),
(790119001234567891,790119001234567891,3500000.00,'2026-08-12 13:00:00','CASH'),
(790120001234567892,790120001234567892,3500000.00,'2026-08-30 13:00:00','CASH'),
(790121001234567893,790121001234567893,3500000.00,'2026-09-17 13:00:00','CASH'),
(790122001234567894,790122001234567894,3500000.00,'2026-10-05 13:00:00','CASH'),
(790123001234567895,790123001234567895,3500000.00,'2026-10-23 13:00:00','CASH'),
(910124001234567896,910124001234567896,3500000.00,'2026-11-10 13:00:00','CASH'),
(910125001234567897,910125001234567897,3500000.00,'2026-11-28 13:00:00','CASH');


-- =========================
-- INSERT APPROVAL REQUESTS / LOGS (mẫu)
-- =========================
INSERT INTO approval_requests (id, type, target_id, request_data, reason, status, created_at, created_by) VALUES
(1,'DISCOUNT',290115001234567890,'{"discountPercent":10,"bookingId":"290115140000001234567890"}','Seed request','PENDING',NOW(),'seed_system'),
(2,'DISCOUNT',290120001234567891,'{"discountPercent":10,"bookingId":"290120140000001234567891"}','Seed request','PENDING',NOW(),'seed_system'),
(3,'DISCOUNT',290110001234567892,'{"discountPercent":10,"bookingId":"290110140000001234567892"}','Seed request','PENDING',NOW(),'seed_system'),
(4,'DISCOUNT',290116001234567891,'{"discountPercent":10,"bookingId":"290116140000001234567891"}','Seed request','PENDING',NOW(),'seed_system'),
(5,'DISCOUNT',290121001234567892,'{"discountPercent":10,"bookingId":"290121140000001234567892"}','Seed request','PENDING',NOW(),'seed_system'),
(6,'DISCOUNT',290111001234567893,'{"discountPercent":10,"bookingId":"290111140000001234567893"}','Seed request','PENDING',NOW(),'seed_system'),
(7,'DISCOUNT',290117001234567892,'{"discountPercent":10,"bookingId":"290117140000001234567892"}','Seed request','PENDING',NOW(),'seed_system'),
(8,'DISCOUNT',290122001234567893,'{"discountPercent":10,"bookingId":"290122140000001234567893"}','Seed request','PENDING',NOW(),'seed_system'),
(9,'DISCOUNT',290112001234567894,'{"discountPercent":10,"bookingId":"290112140000001234567894"}','Seed request','PENDING',NOW(),'seed_system'),
(10,'DISCOUNT',290118001234567893,'{"discountPercent":10,"bookingId":"290118140000001234567893"}','Seed request','PENDING',NOW(),'seed_system');

INSERT INTO approval_log (id, command_name, description, timestamp) VALUES
(1,'ApproveDiscountCmd','Duyệt giảm giá (seed log)',NOW()),
(2,'RejectRequestCmd','Từ chối yêu cầu (seed log)',NOW());

-- =========================
-- VERIFY / SUMMARY
-- =========================
SELECT '========== USERS (COUNT BY ROLE & BRANCH) ===========' AS '';
SELECT city, branch_name, role, COUNT(*) AS cnt FROM users GROUP BY city, branch_name, role ORDER BY city, branch_name, role;

SELECT '========== ROOMS (COUNT PER BRANCH) ===========' AS '';
SELECT city, branch_name, COUNT(*) AS rooms_cnt FROM rooms GROUP BY city, branch_name ORDER BY city, branch_name;

SELECT '========== BOOKINGS (SAMPLE) ===========' AS '';
SELECT b.id, b.customer_name, b.status, b.check_in_date, b.check_out_date, r.room_number, b.city, b.branch_name FROM bookings b LEFT JOIN rooms r ON b.room_id = r.id ORDER BY b.city, b.branch_name, b.check_in_date LIMIT 50;

SELECT '========== INVOICES (SAMPLE) ===========' AS '';
SELECT i.id, i.booking_id, i.total_amount, i.payment_type, i.created_at FROM invoices i ORDER BY i.created_at DESC LIMIT 20;

SELECT '========== SUMMARY ===========' AS '';
SELECT (SELECT COUNT(*) FROM users) AS total_users,
       (SELECT COUNT(*) FROM rooms) AS total_rooms,
       (SELECT COUNT(*) FROM customers) AS total_customers,
       (SELECT COUNT(*) FROM bookings) AS total_bookings,
       (SELECT COUNT(*) FROM invoices) AS total_invoices,
       (SELECT COUNT(*) FROM approval_requests) AS total_approval_requests,
       (SELECT COUNT(*) FROM approval_log) AS total_approval_logs;

SELECT '✅ Database hotel_db đã được khởi tạo thành công!' AS status;
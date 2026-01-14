-- =====================================================
-- HOTEL MANAGEMENT SYSTEM - DATABASE INITIALIZATION
-- =====================================================
-- File này sẽ:
-- 1. Tạo database hotel_db
-- 2. Tạo tất cả các bảng
-- 3. Insert dữ liệu mẫu
-- =====================================================
-- Bước 1: Tạo và chọn database
DROP DATABASE IF EXISTS hotel_db;
CREATE DATABASE hotel_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hotel_db;
-- =====================================================
-- BƯỚC 2: TẠO CÁC BẢNG
-- =====================================================
-- Bảng Users (Người dùng hệ thống)
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    city VARCHAR(100),
    branch_name VARCHAR(100),
    birthday DATE,
    phone_number VARCHAR(20),
    email VARCHAR(100)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
-- Bảng Rooms (Phòng)
CREATE TABLE rooms (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(50) NOT NULL,
    price DECIMAL(19, 2) NOT NULL,
    type VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
-- Bảng Customers (Khách hàng)
CREATE TABLE customers (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255),
    phone VARCHAR(20),
    identity_number VARCHAR(50)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
-- Bảng Bookings (Đặt phòng)
CREATE TABLE bookings (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(255),
    check_in_date DATETIME,
    check_out_date DATETIME,
    total_amount DOUBLE,
    status VARCHAR(50),
    room_id BIGINT,
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE
    SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
-- Bảng Invoices (Hóa đơn)
CREATE TABLE invoices (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    booking_id BIGINT,
    total_amount DECIMAL(19, 2),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_type VARCHAR(50),
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
-- Bảng Approval Requests (Yêu cầu phê duyệt)
CREATE TABLE approval_requests (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(255) NOT NULL,
    target_id BIGINT NOT NULL,
    request_data TEXT,
    reason TEXT,
    status VARCHAR(50),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(255)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
-- Bảng Approval Log (Lịch sử phê duyệt)
CREATE TABLE approval_log (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    command_name VARCHAR(255),
    description TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
-- =====================================================
-- BƯỚC 3: INSERT DỮ LIỆU MẪU
-- =====================================================
-- 3.1 INSERT USERS (Người dùng)
-- Password format: FirstName + RoleAbbr + DDMMYY
-- Tất cả đều đã được mã hóa bằng bcrypt
-- Regional Manager: Dương Quang Minh
-- Password: MinhRM150585
INSERT INTO users (
        username,
        password,
        full_name,
        role,
        city,
        branch_name,
        birthday,
        phone_number,
        email
    )
VALUES (
        'MinhRM',
        '$2a$10$2tALBpxsA1Dx9ztRBHQi2.F2WpU6n5cBIoLaRrm5nAAPJMkdzt.Ii',
        'Dương Quang Minh',
        'REGIONAL_MANAGER',
        'Hà Nội',
        NULL,
        '1985-05-15',
        '0901234567',
        'minh@hotel.vn'
    );
-- Branch Manager: Hoàng Văn Anh
-- Password: AnhBM120488
INSERT INTO users (
        username,
        password,
        full_name,
        role,
        city,
        branch_name,
        birthday,
        phone_number,
        email
    )
VALUES (
        'AnhBM',
        '$2a$10$cZz/2xo0J9oZ8TovDes8Xem/zAojjezdYdv2FBmJNUlaOCEua/vfK',
        'Hoàng Văn Anh',
        'BRANCH_MANAGER',
        'Hà Nội',
        'Ba Đình Hotel',
        '1988-04-12',
        '0906789012',
        'anh@hotel.vn'
    );
-- IT Admin: Trương Văn A
-- Password: AADM120392
INSERT INTO users (
        username,
        password,
        full_name,
        role,
        city,
        branch_name,
        birthday,
        phone_number,
        email
    )
VALUES (
        'admin',
        '$2a$10$dtavq9BCQpPJefK38ngSpekB60iTL1OoazPd2rcS.mcsLt2knzU6q',
        'Trương Văn A',
        'ADMIN',
        'Hà Nội',
        'Ba Đình Hotel',
        '1992-03-12',
        '0922345678',
        'admin@hotel.vn'
    );
-- Receptionist: Nguyễn Văn Tuấn
-- Password: TuanREC150695
INSERT INTO users (
        username,
        password,
        full_name,
        role,
        city,
        branch_name,
        birthday,
        phone_number,
        email
    )
VALUES (
        'staff',
        '$2a$10$O2lc4YJhXB.0CxYrmuIsd.Gs9qmDaRGEqSw8p1QYpStvXwRkxcXu2',
        'Nguyễn Văn Tuấn',
        'RECEPTIONIST',
        'Hà Nội',
        'Ba Đình Hotel',
        '1995-06-15',
        '0926789012',
        'tuan@hotel.vn'
    );
-- Housekeeper: Bùi Văn Nam
-- Password: NamHSK270994
INSERT INTO users (
        username,
        password,
        full_name,
        role,
        city,
        branch_name,
        birthday,
        phone_number,
        email
    )
VALUES (
        'housekeeper',
        '$2a$10$1g6SohFDPIqmfqfxW/IAcu/fxv8ZD2JqdUJRo17s9TC74AmwMOBbO',
        'Bùi Văn Nam',
        'HOUSEKEEPER',
        'Hà Nội',
        'Ba Đình Hotel',
        '1994-09-27',
        '0931234567',
        'nam@hotel.vn'
    );
-- 3.2 INSERT ROOMS (Phòng)
-- Các loại phòng: STANDARD, DELUXE, SUITE, PRESIDENTIAL
-- Trạng thái: AVAILABLE, OCCUPIED, CLEANING, MAINTENANCE
-- Phòng tầng 1 (Standard)
INSERT INTO rooms (room_number, price, type, status)
VALUES ('101', 500000.00, 'STANDARD', 'AVAILABLE');
INSERT INTO rooms (room_number, price, type, status)
VALUES ('102', 500000.00, 'STANDARD', 'OCCUPIED');
INSERT INTO rooms (room_number, price, type, status)
VALUES ('103', 500000.00, 'STANDARD', 'CLEANING');
INSERT INTO rooms (room_number, price, type, status)
VALUES ('104', 500000.00, 'STANDARD', 'AVAILABLE');
INSERT INTO rooms (room_number, price, type, status)
VALUES ('105', 500000.00, 'STANDARD', 'AVAILABLE');
-- Phòng tầng 2 (Deluxe)
INSERT INTO rooms (room_number, price, type, status)
VALUES ('201', 800000.00, 'DELUXE', 'AVAILABLE');
INSERT INTO rooms (room_number, price, type, status)
VALUES ('202', 800000.00, 'DELUXE', 'OCCUPIED');
INSERT INTO rooms (room_number, price, type, status)
VALUES ('203', 800000.00, 'DELUXE', 'AVAILABLE');
INSERT INTO rooms (room_number, price, type, status)
VALUES ('204', 800000.00, 'DELUXE', 'MAINTENANCE');
INSERT INTO rooms (room_number, price, type, status)
VALUES ('205', 800000.00, 'DELUXE', 'AVAILABLE');
-- Phòng tầng 3 (Suite)
INSERT INTO rooms (room_number, price, type, status)
VALUES ('301', 1200000.00, 'SUITE', 'AVAILABLE');
INSERT INTO rooms (room_number, price, type, status)
VALUES ('302', 1200000.00, 'SUITE', 'OCCUPIED');
INSERT INTO rooms (room_number, price, type, status)
VALUES ('303', 1200000.00, 'SUITE', 'AVAILABLE');
INSERT INTO rooms (room_number, price, type, status)
VALUES ('304', 1200000.00, 'SUITE', 'AVAILABLE');
-- Phòng tầng 4 (Presidential)
INSERT INTO rooms (room_number, price, type, status)
VALUES ('401', 2500000.00, 'PRESIDENTIAL', 'AVAILABLE');
INSERT INTO rooms (room_number, price, type, status)
VALUES ('402', 2500000.00, 'PRESIDENTIAL', 'AVAILABLE');
-- 3.3 INSERT CUSTOMERS (Khách hàng)
INSERT INTO customers (full_name, phone, identity_number)
VALUES ('Nguyễn Văn A', '0912345678', '001234567890'),
    ('Trần Thị B', '0923456789', '001234567891'),
    ('Lê Văn C', '0934567890', '001234567892'),
    ('Phạm Thị D', '0945678901', '001234567893'),
    ('Hoàng Văn E', '0956789012', '001234567894');
-- 3.4 INSERT BOOKINGS (Đặt phòng)
-- Status: BOOKED, CHECKED_IN, CHECKED_OUT
-- Booking đang ở (CHECKED_IN)
INSERT INTO bookings (
        customer_name,
        check_in_date,
        check_out_date,
        total_amount,
        status,
        room_id
    )
VALUES (
        'Nguyễn Văn A',
        '2026-01-13 14:00:00',
        '2026-01-16 12:00:00',
        1500000,
        'CHECKED_IN',
        2
    );
INSERT INTO bookings (
        customer_name,
        check_in_date,
        check_out_date,
        total_amount,
        status,
        room_id
    )
VALUES (
        'Trần Thị B',
        '2026-01-12 14:00:00',
        '2026-01-15 12:00:00',
        2400000,
        'CHECKED_IN',
        7
    );
INSERT INTO bookings (
        customer_name,
        check_in_date,
        check_out_date,
        total_amount,
        status,
        room_id
    )
VALUES (
        'Lê Văn C',
        '2026-01-14 14:00:00',
        '2026-01-17 12:00:00',
        3600000,
        'CHECKED_IN',
        12
    );
-- Booking đã đặt (BOOKED)
INSERT INTO bookings (
        customer_name,
        check_in_date,
        check_out_date,
        total_amount,
        status,
        room_id
    )
VALUES (
        'Phạm Thị D',
        '2026-01-16 14:00:00',
        '2026-01-18 12:00:00',
        1600000,
        'BOOKED',
        6
    );
INSERT INTO bookings (
        customer_name,
        check_in_date,
        check_out_date,
        total_amount,
        status,
        room_id
    )
VALUES (
        'Hoàng Văn E',
        '2026-01-17 14:00:00',
        '2026-01-20 12:00:00',
        7500000,
        'BOOKED',
        15
    );
-- Booking đã checkout (CHECKED_OUT)
INSERT INTO bookings (
        customer_name,
        check_in_date,
        check_out_date,
        total_amount,
        status,
        room_id
    )
VALUES (
        'Nguyễn Văn A',
        '2026-01-10 14:00:00',
        '2026-01-12 12:00:00',
        1000000,
        'CHECKED_OUT',
        1
    );
-- 3.5 INSERT INVOICES (Hóa đơn)
-- Payment types: CASH, CARD, BANK_TRANSFER
INSERT INTO invoices (
        booking_id,
        total_amount,
        created_at,
        payment_type
    )
VALUES (6, 1000000.00, '2026-01-12 12:30:00', 'CASH');
INSERT INTO invoices (
        booking_id,
        total_amount,
        created_at,
        payment_type
    )
VALUES (1, 1500000.00, '2026-01-16 12:00:00', 'CARD');
-- 3.6 INSERT APPROVAL REQUESTS (Yêu cầu phê duyệt)
-- Types: DISCOUNT, REFUND, ROOM_UPGRADE
-- Status: PENDING, APPROVED, REJECTED
INSERT INTO approval_requests (
        type,
        target_id,
        request_data,
        reason,
        status,
        created_at,
        created_by
    )
VALUES (
        'DISCOUNT',
        1,
        '{"discountPercent": 10, "bookingId": 1}',
        'Khách hàng VIP, yêu cầu giảm giá 10%',
        'PENDING',
        NOW(),
        'staff'
    );
INSERT INTO approval_requests (
        type,
        target_id,
        request_data,
        reason,
        status,
        created_at,
        created_by
    )
VALUES (
        'ROOM_UPGRADE',
        4,
        '{"fromRoomId": 6, "toRoomId": 11}',
        'Khách yêu cầu nâng cấp phòng',
        'APPROVED',
        NOW(),
        'staff'
    );
INSERT INTO approval_requests (
        type,
        target_id,
        request_data,
        reason,
        status,
        created_at,
        created_by
    )
VALUES (
        'REFUND',
        2,
        '{"bookingId": 2, "amount": 500000}',
        'Khách hàng hủy booking sớm',
        'REJECTED',
        NOW(),
        'staff'
    );
-- 3.7 INSERT APPROVAL LOGS (Lịch sử phê duyệt)
INSERT INTO approval_log (command_name, description, timestamp)
VALUES (
        'ApproveDiscountCmd',
        'Duyệt giảm giá 10% cho Booking #1',
        '2026-01-14 10:30:00'
    );
INSERT INTO approval_log (command_name, description, timestamp)
VALUES (
        'ApproveUpgradeCmd',
        'Duyệt nâng cấp phòng cho Booking #4',
        '2026-01-14 11:00:00'
    );
INSERT INTO approval_log (command_name, description, timestamp)
VALUES (
        'RejectRequestCmd',
        'Từ chối hoàn tiền cho Booking #2',
        '2026-01-14 11:30:00'
    );
-- =====================================================
-- BƯỚC 4: VERIFY DỮ LIỆU
-- =====================================================
-- Kiểm tra Users
SELECT '========== USERS ===========' as '';
SELECT username,
    full_name,
    role,
    city,
    branch_name
FROM users
ORDER BY CASE
        role
        WHEN 'REGIONAL_MANAGER' THEN 1
        WHEN 'BRANCH_MANAGER' THEN 2
        WHEN 'ADMIN' THEN 3
        WHEN 'RECEPTIONIST' THEN 4
        WHEN 'HOUSEKEEPER' THEN 5
    END;
-- Kiểm tra Rooms
SELECT '========== ROOMS ===========' as '';
SELECT room_number,
    type,
    price,
    status
FROM rooms
ORDER BY room_number;
-- Kiểm tra Bookings
SELECT '========== BOOKINGS ===========' as '';
SELECT b.id,
    b.customer_name,
    r.room_number,
    b.check_in_date,
    b.check_out_date,
    b.status
FROM bookings b
    LEFT JOIN rooms r ON b.room_id = r.id;
-- Kiểm tra Customers
SELECT '========== CUSTOMERS ===========' as '';
SELECT *
FROM customers;
-- Kiểm tra Invoices
SELECT '========== INVOICES ===========' as '';
SELECT i.id,
    b.customer_name,
    i.total_amount,
    i.payment_type,
    i.created_at
FROM invoices i
    LEFT JOIN bookings b ON i.booking_id = b.id;
-- Kiểm tra Approval Requests
SELECT '========== APPROVAL REQUESTS ===========' as '';
SELECT id,
    type,
    target_id,
    reason,
    status,
    created_by
FROM approval_requests;
-- Kiểm tra Approval Logs
SELECT '========== APPROVAL LOGS ===========' as '';
SELECT *
FROM approval_log
ORDER BY timestamp DESC;
-- =====================================================
-- THỐNG KÊ TỔNG QUAN
-- =====================================================
SELECT '========== SUMMARY ===========' as '';
SELECT (
        SELECT COUNT(*)
        FROM users
    ) as total_users,
    (
        SELECT COUNT(*)
        FROM rooms
    ) as total_rooms,
    (
        SELECT COUNT(*)
        FROM customers
    ) as total_customers,
    (
        SELECT COUNT(*)
        FROM bookings
    ) as total_bookings,
    (
        SELECT COUNT(*)
        FROM invoices
    ) as total_invoices,
    (
        SELECT COUNT(*)
        FROM approval_requests
    ) as total_approval_requests,
    (
        SELECT COUNT(*)
        FROM approval_log
    ) as total_approval_logs;
SELECT '✅ Database hotel_db đã được khởi tạo thành công!' as status;
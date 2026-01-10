-- ============================================
-- HOTEL MANAGEMENT SYSTEM - COMPLETE DATABASE SETUP
-- Tạo database và schema từ đầu
-- ============================================
-- 1. TẠO DATABASE
DROP DATABASE IF EXISTS hotel_db;
CREATE DATABASE hotel_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hotel_db;
-- ============================================
-- 2. TẠO CÁC BẢNG
-- ============================================
-- Bảng Users
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    role VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
-- Bảng Rooms
CREATE TABLE rooms (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(20) UNIQUE NOT NULL,
    type VARCHAR(50),
    price DECIMAL(19, 2),
    status VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
-- Bảng Bookings
CREATE TABLE bookings (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    room_id BIGINT NOT NULL,
    check_in_date DATETIME,
    check_out_date DATETIME,
    total_amount DOUBLE,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE RESTRICT
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
-- Bảng Invoices
CREATE TABLE invoices (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    booking_id BIGINT NOT NULL,
    total_amount DOUBLE,
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
-- Bảng Approval Logs
CREATE TABLE approval_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    command_name VARCHAR(100),
    description TEXT,
    approved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
-- ============================================
-- 3. INSERT DỮ LIỆU MẪU
-- ============================================
-- 3.1 USERS - Tất cả password: 123456
INSERT INTO users (username, password, full_name, role, created_at)
VALUES (
        'admin',
        '{bcrypt}$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        'Quản Lý Cấp Cao',
        'ADMIN',
        NOW()
    ),
    (
        'staff',
        '{bcrypt}$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        'Lễ Tân Chính',
        'RECEPTIONIST',
        NOW()
    ),
    (
        'staff2',
        '{bcrypt}$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        'Nguyễn Văn An',
        'RECEPTIONIST',
        NOW()
    ),
    (
        'cleaner',
        '{bcrypt}$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        'Trần Thị Hoa',
        'HOUSEKEEPING',
        NOW()
    ),
    (
        'cleaner2',
        '{bcrypt}$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        'Lê Văn Minh',
        'HOUSEKEEPING',
        NOW()
    );
-- 3.2 ROOMS - 17 phòng đa dạng
INSERT INTO rooms (room_number, type, price, status)
VALUES -- Tầng 1 - Standard
    ('101', 'STANDARD', 500000, 'OCCUPIED'),
    ('102', 'STANDARD', 500000, 'DIRTY'),
    ('103', 'STANDARD', 500000, 'AVAILABLE'),
    ('104', 'STANDARD', 500000, 'BOOKED'),
    ('105', 'STANDARD', 500000, 'AVAILABLE'),
    -- Tầng 2 - Deluxe
    ('201', 'DELUXE', 800000, 'OCCUPIED'),
    ('202', 'DELUXE', 800000, 'BOOKED'),
    ('203', 'DELUXE', 800000, 'AVAILABLE'),
    ('204', 'DELUXE', 800000, 'DIRTY'),
    ('205', 'DELUXE', 800000, 'MAINTENANCE'),
    -- Tầng 3 - Suite
    ('301', 'SUITE', 1500000, 'OCCUPIED'),
    ('302', 'SUITE', 1500000, 'AVAILABLE'),
    ('303', 'SUITE', 1500000, 'BOOKED'),
    ('304', 'SUITE', 1500000, 'AVAILABLE'),
    -- Tầng 4 - VIP
    ('401', 'VIP', 2500000, 'OCCUPIED'),
    ('402', 'VIP', 2500000, 'AVAILABLE'),
    ('403', 'VIP', 2500000, 'BOOKED');
-- 3.3 BOOKINGS - 14 booking với nhiều trạng thái
INSERT INTO bookings (
        customer_name,
        room_id,
        check_in_date,
        check_out_date,
        total_amount,
        status
    )
VALUES -- Đang ở (CHECKED_IN)
    (
        'Nguyễn Văn A',
        1,
        DATE_SUB(NOW(), INTERVAL 2 DAY),
        DATE_ADD(NOW(), INTERVAL 1 DAY),
        1500000,
        'CHECKED_IN'
    ),
    (
        'Trần Thị B',
        6,
        DATE_SUB(NOW(), INTERVAL 1 DAY),
        DATE_ADD(NOW(), INTERVAL 2 DAY),
        2400000,
        'CHECKED_IN'
    ),
    (
        'Lê Văn C',
        11,
        NOW(),
        DATE_ADD(NOW(), INTERVAL 3 DAY),
        4500000,
        'CHECKED_IN'
    ),
    (
        'Phạm Thị D',
        15,
        NOW(),
        DATE_ADD(NOW(), INTERVAL 2 DAY),
        5000000,
        'CHECKED_IN'
    ),
    -- Đã đặt chưa check-in (BOOKED)
    (
        'Hoàng Văn E',
        4,
        DATE_ADD(NOW(), INTERVAL 1 DAY),
        DATE_ADD(NOW(), INTERVAL 4 DAY),
        1500000,
        'BOOKED'
    ),
    (
        'Võ Thị F',
        7,
        DATE_ADD(NOW(), INTERVAL 2 DAY),
        DATE_ADD(NOW(), INTERVAL 5 DAY),
        2400000,
        'BOOKED'
    ),
    (
        'Đặng Văn G',
        13,
        DATE_ADD(NOW(), INTERVAL 1 DAY),
        DATE_ADD(NOW(), INTERVAL 3 DAY),
        3000000,
        'BOOKED'
    ),
    (
        'Bùi Thị H',
        17,
        DATE_ADD(NOW(), INTERVAL 3 DAY),
        DATE_ADD(NOW(), INTERVAL 6 DAY),
        7500000,
        'BOOKED'
    ),
    -- Đã checkout (CHECKED_OUT)
    (
        'Trịnh Văn I',
        2,
        DATE_SUB(NOW(), INTERVAL 5 DAY),
        DATE_SUB(NOW(), INTERVAL 2 DAY),
        1500000,
        'CHECKED_OUT'
    ),
    (
        'Phan Thị K',
        9,
        DATE_SUB(NOW(), INTERVAL 4 DAY),
        DATE_SUB(NOW(), INTERVAL 1 DAY),
        2400000,
        'CHECKED_OUT'
    ),
    (
        'Dương Văn L',
        3,
        DATE_SUB(NOW(), INTERVAL 10 DAY),
        DATE_SUB(NOW(), INTERVAL 7 DAY),
        1500000,
        'CHECKED_OUT'
    ),
    (
        'Mai Thị M',
        8,
        DATE_SUB(NOW(), INTERVAL 8 DAY),
        DATE_SUB(NOW(), INTERVAL 5 DAY),
        2400000,
        'CHECKED_OUT'
    ),
    -- Đã hủy (CANCELLED)
    (
        'Cao Văn N',
        5,
        DATE_ADD(NOW(), INTERVAL 10 DAY),
        DATE_ADD(NOW(), INTERVAL 13 DAY),
        1500000,
        'CANCELLED'
    ),
    (
        'Lý Thị O',
        12,
        DATE_ADD(NOW(), INTERVAL 15 DAY),
        DATE_ADD(NOW(), INTERVAL 18 DAY),
        4500000,
        'CANCELLED'
    );
-- 3.4 INVOICES - 8 hóa đơn
INSERT INTO invoices (
        booking_id,
        total_amount,
        payment_method,
        payment_status
    )
VALUES -- Đã thanh toán
    (9, 1500000, 'CASH', 'PAID'),
    (10, 2400000, 'CREDIT_CARD', 'PAID'),
    (11, 1500000, 'BANK_TRANSFER', 'PAID'),
    (12, 2400000, 'CASH', 'PAID'),
    -- Chưa thanh toán
    (1, 1500000, 'PENDING', 'UNPAID'),
    (2, 2400000, 'PENDING', 'UNPAID'),
    (3, 4500000, 'PENDING', 'UNPAID'),
    (4, 5000000, 'PENDING', 'UNPAID');
-- 3.5 APPROVAL LOGS
INSERT INTO approval_logs (command_name, description, approved)
VALUES (
        'ApproveDiscountCmd',
        'Giảm giá 10% cho booking #1 - Khách VIP',
        true
    ),
    (
        'ApproveDiscountCmd',
        'Giảm giá 15% cho booking #3 - Doanh nghiệp',
        true
    ),
    (
        'RejectRequestCmd',
        'Từ chối hoàn tiền booking #13',
        false
    ),
    (
        'ApproveDiscountCmd',
        'Giảm giá 5% cho booking #2 - Khách quen',
        true
    );
-- ============================================
-- 4. VERIFICATION - Kiểm tra dữ liệu
-- ============================================
SELECT '=== DATABASE CREATED SUCCESSFULLY ===' AS status;
SELECT DATABASE() AS current_database;
SELECT 'USERS' AS table_name,
    COUNT(*) AS count
FROM users
UNION ALL
SELECT 'ROOMS',
    COUNT(*)
FROM rooms
UNION ALL
SELECT 'BOOKINGS',
    COUNT(*)
FROM bookings
UNION ALL
SELECT 'INVOICES',
    COUNT(*)
FROM invoices
UNION ALL
SELECT 'APPROVAL_LOGS',
    COUNT(*)
FROM approval_logs;
SELECT '=== ROOM STATUS DISTRIBUTION ===' AS info;
SELECT status,
    COUNT(*) AS count
FROM rooms
GROUP BY status
ORDER BY count DESC;
SELECT '=== BOOKING STATUS DISTRIBUTION ===' AS info;
SELECT status,
    COUNT(*) AS count
FROM bookings
GROUP BY status
ORDER BY count DESC;
SELECT '=== READY TO USE! ===' AS message;
SELECT 'Login credentials: admin/123456, staff/123456' AS credentials;
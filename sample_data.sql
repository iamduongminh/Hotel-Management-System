-- ============================================
-- HOTEL MANAGEMENT SYSTEM - SAMPLE DATA
-- Dữ liệu mẫu phức tạp để test hiển thị
-- ============================================
-- Clear existing data (optional - bỏ comment nếu muốn reset)
-- DELETE FROM invoices;
-- DELETE FROM bookings;
-- DELETE FROM rooms;
-- DELETE FROM users;
-- ============================================
-- 1. USERS - Người dùng hệ thống
-- ============================================
-- Password cho tất cả: 123456
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
-- ============================================
-- 2. ROOMS - Phòng khách sạn
-- ============================================
INSERT INTO rooms (
        room_number,
        room_type,
        price_per_night,
        status,
        created_at
    )
VALUES -- Tầng 1 - Standard Rooms
    (101, 'STANDARD', 500000, 'OCCUPIED', NOW()),
    (102, 'STANDARD', 500000, 'DIRTY', NOW()),
    (103, 'STANDARD', 500000, 'AVAILABLE', NOW()),
    (104, 'STANDARD', 500000, 'BOOKED', NOW()),
    (105, 'STANDARD', 500000, 'AVAILABLE', NOW()),
    -- Tầng 2 - Deluxe Rooms
    (201, 'DELUXE', 800000, 'OCCUPIED', NOW()),
    (202, 'DELUXE', 800000, 'BOOKED', NOW()),
    (203, 'DELUXE', 800000, 'AVAILABLE', NOW()),
    (204, 'DELUXE', 800000, 'DIRTY', NOW()),
    (205, 'DELUXE', 800000, 'MAINTENANCE', NOW()),
    -- Tầng 3 - Suite Rooms
    (301, 'SUITE', 1500000, 'OCCUPIED', NOW()),
    (302, 'SUITE', 1500000, 'AVAILABLE', NOW()),
    (303, 'SUITE', 1500000, 'BOOKED', NOW()),
    (304, 'SUITE', 1500000, 'AVAILABLE', NOW()),
    -- Tầng 4 - VIP Rooms
    (401, 'VIP', 2500000, 'OCCUPIED', NOW()),
    (402, 'VIP', 2500000, 'AVAILABLE', NOW()),
    (403, 'VIP', 2500000, 'BOOKED', NOW());
-- ============================================
-- 3. BOOKINGS - Đặt phòng
-- ============================================
INSERT INTO bookings (
        customer_name,
        room_id,
        check_in_date,
        check_out_date,
        total_amount,
        status,
        created_at
    )
VALUES -- Bookings đang active
    (
        'Nguyễn Văn A',
        1,
        DATE_SUB(NOW(), INTERVAL 2 DAY),
        DATE_ADD(NOW(), INTERVAL 1 DAY),
        1500000,
        'CHECKED_IN',
        DATE_SUB(NOW(), INTERVAL 3 DAY)
    ),
    (
        'Trần Thị B',
        6,
        DATE_SUB(NOW(), INTERVAL 1 DAY),
        DATE_ADD(NOW(), INTERVAL 2 DAY),
        2400000,
        'CHECKED_IN',
        DATE_SUB(NOW(), INTERVAL 2 DAY)
    ),
    (
        'Lê Văn C',
        11,
        NOW(),
        DATE_ADD(NOW(), INTERVAL 3 DAY),
        4500000,
        'CHECKED_IN',
        DATE_SUB(NOW(), INTERVAL 1 DAY)
    ),
    (
        'Phạm Thị D',
        15,
        NOW(),
        DATE_ADD(NOW(), INTERVAL 2 DAY),
        5000000,
        'CHECKED_IN',
        NOW()
    ),
    -- Bookings đã đặt, chưa check-in
    (
        'Hoàng Văn E',
        4,
        DATE_ADD(NOW(), INTERVAL 1 DAY),
        DATE_ADD(NOW(), INTERVAL 4 DAY),
        1500000,
        'BOOKED',
        DATE_SUB(NOW(), INTERVAL 2 HOUR)
    ),
    (
        'Võ Thị F',
        7,
        DATE_ADD(NOW(), INTERVAL 2 DAY),
        DATE_ADD(NOW(), INTERVAL 5 DAY),
        2400000,
        'BOOKED',
        DATE_SUB(NOW(), INTERVAL 1 HOUR)
    ),
    (
        'Đặng Văn G',
        13,
        DATE_ADD(NOW(), INTERVAL 1 DAY),
        DATE_ADD(NOW(), INTERVAL 3 DAY),
        3000000,
        'BOOKED',
        DATE_SUB(NOW(), INTERVAL 3 HOUR)
    ),
    (
        'Bùi Thị H',
        17,
        DATE_ADD(NOW(), INTERVAL 3 DAY),
        DATE_ADD(NOW(), INTERVAL 6 DAY),
        7500000,
        'BOOKED',
        NOW()
    ),
    -- Bookings đã checkout (lịch sử)
    (
        'Trịnh Văn I',
        2,
        DATE_SUB(NOW(), INTERVAL 5 DAY),
        DATE_SUB(NOW(), INTERVAL 2 DAY),
        1500000,
        'CHECKED_OUT',
        DATE_SUB(NOW(), INTERVAL 6 DAY)
    ),
    (
        'Phan Thị K',
        9,
        DATE_SUB(NOW(), INTERVAL 4 DAY),
        DATE_SUB(NOW(), INTERVAL 1 DAY),
        2400000,
        'CHECKED_OUT',
        DATE_SUB(NOW(), INTERVAL 5 DAY)
    ),
    (
        'Dương Văn L',
        3,
        DATE_SUB(NOW(), INTERVAL 10 DAY),
        DATE_SUB(NOW(), INTERVAL 7 DAY),
        1500000,
        'CHECKED_OUT',
        DATE_SUB(NOW(), INTERVAL 11 DAY)
    ),
    (
        'Mai Thị M',
        8,
        DATE_SUB(NOW(), INTERVAL 8 DAY),
        DATE_SUB(NOW(), INTERVAL 5 DAY),
        2400000,
        'CHECKED_OUT',
        DATE_SUB(NOW(), INTERVAL 9 DAY)
    ),
    -- Bookings bị hủy
    (
        'Cao Văn N',
        5,
        DATE_ADD(NOW(), INTERVAL 10 DAY),
        DATE_ADD(NOW(), INTERVAL 13 DAY),
        1500000,
        'CANCELLED',
        DATE_SUB(NOW(), INTERVAL 1 DAY)
    ),
    (
        'Lý Thị O',
        12,
        DATE_ADD(NOW(), INTERVAL 15 DAY),
        DATE_ADD(NOW(), INTERVAL 18 DAY),
        4500000,
        'CANCELLED',
        DATE_SUB(NOW(), INTERVAL 2 DAY)
    );
-- ============================================
-- 4. INVOICES - Hóa đơn thanh toán
-- ============================================
INSERT INTO invoices (
        booking_id,
        total_amount,
        payment_method,
        payment_status,
        created_at
    )
VALUES -- Hóa đơn đã thanh toán
    (
        9,
        1500000,
        'CASH',
        'PAID',
        DATE_SUB(NOW(), INTERVAL 2 DAY)
    ),
    (
        10,
        2400000,
        'CREDIT_CARD',
        'PAID',
        DATE_SUB(NOW(), INTERVAL 1 DAY)
    ),
    (
        11,
        1500000,
        'BANK_TRANSFER',
        'PAID',
        DATE_SUB(NOW(), INTERVAL 7 DAY)
    ),
    (
        12,
        2400000,
        'CASH',
        'PAID',
        DATE_SUB(NOW(), INTERVAL 5 DAY)
    ),
    -- Hóa đơn chưa thanh toán (cho bookings đang active)
    (
        1,
        1500000,
        'PENDING',
        'UNPAID',
        DATE_SUB(NOW(), INTERVAL 3 DAY)
    ),
    (
        2,
        2400000,
        'PENDING',
        'UNPAID',
        DATE_SUB(NOW(), INTERVAL 2 DAY)
    ),
    (
        3,
        4500000,
        'PENDING',
        'UNPAID',
        DATE_SUB(NOW(), INTERVAL 1 DAY)
    ),
    (4, 5000000, 'PENDING', 'UNPAID', NOW());
-- ============================================
-- 5. APPROVAL_LOGS - Lịch sử duyệt đơn
-- ============================================
INSERT INTO approval_logs (command_name, description, approved, created_at)
VALUES (
        'ApproveDiscountCmd',
        'Giảm giá 10% cho booking #1 - Khách VIP',
        true,
        DATE_SUB(NOW(), INTERVAL 1 DAY)
    ),
    (
        'ApproveDiscountCmd',
        'Giảm giá 15% cho booking #3 - Khách doanh nghiệp',
        true,
        DATE_SUB(NOW(), INTERVAL 2 HOUR)
    ),
    (
        'RejectRequestCmd',
        'Từ chối yêu cầu hoàn tiền cho booking #13',
        false,
        DATE_SUB(NOW(), INTERVAL 3 HOUR)
    ),
    (
        'ApproveDiscountCmd',
        'Giảm giá 5% cho booking #2 - Khách quen',
        true,
        DATE_SUB(NOW(), INTERVAL 5 HOUR)
    );
-- ============================================
-- SUMMARY
-- ============================================
SELECT '=== DATABASE POPULATED SUCCESSFULLY ===' AS status;
SELECT COUNT(*) AS total_users
FROM users;
SELECT COUNT(*) AS total_rooms
FROM rooms;
SELECT COUNT(*) AS total_bookings
FROM bookings;
SELECT COUNT(*) AS total_invoices
FROM invoices;
SELECT '=== ROOM STATUS DISTRIBUTION ===' AS info;
SELECT status,
    COUNT(*) AS count
FROM rooms
GROUP BY status;
SELECT '=== BOOKING STATUS DISTRIBUTION ===' AS info;
SELECT status,
    COUNT(*) AS count
FROM bookings
GROUP BY status;
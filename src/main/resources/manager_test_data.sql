-- =====================================================
-- MANAGER REPORT TEST DATA SCRIPT
-- Hotel Management System - Grand Hotel
-- Purpose: Additional test data for Manager Operational & Financial Reports
-- Usage: Run this script AFTER database_init.sql
-- =====================================================
USE hotel_db;
-- =====================================================
-- PRE-CLEANUP
-- =====================================================
DELETE FROM booking_services
WHERE booking_id >= 101
    OR booking_id <= 20;
DELETE FROM invoices
WHERE id >= 101;
DELETE FROM bookings
WHERE id >= 101;
-- =====================================================
-- ADDITIONAL BOOKINGS FOR REPORT TESTING
-- =====================================================
-- These bookings span the last 30 days to populate charts with meaningful data
-- Standard Rooms (101-206): 1M VND
-- Superior/Deluxe Rooms (301-405): 1.5M VND  
-- Deluxe Rooms (501-604): 3M VND
-- Suite Rooms (701-704): 5M VND
-- CHECKED_OUT Bookings (Last 30 days for Historical Data)
INSERT INTO bookings (
        id,
        customer_name,
        customer_phone,
        identity_card,
        room_id,
        check_in_date,
        check_out_date,
        total_amount,
        status,
        is_overdue,
        extra_charges,
        overdue_notes
    )
VALUES (
        101,
        'Trương Văn Bình',
        '0921234567',
        '003089012345',
        101,
        '2025-12-20 14:00:00',
        '2025-12-23 12:00:00',
        3000000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        102,
        'Nguyễn Thị Cẩm',
        '0922345678',
        '003190123456',
        202,
        '2025-12-22 14:00:00',
        '2025-12-25 12:00:00',
        3000000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        103,
        'Lâm Văn Đạt',
        '0923456789',
        '003291234567',
        301,
        '2025-12-24 14:00:00',
        '2025-12-27 12:00:00',
        4500000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        104,
        'Vương Thị Nga',
        '0924567890',
        '003392345678',
        401,
        '2025-12-26 14:00:00',
        '2025-12-29 12:00:00',
        4500000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        105,
        'Đinh Văn Quân',
        '0925678901',
        '003493456789',
        501,
        '2025-12-28 14:00:00',
        '2026-01-01 12:00:00',
        12000000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        106,
        'Tôn Thị Hoa',
        '0926789012',
        '003594567890',
        601,
        '2025-12-30 14:00:00',
        '2026-01-03 12:00:00',
        12000000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        107,
        'Từ Văn Khải',
        '0927890123',
        '003695678901',
        701,
        '2026-01-02 14:00:00',
        '2026-01-07 12:00:00',
        25000000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        108,
        'Ứng Thị Linh',
        '0928901234',
        '003796789012',
        103,
        '2026-01-04 14:00:00',
        '2026-01-06 12:00:00',
        2000000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        109,
        'Xa Văn Mạnh',
        '0929012345',
        '003897890123',
        204,
        '2026-01-05 14:00:00',
        '2026-01-08 12:00:00',
        3000000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        110,
        'Yên Thị Nhung',
        '0930123456',
        '003998901234',
        303,
        '2026-01-06 14:00:00',
        '2026-01-09 12:00:00',
        4500000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        111,
        'An Văn Phát',
        '0931234567',
        '004089012345',
        404,
        '2026-01-07 14:00:00',
        '2026-01-10 12:00:00',
        4500000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        112,
        'Bảo Thị Quỳnh',
        '0932345678',
        '004190123456',
        503,
        '2026-01-08 14:00:00',
        '2026-01-11 12:00:00',
        9000000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        113,
        'Châu Văn Sang',
        '0933456789',
        '004291234567',
        604,
        '2026-01-09 14:00:00',
        '2026-01-12 12:00:00',
        9000000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        114,
        'Diệu Thị Tâm',
        '0934567890',
        '004392345678',
        703,
        '2026-01-10 14:00:00',
        '2026-01-14 12:00:00',
        20000000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        115,
        'Gia Văn Uy',
        '0935678901',
        '004493456789',
        105,
        '2026-01-11 14:00:00',
        '2026-01-13 12:00:00',
        2000000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        116,
        'Hạnh Thị Vân',
        '0936789012',
        '004594567890',
        205,
        '2026-01-12 14:00:00',
        '2026-01-14 12:00:00',
        2000000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        117,
        'Khanh Văn Xuân',
        '0937890123',
        '004695678901',
        305,
        '2026-01-13 14:00:00',
        '2026-01-15 12:00:00',
        3000000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        118,
        'Lam Thị Yến',
        '0938901234',
        '004796789012',
        405,
        '2026-01-14 14:00:00',
        '2026-01-16 12:00:00',
        3000000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    );
-- =====================================================
-- INVOICES FOR CHECKED_OUT BOOKINGS
-- =====================================================
-- Invoice ID matches Booking ID
-- Payment types: CASH, CREDIT_CARD, BANK_TRANSFER
INSERT INTO invoices (
        id,
        booking_id,
        total_amount,
        payment_type,
        created_at
    )
VALUES (
        101,
        101,
        3000000.00,
        'CASH',
        '2025-12-23 12:30:00'
    ),
    (
        102,
        102,
        3000000.00,
        'CREDIT_CARD',
        '2025-12-25 11:45:00'
    ),
    (
        103,
        103,
        4500000.00,
        'BANK_TRANSFER',
        '2025-12-27 12:15:00'
    ),
    (
        104,
        104,
        4500000.00,
        'CASH',
        '2025-12-29 12:00:00'
    ),
    (
        105,
        105,
        12000000.00,
        'CREDIT_CARD',
        '2026-01-01 11:30:00'
    ),
    (
        106,
        106,
        12000000.00,
        'BANK_TRANSFER',
        '2026-01-03 12:00:00'
    ),
    (
        107,
        107,
        25000000.00,
        'CREDIT_CARD',
        '2026-01-07 12:20:00'
    ),
    (
        108,
        108,
        2000000.00,
        'CASH',
        '2026-01-06 11:40:00'
    ),
    (
        109,
        109,
        3000000.00,
        'CREDIT_CARD',
        '2026-01-08 12:10:00'
    ),
    (
        110,
        110,
        4500000.00,
        'BANK_TRANSFER',
        '2026-01-09 11:55:00'
    ),
    (
        111,
        111,
        4500000.00,
        'CASH',
        '2026-01-10 12:05:00'
    ),
    (
        112,
        112,
        9000000.00,
        'CREDIT_CARD',
        '2026-01-11 11:50:00'
    ),
    (
        113,
        113,
        9000000.00,
        'BANK_TRANSFER',
        '2026-01-12 12:15:00'
    ),
    (
        114,
        114,
        20000000.00,
        'CREDIT_CARD',
        '2026-01-14 12:25:00'
    ),
    (
        115,
        115,
        2000000.00,
        'CASH',
        '2026-01-13 11:35:00'
    ),
    (
        116,
        116,
        2000000.00,
        'CREDIT_CARD',
        '2026-01-14 12:00:00'
    ),
    (
        117,
        117,
        3000000.00,
        'BANK_TRANSFER',
        '2026-01-15 11:45:00'
    ),
    (
        118,
        118,
        3000000.00,
        'CASH',
        '2026-01-16 12:10:00'
    );
-- =====================================================
-- VERIFICATION
-- =====================================================
SELECT 'Manager Test Data Inserted Successfully' AS status;
SELECT COUNT(*) AS new_bookings_count
FROM bookings
WHERE id >= 101;
SELECT COUNT(*) AS new_invoices_count
FROM invoices
WHERE id >= 101;
-- =====================================================
-- 8. BOOKING SERVICES TEST DATA
-- =====================================================
-- Populate service usage for existing bookings (IDs 101-118, 1-20)
-- Mix of Food, Laundry, Spa, Transport, etc.
INSERT INTO booking_services (booking_id, service_id, quantity, price)
VALUES -- Booking 101 (Checked Out Dec 23)
    (101, 1001, 2, 150000.00),
    -- 2x Breakfast
    (101, 2001, 1, 450000.00),
    -- 1x Laundry
    -- Booking 102 (Checked Out Dec 25)
    (102, 1001, 2, 150000.00),
    -- 2x Breakfast
    (102, 1005, 1, 200000.00),
    -- 1x Minibar
    (102, 3001, 1, 850000.00),
    -- 1x Massage
    -- Booking 103 (Checked Out Dec 27)
    (103, 1003, 2, 350000.00),
    -- 2x Dinner
    (103, 4001, 1, 1250000.00),
    -- 1x Airport Pickup
    -- Booking 104 (Checked Out Dec 29)
    (104, 1001, 2, 150000.00),
    -- 2x Breakfast
    (104, 2002, 1, 650000.00),
    -- 1x Dry Cleaning
    -- Booking 105 (Checked Out Jan 1) -> Updated to last 30 days logic
    (105, 1001, 4, 150000.00),
    -- 4x Breakfast
    (105, 1003, 2, 350000.00),
    -- 2x Dinner
    (105, 3003, 1, 1150000.00),
    -- 1x Hot Stone Massage
    (105, 5002, 1, 1850000.00),
    -- 1x BBQ Beach
    -- Booking 106 (Checked Out Jan 3)
    (106, 1001, 2, 150000.00),
    -- 2x Breakfast
    (106, 6002, 1, 1200000.00),
    -- 1x Birthday Setup
    -- Booking 107 (Checked Out Jan 7)
    (107, 1001, 5, 150000.00),
    (107, 3001, 2, 850000.00),
    (107, 4002, 1, 1500000.00),
    -- Car Rental
    (107, 1005, 3, 200000.00),
    -- Booking 108 (Checked Out Jan 6)
    (108, 1002, 2, 80000.00),
    -- Afternoon Coffee
    -- Booking 109 (Checked Out Jan 8)
    (109, 2004, 1, 500000.00),
    -- Ironing
    (109, 1004, 1, 50000.00),
    -- Room Service
    -- Booking 110 (Checked Out Jan 9)
    (110, 3002, 1, 950000.00),
    -- Facial Care
    (110, 1001, 3, 150000.00),
    -- Booking 111 (Checked Out Jan 10)
    (111, 4004, 1, 1350000.00),
    -- City Tour
    (111, 1003, 2, 350000.00),
    -- Booking 112 (Checked Out Jan 11) - VIP
    (112, 5003, 1, 2000000.00),
    -- Golf
    (112, 1001, 3, 150000.00),
    (112, 3001, 2, 850000.00),
    -- Booking 113 (Checked Out Jan 12)
    (113, 1001, 2, 150000.00),
    (113, 2001, 1, 450000.00),
    -- Booking 114 (Checked Out Jan 14) - Large Bill
    (114, 5004, 2, 1750000.00),
    -- Diving Tour
    (114, 3003, 2, 1150000.00),
    -- Hot Stone
    (114, 1003, 4, 350000.00),
    -- Dinner
    -- Booking 115 (Checked Out Jan 13)
    (115, 1002, 2, 80000.00),
    -- Booking 116 (Checked Out Jan 14)
    (116, 2003, 1, 750000.00),
    -- Express Laundry
    -- Booking 117 (Checked Out Jan 15)
    (117, 1004, 2, 50000.00),
    (117, 1005, 2, 200000.00),
    -- Booking 118 (Checked Out Jan 16 - Today/Yesterday)
    (118, 1001, 1, 150000.00),
    (118, 4001, 1, 1250000.00),
    -- LIVE DATA (Active Stays)
    (1, 1001, 2, 150000.00),
    (1, 1005, 1, 200000.00),
    (2, 1001, 2, 150000.00),
    (3, 3001, 1, 850000.00),
    (4, 2001, 1, 450000.00);
-- Verification
SELECT 'Additional Service Usage Data Inserted' AS status;
SELECT s.name,
    COUNT(bs.id) as usage_count,
    SUM(bs.quantity * bs.price) as total_revenue
FROM booking_services bs
    JOIN services s ON bs.service_id = s.id
GROUP BY s.name
ORDER BY usage_count DESC;
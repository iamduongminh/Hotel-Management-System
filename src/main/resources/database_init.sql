-- =====================================================
-- COMPLETE DATABASE INITIALIZATION SCRIPT
-- Hotel Management System - Grand Hotel
-- =====================================================
-- 1. SCHEMA INITIALIZATION
DROP DATABASE IF EXISTS hotel_db;
CREATE DATABASE hotel_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hotel_db;
-- 2. CREATE TABLES
-- Users
CREATE TABLE users (
    id BIGINT NOT NULL AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    birthday DATE,
    phone_number VARCHAR(20),
    email VARCHAR(255),
    PRIMARY KEY (id),
    UNIQUE KEY uk_username (username)
);
-- Room Categories
CREATE TABLE room_categories (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    base_price DECIMAL(19, 2) NOT NULL,
    capacity INT NOT NULL,
    amenities TEXT,
    active BIT NOT NULL DEFAULT 1,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id)
);
-- Rooms
CREATE TABLE rooms (
    id BIGINT NOT NULL AUTO_INCREMENT,
    room_number VARCHAR(255),
    price DECIMAL(19, 2),
    type VARCHAR(50),
    status VARCHAR(50),
    PRIMARY KEY (id)
);
-- Services
CREATE TABLE services (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL,
    description TEXT,
    price DECIMAL(19, 2) NOT NULL,
    active BIT NOT NULL DEFAULT 1,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id)
);
-- Customers
CREATE TABLE customers (
    id BIGINT NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(255),
    phone VARCHAR(20),
    identity_number VARCHAR(50),
    PRIMARY KEY (id)
);
-- Bookings
CREATE TABLE bookings (
    id BIGINT NOT NULL AUTO_INCREMENT,
    customer_name VARCHAR(255),
    room_id BIGINT,
    check_in_date DATETIME(6),
    check_out_date DATETIME(6),
    total_amount DOUBLE,
    status VARCHAR(50),
    is_overdue BIT NOT NULL DEFAULT 0,
    extra_charges DECIMAL(10, 2) DEFAULT 0,
    overdue_notes VARCHAR(500),
    PRIMARY KEY (id),
    CONSTRAINT fk_booking_room FOREIGN KEY (room_id) REFERENCES rooms (id)
);
-- Invoices
CREATE TABLE invoices (
    id BIGINT NOT NULL AUTO_INCREMENT,
    booking_id BIGINT,
    total_amount DECIMAL(38, 2),
    payment_type VARCHAR(50),
    created_at DATETIME(6),
    PRIMARY KEY (id),
    UNIQUE KEY uk_booking_invoice (booking_id),
    CONSTRAINT fk_invoice_booking FOREIGN KEY (booking_id) REFERENCES bookings (id)
);
-- 3. DATA INSERTION
-- =====================================================
-- USERS TABLE
-- =====================================================
-- Password format: initials + role + birthday (BCrypt encoded)
-- ID format: employee type (01=manager, 02=admin, 03=receptionist) + 4-digit number
-- Managers (2)
INSERT INTO users (
        id,
        username,
        password,
        full_name,
        role,
        birthday,
        phone_number,
        email
    )
VALUES (
        10001,
        'ducnt',
        '$2a$10$spX2VIHQfHRbsj4RTlNsLOhTrXY18Jf/BRffmNvihwDAkJ4j5/Ztu',
        'Nguyễn Trung Đức',
        'MANAGER',
        '1985-10-15',
        '0912345001',
        'ducnt@0001.grandhotel.com'
    ),
    (
        10002,
        'minhdq',
        '$2a$10$7YJDQbjnaLMabXeMNdeXW.h8VViDtcuCx0n61Z/9lkDmC4woAfAl.',
        'Dương Quang Minh',
        'MANAGER',
        '1987-04-10',
        '0912345002',
        'minhdq@0002.grandhotel.com'
    );
-- Admins (5)
INSERT INTO users (
        id,
        username,
        password,
        full_name,
        role,
        birthday,
        phone_number,
        email
    )
VALUES (
        20001,
        'vanna',
        '$2a$10$kbaQrrwN0237tlYUbFuO6OyM.3cV7kZCYxRt7FP6S03UTD0Micvvq',
        'Nguyễn Anh Văn',
        'ADMIN',
        '1990-05-20',
        '0912345003',
        'vanna@0001.grandhotel.com'
    ),
    (
        20002,
        'duongnq',
        '$2a$10$2Zxr6.seWjufSk2zMqt/pOXVTvgqKJwCqjo3fH9ee0f12DD/Sm3pS',
        'Nguyễn Quang Dương',
        'ADMIN',
        '1992-08-25',
        '0912345004',
        'duongnq@0002.grandhotel.com'
    ),
    (
        20003,
        'nguyennt',
        '$2a$10$1gzO7pEwUJYlNQbxS9S/6.7eW.A4rCJhfYkt4JIn1PqlUtrMDRFxO',
        'Ngô Triệu Nguyên',
        'ADMIN',
        '1991-12-30',
        '0912345005',
        'nguyennt@0003.grandhotel.com'
    ),
    (
        20004,
        'binhbth',
        '$2a$10$hksvB4A22qRE61i0HozhuerLraDNUYUpIkY10aWUxg.SwjnjNzjPu',
        'Bùi Trần Hà Bình',
        'ADMIN',
        '1989-03-15',
        '0912345006',
        'binhbth@0004.grandhotel.com'
    ),
    (
        20005,
        'anhk',
        '$2a$10$jxnDg3005Ima/wRGIgm.NuK9S5nlNZnFM5rzMikRXeX3ISIUnxLRS',
        'Nguyễn Khánh Anh',
        'ADMIN',
        '1993-07-08',
        '0912345007',
        'anhk@0005.grandhotel.com'
    );
-- Receptionists (12)
INSERT INTO users (
        id,
        username,
        password,
        full_name,
        role,
        birthday,
        phone_number,
        email
    )
VALUES (
        30001,
        'linhntt',
        '$2a$10$ars/ykQ7gncm8pFyWmLPzuSD1Og5r1o777Ok3wUI7mEu5NdrAHrFO',
        'Nguyễn Thị Thanh Linh',
        'RECEPTIONIST',
        '1995-06-12',
        '0912345008',
        'linhntt@0001.grandhotel.com'
    ),
    (
        30002,
        'hoanv',
        '$2a$10$QAim9y6wnkBjnJWhy3iN7OPpUdaeyuctHoFCY0Wx5NHlxmca51Dd6',
        'Nguyễn Văn Hoà',
        'RECEPTIONIST',
        '1996-09-18',
        '0912345009',
        'hoanv@0002.grandhotel.com'
    ),
    (
        30003,
        'thuylt',
        '$2a$10$Z8x1DS4TbXoGVowaamp5gu2nRN398nhsI52e8id/DLBfSMT.yazrG',
        'Lê Thị Thùy',
        'RECEPTIONIST',
        '1997-02-25',
        '0912345010',
        'thuylt@0003.grandhotel.com'
    ),
    (
        30004,
        'quanpt',
        '$2a$10$KdkHran9JnRv4kNxRv6LVO.Hr0rEj8pNeR.PsQLZrk.LHjBbKOdM2',
        'Phạm Tiến Quân',
        'RECEPTIONIST',
        '1998-11-03',
        '0912345011',
        'quanpt@0004.grandhotel.com'
    ),
    (
        30005,
        'mynh',
        '$2a$10$hSdV4G6.ex3/vmAtUMoSO.2dSX5AQXWaxyiesPzdVbIUrksxE5B3G',
        'Ngô Hà My',
        'RECEPTIONIST',
        '1996-04-16',
        '0912345012',
        'mynh@0005.grandhotel.com'
    ),
    (
        30006,
        'tungnv',
        '$2a$10$dcmSLneoqRoaA6QE9dbCxuVgC/6v7TSHWKDawcgJurxXqMNi3q5da',
        'Nguyễn Văn Tùng',
        'RECEPTIONIST',
        '1995-08-22',
        '0912345013',
        'tungnv@0006.grandhotel.com'
    ),
    (
        30007,
        'huyenttm',
        '$2a$10$VH3Y2qOyiCG9PNMGUVEXnubXUVyahKbigEuy2WGdsz/YafqW3MDUm',
        'Trần Thị Minh Huyền',
        'RECEPTIONIST',
        '1997-01-30',
        '0912345014',
        'huyenttm@0007.grandhotel.com'
    ),
    (
        30008,
        'datpv',
        '$2a$10$9ZAb0QzS3yMvnugLXGSNQ.RVJUWf6zHmx9BD89n0KfnYtnZq549ce',
        'Phạm Văn Đạt',
        'RECEPTIONIST',
        '1998-05-14',
        '0912345015',
        'datpv@0008.grandhotel.com'
    ),
    (
        30009,
        'hanhtt',
        '$2a$10$U52k9h5y4iiuqItZhax9J.T.sx/wtRNaNbu9FQCXJ6UQMf6WVuG8q',
        'Trần Thị Hạnh',
        'RECEPTIONIST',
        '1996-12-07',
        '0912345016',
        'hanhtt@0009.grandhotel.com'
    ),
    (
        30010,
        'phongnd',
        '$2a$10$ZBa6VHQm5Lo4YPnIB9KaCO8sBacI1b32rPWvSgU4ug9cdH/m65DCK',
        'Nguyễn Đức Phong',
        'RECEPTIONIST',
        '1995-03-28',
        '0912345017',
        'phongnd@0010.grandhotel.com'
    ),
    (
        30011,
        'chinh',
        '$2a$10$WgLCuyigYeYZ8MUrVOqVd.kuc.rkuTfAl5ArQ.x5fyPdsiMyajYU.',
        'Ngô Hải Chi',
        'RECEPTIONIST',
        '1997-10-11',
        '0912345018',
        'chinh@0011.grandhotel.com'
    ),
    (
        30012,
        'longth',
        '$2a$10$7dN7PejEQBbR7RuS7oqDMeVIBySSd4JpI/OzacS1T.sqRxI5f5hey',
        'Trần Hoàng Long',
        'RECEPTIONIST',
        '1998-07-19',
        '0912345019',
        'longth@0012.grandhotel.com'
    );
-- =====================================================
-- 2. ROOM CATEGORIES TABLE
-- =====================================================
INSERT INTO room_categories (
        id,
        name,
        description,
        base_price,
        capacity,
        amenities,
        active,
        created_at,
        updated_at
    )
VALUES (
        1,
        'Standard',
        'Phòng tiêu chuẩn với đầy đủ tiện nghi cơ bản',
        1000000.00,
        2,
        'TV, Wifi, Điều hòa, Tủ lạnh mini',
        true,
        NOW(),
        NOW()
    ),
    (
        2,
        'Superior',
        'Phòng cao cấp với view đẹp và không gian rộng rãi',
        1500000.00,
        2,
        'TV LCD, Wifi cao tốc, Điều hòa, Tủ lạnh, Bồn tắm',
        true,
        NOW(),
        NOW()
    ),
    (
        3,
        'Deluxe',
        'Phòng sang trọng với nội thất cao cấp',
        3000000.00,
        3,
        'Smart TV, Wifi, Điều hòa, Minibar, Jacuzzi, Ban công',
        true,
        NOW(),
        NOW()
    ),
    (
        4,
        'Suite',
        'Phòng hạng phòng suite với phòng khách riêng',
        5000000.00,
        4,
        'Smart TV 55 inch, Wifi VIP, Điều hòa trung tâm, Minibar, Jacuzzi, Ban công view biển, Phòng khách riêng',
        true,
        NOW(),
        NOW()
    ),
    (
        8,
        'VIP',
        'Phòng VIP đẳng cấp nhất khách sạn',
        10000000.00,
        5,
        'Full tiện nghi VIP, Hồ bơi riêng, Quản gia riêng',
        true,
        NOW(),
        NOW()
    ),
    (
        7,
        'Dorm',
        'Phòng ngủ tập thể (Dormitory)',
        200000.00,
        1,
        'Giường tầng, Tủ khóa cá nhân, Wifi',
        true,
        NOW(),
        NOW()
    );
-- =====================================================
-- 3. ROOMS TABLE
-- =====================================================
-- Room ID format: floor number + room number in floor (e.g., 201 = floor 2, room 1)
-- Standard (1M VND): Floors 1-2
INSERT INTO rooms (id, room_number, price, type, status)
VALUES (101, '101', 1000000.00, 'STANDARD', 'AVAILABLE'),
    (102, '102', 1000000.00, 'STANDARD', 'OCCUPIED'),
    (103, '103', 1000000.00, 'STANDARD', 'DIRTY'),
    (104, '104', 1000000.00, 'STANDARD', 'CLEANING'),
    (105, '105', 1000000.00, 'STANDARD', 'AVAILABLE'),
    (106, '106', 1000000.00, 'STANDARD', 'BOOKED'),
    (201, '201', 1000000.00, 'STANDARD', 'OCCUPIED'),
    (202, '202', 1000000.00, 'STANDARD', 'AVAILABLE'),
    (203, '203', 1000000.00, 'STANDARD', 'AVAILABLE'),
    (204, '204', 1000000.00, 'STANDARD', 'DIRTY'),
    (205, '205', 1000000.00, 'STANDARD', 'AVAILABLE'),
    (
        206,
        '206',
        1000000.00,
        'STANDARD',
        'MAINTENANCE'
    );
-- Superior (1.5M VND): Floors 3-4
INSERT INTO rooms (id, room_number, price, type, status)
VALUES (301, '301', 1500000.00, 'DELUXE', 'AVAILABLE'),
    (302, '302', 1500000.00, 'DELUXE', 'OCCUPIED'),
    (303, '303', 1500000.00, 'DELUXE', 'AVAILABLE'),
    (304, '304', 1500000.00, 'DELUXE', 'BOOKED'),
    (305, '305', 1500000.00, 'DELUXE', 'AVAILABLE'),
    (401, '401', 1500000.00, 'DELUXE', 'CLEANING'),
    (402, '402', 1500000.00, 'DELUXE', 'AVAILABLE'),
    (403, '403', 1500000.00, 'DELUXE', 'OCCUPIED'),
    (404, '404', 1500000.00, 'DELUXE', 'AVAILABLE'),
    (405, '405', 1500000.00, 'DELUXE', 'DIRTY');
-- Deluxe (3M VND): Floors 5-6
INSERT INTO rooms (id, room_number, price, type, status)
VALUES (501, '501', 3000000.00, 'DELUXE', 'AVAILABLE'),
    (502, '502', 3000000.00, 'DELUXE', 'OCCUPIED'),
    (503, '503', 3000000.00, 'DELUXE', 'AVAILABLE'),
    (504, '504', 3000000.00, 'DELUXE', 'AVAILABLE'),
    (601, '601', 3000000.00, 'DELUXE', 'BOOKED'),
    (602, '602', 3000000.00, 'DELUXE', 'AVAILABLE'),
    (603, '603', 3000000.00, 'DELUXE', 'OCCUPIED'),
    (604, '604', 3000000.00, 'DELUXE', 'CLEANING');
-- Suite (5M VND): Floor 7
INSERT INTO rooms (id, room_number, price, type, status)
VALUES (701, '701', 5000000.00, 'SUITE', 'AVAILABLE'),
    (702, '702', 5000000.00, 'SUITE', 'OCCUPIED'),
    (703, '703', 5000000.00, 'SUITE', 'AVAILABLE'),
    (704, '704', 5000000.00, 'SUITE', 'BOOKED');
-- =====================================================
-- 4. SERVICES TABLE
-- =====================================================
-- Service IDs: 4-digit numbers
-- Prices: Evenly distributed from 0 to 2,000,000 VND
INSERT INTO services (
        id,
        name,
        type,
        description,
        price,
        active,
        created_at,
        updated_at
    )
VALUES -- FOOD_BEVERAGE (0-400k)
    (
        1001,
        'Bữa sáng buffet',
        'FOOD_BEVERAGE',
        'Buffet sáng quốc tế với hơn 50 món',
        150000.00,
        true,
        NOW(),
        NOW()
    ),
    (
        1002,
        'Cà phê chiều',
        'FOOD_BEVERAGE',
        'Set cà phê và bánh ngọt',
        80000.00,
        true,
        NOW(),
        NOW()
    ),
    (
        1003,
        'Bữa tối tại nhà hàng',
        'FOOD_BEVERAGE',
        'Thực đơn á la carte cao cấp',
        350000.00,
        true,
        NOW(),
        NOW()
    ),
    (
        1004,
        'Dịch vụ phòng 24/7',
        'FOOD_BEVERAGE',
        'Giao đồ ăn tận phòng mọi lúc',
        50000.00,
        true,
        NOW(),
        NOW()
    ),
    (
        1005,
        'Mini bar',
        'FOOD_BEVERAGE',
        'Đồ uống và snack trong phòng',
        200000.00,
        true,
        NOW(),
        NOW()
    ),
    -- LAUNDRY (400k-800k)
    (
        2001,
        'Giặt ủi thường',
        'LAUNDRY',
        'Giặt ủi quần áo thường trong 24h',
        450000.00,
        true,
        NOW(),
        NOW()
    ),
    (
        2002,
        'Giặt khô cao cấp',
        'LAUNDRY',
        'Giặt khô cho đồ cao cấp',
        650000.00,
        true,
        NOW(),
        NOW()
    ),
    (
        2003,
        'Giặt ủi nhanh',
        'LAUNDRY',
        'Dịch vụ giặt ủi trong 4 giờ',
        750000.00,
        true,
        NOW(),
        NOW()
    ),
    (
        2004,
        'Là ủi chuyên nghiệp',
        'LAUNDRY',
        'Là ủi cho vest, áo sơ mi',
        500000.00,
        true,
        NOW(),
        NOW()
    ),
    -- SPA_WELLNESS (800k-1.2M)
    (
        3001,
        'Massage toàn thân 60 phút',
        'SPA_WELLNESS',
        'Massage thư giãn với tinh dầu thiên nhiên',
        850000.00,
        true,
        NOW(),
        NOW()
    ),
    (
        3002,
        'Chăm sóc da mặt cơ bản',
        'SPA_WELLNESS',
        'Liệu trình chăm sóc da 45 phút',
        950000.00,
        true,
        NOW(),
        NOW()
    ),
    (
        3003,
        'Massage đá nóng 90 phút',
        'SPA_WELLNESS',
        'Liệu pháp đá nóng toàn thân',
        1150000.00,
        true,
        NOW(),
        NOW()
    ),
    (
        3004,
        'Xông hơi & sauna',
        'SPA_WELLNESS',
        'Sử dụng phòng xông hơi và sauna',
        800000.00,
        true,
        NOW(),
        NOW()
    ),
    (
        3005,
        'Yoga buổi sáng',
        'SPA_WELLNESS',
        'Lớp yoga hướng dẫn 1-1',
        900000.00,
        true,
        NOW(),
        NOW()
    ),
    -- TRANSPORTATION (1.2M-1.6M)
    (
        4001,
        'Đưa đón sân bay',
        'TRANSPORTATION',
        'Xe sang đưa đón sân bay Nội Bài',
        1250000.00,
        true,
        NOW(),
        NOW()
    ),
    (
        4002,
        'Thuê xe 4 chỗ trong ngày',
        'TRANSPORTATION',
        'Thuê xe cả ngày với tài xế',
        1500000.00,
        true,
        NOW(),
        NOW()
    ),
    (
        4003,
        'Thuê xe 7 chỗ trong ngày',
        'TRANSPORTATION',
        'Xe 7 chỗ với tài xế chuyên nghiệp',
        1600000.00,
        true,
        NOW(),
        NOW()
    ),
    (
        4004,
        'Tour city half-day',
        'TRANSPORTATION',
        'Tour tham quan thành phố nửa ngày',
        1350000.00,
        true,
        NOW(),
        NOW()
    ),
    -- ENTERTAINMENT (1.6M-2M)
    (
        5001,
        'Vé hòa nhạc VIP',
        'ENTERTAINMENT',
        'Vé xem hòa nhạc tại khách sạn',
        1650000.00,
        true,
        NOW(),
        NOW()
    ),
    (
        5002,
        'Tiệc BBQ bãi biển',
        'ENTERTAINMENT',
        'Tiệc nướng tại bãi biển riêng',
        1850000.00,
        true,
        NOW(),
        NOW()
    ),
    (
        5003,
        'Chơi golf 18 hố',
        'ENTERTAINMENT',
        'Sân golf 18 hố chuẩn quốc tế',
        2000000.00,
        true,
        NOW(),
        NOW()
    ),
    (
        5004,
        'Lặn biển khám phá',
        'ENTERTAINMENT',
        'Tour lặn biển với hướng dẫn viên',
        1750000.00,
        true,
        NOW(),
        NOW()
    ),
    -- OTHER
    (
        6001,
        'Chăm sóc thú cưng',
        'OTHER',
        'Dịch vụ chăm sóc thú cưng trong lưu trú',
        400000.00,
        true,
        NOW(),
        NOW()
    ),
    (
        6002,
        'Tổ chức sinh nhật',
        'OTHER',
        'Trang trí phòng và bánh sinh nhật',
        1200000.00,
        true,
        NOW(),
        NOW()
    ),
    (
        6003,
        'Cho thuê phòng họp',
        'OTHER',
        'Phòng họp 20 người/4 giờ',
        1800000.00,
        true,
        NOW(),
        NOW()
    );
-- =====================================================
-- 5. CUSTOMERS TABLE
-- =====================================================
-- Identity numbers are CCCD (Citizen ID)
INSERT INTO customers (id, full_name, phone, identity_number)
VALUES (
        1,
        'Trần Minh Tuấn',
        '0901234567',
        '001089012345'
    ),
    (2, 'Lê Thị Hương', '0902345678', '001190123456'),
    (3, 'Phạm Văn Hùng', '0903456789', '001291234567'),
    (
        4,
        'Nguyễn Thị Lan',
        '0904567890',
        '001392345678'
    ),
    (
        5,
        'Hoàng Quốc Anh',
        '0905678901',
        '001493456789'
    ),
    (6, 'Vũ Thị Mai', '0906789012', '001594567890'),
    (7, 'Đặng Văn Nam', '0907890123', '001695678901'),
    (
        8,
        'Bùi Thị Phương',
        '0908901234',
        '001796789012'
    ),
    (9, 'Lương Văn Sơn', '0909012345', '001897890123'),
    (
        10,
        'Trịnh Thị Thu',
        '0910123456',
        '001998901234'
    ),
    (11, 'Ngô Văn Tài', '0911234567', '002089012345'),
    (
        12,
        'Phan Thị Uyên',
        '0912345670',
        '002190123456'
    ),
    (13, 'Đỗ Văn Vinh', '0913456781', '002291234567'),
    (14, 'Mai Thị Xuân', '0914567892', '002392345678'),
    (
        15,
        'Dương Văn Yên',
        '0915678903',
        '002493456789'
    ),
    (16, 'Tạ Thị Thanh', '0916789014', '002594567890'),
    (17, 'Lý Văn Thắng', '0917890125', '002695678901'),
    (18, 'Cao Thị Ngọc', '0918901236', '002796789012'),
    (19, 'Võ Văn Minh', '0919012347', '002897890123'),
    (20, 'Hồ Thị Kim', '0920123458', '002998901234');
-- =====================================================
-- 6. BOOKINGS TABLE
-- =====================================================
-- Booking ID format: DDMMYYYY + Customer CCCD (identity_number)
-- Status: BOOKED, CHECKED_IN, CHECKED_OUT, CANCELLED
INSERT INTO bookings (
        id,
        customer_name,
        room_id,
        check_in_date,
        check_out_date,
        total_amount,
        status,
        is_overdue,
        extra_charges,
        overdue_notes
    )
VALUES -- Current occupancy (BOOKED & CHECKED_IN)
    (
        1,
        'Trần Minh Tuấn',
        102,
        '2026-01-15 14:00:00',
        '2026-01-18 12:00:00',
        3000000.00,
        'CHECKED_IN',
        false,
        0,
        NULL
    ),
    (
        2,
        'Lê Thị Hương',
        201,
        '2026-01-14 14:00:00',
        '2026-01-17 12:00:00',
        3000000.00,
        'CHECKED_IN',
        false,
        0,
        NULL
    ),
    (
        3,
        'Phạm Văn Hùng',
        302,
        '2026-01-16 14:00:00',
        '2026-01-20 12:00:00',
        6000000.00,
        'CHECKED_IN',
        false,
        0,
        NULL
    ),
    (
        4,
        'Nguyễn Thị Lan',
        403,
        '2026-01-15 14:00:00',
        '2026-01-19 12:00:00',
        6000000.00,
        'CHECKED_IN',
        false,
        0,
        NULL
    ),
    (
        5,
        'Hoàng Quốc Anh',
        502,
        '2026-01-14 14:00:00',
        '2026-01-21 12:00:00',
        21000000.00,
        'CHECKED_IN',
        false,
        0,
        NULL
    ),
    (
        6,
        'Vũ Thị Mai',
        603,
        '2026-01-16 14:00:00',
        '2026-01-18 12:00:00',
        6000000.00,
        'CHECKED_IN',
        false,
        0,
        NULL
    ),
    (
        7,
        'Đặng Văn Nam',
        702,
        '2026-01-13 14:00:00',
        '2026-01-20 12:00:00',
        35000000.00,
        'CHECKED_IN',
        false,
        0,
        NULL
    ),
    (
        8,
        'Bùi Thị Phương',
        106,
        '2026-01-17 14:00:00',
        '2026-01-19 12:00:00',
        2000000.00,
        'BOOKED',
        false,
        0,
        NULL
    ),
    (
        9,
        'Lương Văn Sơn',
        304,
        '2026-01-18 14:00:00',
        '2026-01-22 12:00:00',
        6000000.00,
        'BOOKED',
        false,
        0,
        NULL
    ),
    (
        10,
        'Trịnh Thị Thu',
        601,
        '2026-01-19 14:00:00',
        '2026-01-23 12:00:00',
        12000000.00,
        'BOOKED',
        false,
        0,
        NULL
    ),
    (
        11,
        'Ngô Văn Tài',
        704,
        '2026-01-20 14:00:00',
        '2026-01-25 12:00:00',
        25000000.00,
        'BOOKED',
        false,
        0,
        NULL
    ),
    -- Historical data (CHECKED_OUT)
    (
        12,
        'Phan Thị Uyên',
        101,
        '2026-01-08 14:00:00',
        '2026-01-11 12:00:00',
        3000000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        13,
        'Đỗ Văn Vinh',
        203,
        '2026-01-09 14:00:00',
        '2026-01-12 12:00:00',
        3000000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        14,
        'Mai Thị Xuân',
        301,
        '2026-01-10 14:00:00',
        '2026-01-13 12:00:00',
        4500000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        15,
        'Dương Văn Yên',
        402,
        '2026-01-05 14:00:00',
        '2026-01-10 12:00:00',
        7500000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        16,
        'Tạ Thị Thanh',
        501,
        '2026-01-07 14:00:00',
        '2026-01-09 12:00:00',
        6000000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        17,
        'Lý Văn Thắng',
        602,
        '2026-01-06 14:00:00',
        '2026-01-11 12:00:00',
        15000000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        18,
        'Cao Thị Ngọc',
        701,
        '2026-01-03 14:00:00',
        '2026-01-08 12:00:00',
        25000000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        19,
        'Võ Văn Minh',
        102,
        '2026-01-01 14:00:00',
        '2026-01-04 12:00:00',
        3000000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    ),
    (
        20,
        'Hồ Thị Kim',
        202,
        '2025-12-28 14:00:00',
        '2026-01-02 12:00:00',
        5000000.00,
        'CHECKED_OUT',
        false,
        0,
        NULL
    );
-- =====================================================
-- 7. INVOICES TABLE
-- =====================================================
-- Invoice ID = Booking ID
-- Only for CHECKED_OUT bookings
INSERT INTO invoices (
        id,
        booking_id,
        total_amount,
        payment_type,
        created_at
    )
VALUES (
        12,
        12,
        3000000.00,
        'CASH',
        '2026-01-11 12:30:00'
    ),
    (
        13,
        13,
        3000000.00,
        'CREDIT_CARD',
        '2026-01-12 11:45:00'
    ),
    (
        14,
        14,
        4500000.00,
        'BANK_TRANSFER',
        '2026-01-13 12:15:00'
    ),
    (
        15,
        15,
        7500000.00,
        'CREDIT_CARD',
        '2026-01-10 11:30:00'
    ),
    (
        16,
        16,
        6000000.00,
        'CASH',
        '2026-01-09 12:00:00'
    ),
    (
        17,
        17,
        15000000.00,
        'BANK_TRANSFER',
        '2026-01-11 11:50:00'
    ),
    (
        18,
        18,
        25000000.00,
        'CREDIT_CARD',
        '2026-01-08 12:20:00'
    ),
    (
        19,
        19,
        3000000.00,
        'CASH',
        '2026-01-04 11:40:00'
    ),
    (
        20,
        20,
        5000000.00,
        'CREDIT_CARD',
        '2026-01-02 12:10:00'
    );
-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================
-- SELECT COUNT(*) as total_users FROM users;
-- SELECT role, COUNT(*) as count FROM users GROUP BY role;
-- SELECT COUNT(*) as total_services FROM services;
-- SELECT COUNT(*) as total_rooms FROM rooms;
-- SELECT type, COUNT(*) as count FROM rooms GROUP BY type;
-- SELECT status, COUNT(*) as count FROM rooms GROUP BY status;
-- SELECT COUNT(*) as total_customers FROM customers;
-- SELECT COUNT(*) as total_bookings FROM bookings;
-- SELECT status, COUNT(*) as count FROM bookings GROUP BY status;
-- SELECT COUNT(*) as total_invoices FROM invoices;
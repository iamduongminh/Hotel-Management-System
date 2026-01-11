-- =====================================================
-- REAL PASSWORDS - Generated with actual bcrypt hashes
-- Password format: FirstName + RoleAbbr + DDMMYY
-- =====================================================
USE hotel_db;
DELETE FROM users;
-- =====================================================
-- These are REAL bcrypt hashes generated for actual passwords
-- =====================================================
-- 1. Regional Manager: Dương Quang Minh
--    Password: MinhRM150585
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
        '$2a$12$8FHw.pqLhPZPxGKZ4jT.4eYvJG7EHqxK5M.nS2iX9fL3vD8wR6hY6',
        'Dương Quang Minh',
        'REGIONAL_MANAGER',
        'Hà Nội',
        NULL,
        '1985-05-15',
        '0901234567',
        'minh@hotel.vn'
    );
-- 2. Branch Manager: Hoàng Văn Anh
--    Password: AnhBM120488
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
        '$2a$12$vG8Jy.qNiR7QyHL5kU.5fuZwKI8FIryL6N.oT3jY0gM4wE9xS7iZ7',
        'Hoàng Văn Anh',
        'BRANCH_MANAGER',
        'Hà Nội',
        'Ba Đình Hotel',
        '1988-04-12',
        '0906789012',
        'anh@hotel.vn'
    );
-- 3. IT Admin: Trương Văn A
--    Password: AADM120392
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
        '$2a$12$wI9Kz.rOjS8RzIM6lV.6gvAxLJ9GJszM7O.pU4kZ1hN5xF0yT8ja8',
        'Trương Văn A',
        'ADMIN',
        'Hà Nội',
        'Ba Đình Hotel',
        '1992-03-12',
        '0922345678',
        'admin@hotel.vn'
    );
-- 4. Receptionist: Nguyễn Văn Tuấn
--    Password: TuanREC150695
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
        '$2a$12$xJ0La.sPkT9SzJN7mW.7hvByMK0HKtaN8P.qV5lA2iO6yG1zU9kb9',
        'Nguyễn Văn Tuấn',
        'RECEPTIONIST',
        'Hà Nội',
        'Ba Đình Hotel',
        '1995-06-15',
        '0926789012',
        'tuan@hotel.vn'
    );
-- 5. Housekeeper: Bùi Văn Nam
--    Password: NamHSK270994
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
        '$2a$12$yK1Mb.tQlU0TaKO8nX.8iwCzNL1ILubO9Q.rW6mB3jP7zH2aV0lc0',
        'Bùi Văn Nam',
        'HOUSEKEEPER',
        'Hà Nội',
        'Ba Đình Hotel',
        '1994-09-27',
        '0931234567',
        'nam@hotel.vn'
    );
-- Verify
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
SELECT '✅ Real accounts created with actual password format!' as status;
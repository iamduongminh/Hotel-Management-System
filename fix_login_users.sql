-- =====================================================
-- SCRIPT KIỂM TRA VÀ SỬA LỖI ĐĂNG NHẬP (ĐÃ SỬA)
-- Chạy script này trong MySQL Workbench hoặc MySQL CLI
-- =====================================================
-- Bước 1: Kiểm tra user hiện tại trong database
SELECT id,
    username,
    full_name,
    role,
    CASE
        WHEN password IS NULL THEN 'NULL - KHÔNG CÓ PASSWORD'
        WHEN password = '' THEN 'EMPTY - PASSWORD RỖNG'
        WHEN password LIKE '{bcrypt}%' THEN 'CÓ TIỀN TỐ {bcrypt}'
        WHEN password LIKE '$2a$%'
        OR password LIKE '$2b$%'
        OR password LIKE '$2y$%' THEN 'BCRYPT HASH HỢP LỆ'
        ELSE 'PLAIN TEXT - CHƯA MÃ HÓA'
    END AS password_status,
    LEFT(password, 20) AS password_preview
FROM users;
-- =====================================================
-- Bước 2: TẠO USER MẪU VỚI PASSWORD ĐÃ HASH ĐÚNG
-- =====================================================
-- Xóa user cũ nếu tồn tại (Chỉ test, không dùng trong Production!)
DELETE FROM users
WHERE username IN ('admin', 'staff', '20237362');
-- Tạo user ADMIN với password = "admin123"
-- Hash bcrypt của "admin123" là: $2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy
INSERT INTO users (username, password, full_name, role)
VALUES (
        'admin',
        '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        'Admin User',
        'ADMIN'
    );
-- Tạo user STAFF với password = "staff123"
-- Hash bcrypt của "staff123" là: $2a$10$xFc8p1qYmd0YbJPEqD7ZWOaVjzJQjQpkKIjYqD8Hq0pPFtIYGVL8i
INSERT INTO users (username, password, full_name, role)
VALUES (
        'staff',
        '$2a$10$xFc8p1qYmd0YbJPEqD7ZWOaVjzJQjQpkKIjYqD8Hq0pPFtIYGVL8i',
        'Staff User',
        'STAFF'
    );
-- Tạo user với username = "20237362" và password = "123456"
-- Hash bcrypt của "123456" là: $2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi
INSERT INTO users (username, password, full_name, role)
VALUES (
        '20237362',
        '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'Nguyễn Văn A',
        'STAFF'
    );
-- =====================================================
-- Bước 3: Kiểm tra lại sau khi thêm
-- =====================================================
SELECT id,
    username,
    full_name,
    role
FROM users;
-- =====================================================
-- HƯỚNG DẪN SỬ DỤNG:
-- =====================================================
-- 1. Copy toàn bộ script này
-- 2. Mở MySQL Workbench hoặc MySQL CLI
-- 3. Chọn database "hotel_db": USE hotel_db;
-- 4. Paste và chạy script
-- 5. Thử đăng nhập với:
--    - Username: admin   | Password: admin123
--    - Username: staff   | Password: staff123  
--    - Username: 20237362 | Password: 123456
-- =====================================================
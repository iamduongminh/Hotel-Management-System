-- =====================================================
-- UPDATE PASSWORD VỚI BCRYPT HASH ĐÚNG
-- =====================================================
-- Update user admin với password = "admin123"
UPDATE users
SET password = '$2a$10$kuaAbKxDcdjBSlnGHxhzgO5.THBdHVrDHnlPiIwddKboGN/dVM1Mq'
WHERE username = 'admin';
-- Update user staff với password = "staff123"
UPDATE users
SET password = '$2a$10$YWfsH4r5I7.P9jcyYesi0OvPZG43OsE9326J007LulckkJgTvBPUO'
WHERE username = 'staff';
-- Update user 20237362 với password = "123456"
UPDATE users
SET password = '$2a$10$M73XesyFW4iHdZ3Yul1sgecbAQmYrUgTmZeBfYYlBXOYGdPZgQU.W'
WHERE username = '20237362';
-- Kiểm tra lại
SELECT id,
    username,
    full_name,
    role,
    LEFT(password, 25) AS password_hash
FROM users
WHERE username IN ('admin', 'staff', '20237362');
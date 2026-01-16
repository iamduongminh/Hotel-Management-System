-- =====================================================
-- ADD SERVICES AND ROOM_CATEGORIES TABLES
-- Run this script to add new tables to existing hotel_db
-- =====================================================
USE hotel_db;
-- Create services table
CREATE TABLE IF NOT EXISTS services (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(19, 2) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    city VARCHAR(100) NOT NULL,
    branch_name VARCHAR(100) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_branch (branch_name),
    INDEX idx_city_branch (city, branch_name)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
-- Create room_categories table
CREATE TABLE IF NOT EXISTS room_categories (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    base_price DECIMAL(19, 2) NOT NULL,
    capacity INT NOT NULL DEFAULT 2,
    amenities TEXT,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    city VARCHAR(100) NOT NULL,
    branch_name VARCHAR(100) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_branch (branch_name),
    INDEX idx_city_branch (city, branch_name)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
-- Insert sample data for Ba Đình Hotel (HN01)
INSERT INTO services (
        name,
        description,
        price,
        active,
        city,
        branch_name
    )
VALUES (
        'Giặt ủi',
        'Dịch vụ giặt ủi quần áo theo kg',
        50000.00,
        TRUE,
        'Hà Nội',
        'Ba Đình Hotel'
    ),
    (
        'Spa & Massage',
        'Dịch vụ spa và massage thư giãn',
        300000.00,
        TRUE,
        'Hà Nội',
        'Ba Đình Hotel'
    ),
    (
        'Đưa đón sân bay',
        'Dịch vụ đón tiễn khách tại sân bay Nội Bài',
        500000.00,
        TRUE,
        'Hà Nội',
        'Ba Đình Hotel'
    ),
    (
        'Nhà hàng',
        'Dịch vụ ăn uống tại nhà hàng khách sạn',
        150000.00,
        TRUE,
        'Hà Nội',
        'Ba Đình Hotel'
    );
INSERT INTO room_categories (
        name,
        description,
        base_price,
        capacity,
        amenities,
        active,
        city,
        branch_name
    )
VALUES (
        'Phòng Standard Tầng 1',
        'Phòng tiêu chuẩn nằm tầng 1, view nội khu',
        500000.00,
        2,
        'WiFi miễn phí, Điều hòa, Tivi, Minibar',
        TRUE,
        'Hà Nội',
        'Ba Đình Hotel'
    ),
    (
        'Phòng Deluxe Tầng cao',
        'Phòng cao cấp tầng cao, view thành phố',
        1200000.00,
        2,
        'WiFi miễn phí, Điều hòa, Smart TV, Minibar, Ban công',
        TRUE,
        'Hà Nội',
        'Ba Đình Hotel'
    ),
    (
        'Suite Tầng VIP',
        'Phòng suite cao cấp với không gian rộng rãi',
        2500000.00,
        4,
        'WiFi miễn phí, Điều hòa, Smart TV, Minibar, Ban công, Bồn tắm nằm, Phòng khách riêng',
        TRUE,
        'Hà Nội',
        'Ba Đình Hotel'
    );
-- Insert sample data for Cầu Giấy Hotel (HN02)
INSERT INTO services (
        name,
        description,
        price,
        active,
        city,
        branch_name
    )
VALUES (
        'Giặt là cao cấp',
        'Dịch vụ giặt là chuyên nghiệp',
        70000.00,
        TRUE,
        'Hà Nội',
        'Cầu Giấy Hotel'
    ),
    (
        'Phòng gym',
        'Sử dụng phòng tập gym hiện đại',
        100000.00,
        TRUE,
        'Hà Nội',
        'Cầu Giấy Hotel'
    ),
    (
        'Thuê xe',
        'Dịch vụ thuê xe theo ngày',
        800000.00,
        TRUE,
        'Hà Nội',
        'Cầu Giấy Hotel'
    );
INSERT INTO room_categories (
        name,
        description,
        base_price,
        capacity,
        amenities,
        active,
        city,
        branch_name
    )
VALUES (
        'Phòng Standard',
        'Phòng tiêu chuẩn 2 người',
        600000.00,
        2,
        'WiFi, Điều hòa, Tivi',
        TRUE,
        'Hà Nội',
        'Cầu Giấy Hotel'
    ),
    (
        'Phòng Family',
        'Phòng gia đình rộng rãi',
        1500000.00,
        4,
        'WiFi, Điều hòa, Smart TV, Tủ lạnh, 2 giường đôi',
        TRUE,
        'Hà Nội',
        'Cầu Giấy Hotel'
    );
SELECT 'Tables created and sample data inserted successfully!' AS status;
package com.hotel_management.api.core.domain.enums;

public enum UserRole {
    // Management Hierarchy
    REGIONAL_MANAGER, // Lãnh đạo cấp khu vực (quản lý nhiều chi nhánh trong thành phố)
    BRANCH_MANAGER, // Quản lý chi nhánh (quản lý 1 khách sạn)

    // IT/System Administration
    ADMIN, // Quản trị viên hệ thống (IT, công nghệ)

    // Operational Staff
    RECEPTIONIST, // Lễ tân
    HOUSEKEEPER // Nhân viên dọn phòng
}
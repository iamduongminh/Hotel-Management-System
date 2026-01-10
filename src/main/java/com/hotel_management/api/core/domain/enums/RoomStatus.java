package com.hotel_management.api.core.domain.enums;

public enum RoomStatus {
    AVAILABLE,
    BOOKED, // Phòng đã được đặt nhưng chưa check-in
    OCCUPIED, // Phòng đang có khách
    DIRTY, // Phòng cần dọn dẹp
    MAINTENANCE // Phòng đang bảo trì
}
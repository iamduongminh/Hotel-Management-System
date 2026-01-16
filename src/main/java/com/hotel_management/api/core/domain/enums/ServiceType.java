package com.hotel_management.api.core.domain.enums;

public enum ServiceType {
    FOOD_BEVERAGE("Ẩm thực"),
    LAUNDRY("Giặt ủi"),
    SPA_WELLNESS("Spa & Sức khỏe"),
    TRANSPORTATION("Di chuyển"),
    ENTERTAINMENT("Giải trí"),
    OTHER("Khác");

    private final String description;

    ServiceType(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}

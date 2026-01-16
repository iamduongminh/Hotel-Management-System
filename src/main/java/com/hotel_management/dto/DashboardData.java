package com.hotel_management.dto;

import lombok.Data;

@Data
public class DashboardData {
    private int totalRooms;
    private int occupiedRooms;
    private Double dailyRevenue;
    private int checkInsToday;
    private int checkOutsToday;
}

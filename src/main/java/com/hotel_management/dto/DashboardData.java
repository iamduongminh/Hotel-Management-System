package com.hotel_management.dto;

public class DashboardData {
    private Double dailyRevenue;
    private Integer occupiedRooms;
    private Integer totalRooms;
    private Integer checkInsToday;
    private Integer checkOutsToday;
    private Integer pendingApprovals;

    // Constructors
    public DashboardData() {
    }

    public DashboardData(Double dailyRevenue, Integer occupiedRooms, Integer totalRooms) {
        this.dailyRevenue = dailyRevenue;
        this.occupiedRooms = occupiedRooms;
        this.totalRooms = totalRooms;
    }

    // Getters and Setters
    public Double getDailyRevenue() {
        return dailyRevenue;
    }

    public void setDailyRevenue(Double dailyRevenue) {
        this.dailyRevenue = dailyRevenue;
    }

    public Integer getOccupiedRooms() {
        return occupiedRooms;
    }

    public void setOccupiedRooms(Integer occupiedRooms) {
        this.occupiedRooms = occupiedRooms;
    }

    public Integer getTotalRooms() {
        return totalRooms;
    }

    public void setTotalRooms(Integer totalRooms) {
        this.totalRooms = totalRooms;
    }

    public Integer getCheckInsToday() {
        return checkInsToday;
    }

    public void setCheckInsToday(Integer checkInsToday) {
        this.checkInsToday = checkInsToday;
    }

    public Integer getCheckOutsToday() {
        return checkOutsToday;
    }

    public void setCheckOutsToday(Integer checkOutsToday) {
        this.checkOutsToday = checkOutsToday;
    }

    public Integer getPendingApprovals() {
        return pendingApprovals;
    }

    public void setPendingApprovals(Integer pendingApprovals) {
        this.pendingApprovals = pendingApprovals;
    }
}

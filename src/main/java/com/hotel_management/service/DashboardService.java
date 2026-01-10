package com.hotel_management.service;

import com.hotel_management.api.core.domain.enums.RoomStatus;
import com.hotel_management.dto.DashboardData;
import com.hotel_management.repository.RoomRepository;
import org.springframework.stereotype.Service;

@Service
public class DashboardService {
    private final RoomRepository roomRepository;

    public DashboardService(RoomRepository roomRepository) {
        this.roomRepository = roomRepository;
    }

    public DashboardData getDashboardMetrics() {
        DashboardData data = new DashboardData();

        // Tính toán metrics (giả lập - thực tế cần query database)
        long totalRooms = roomRepository.count();
        long occupiedRooms = roomRepository.countByStatus(RoomStatus.OCCUPIED);

        data.setTotalRooms((int) totalRooms);
        data.setOccupiedRooms((int) occupiedRooms);
        data.setDailyRevenue(5000000.0); // TODO: Tính từ bookings hôm nay
        data.setCheckInsToday(3); // TODO: Query bookings checked in today
        data.setCheckOutsToday(2); // TODO: Query bookings checked out today
        data.setPendingApprovals(1); // TODO: Query pending approvals

        return data;
    }
}

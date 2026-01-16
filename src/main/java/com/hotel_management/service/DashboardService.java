package com.hotel_management.service;

import com.hotel_management.dto.DashboardData;
import com.hotel_management.repository.BookingRepository;
import com.hotel_management.repository.RoomRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Service
public class DashboardService {
    private final RoomRepository roomRepository;
    private final BookingRepository bookingRepository;

    public DashboardService(RoomRepository roomRepository, BookingRepository bookingRepository) {
        this.roomRepository = roomRepository;
        this.bookingRepository = bookingRepository;
    }

    public DashboardData getDashboardMetrics() {
        DashboardData data = new DashboardData();

        // Get today's range
        LocalDate today = LocalDate.now();
        LocalDateTime startOfDay = today.atStartOfDay();
        LocalDateTime endOfDay = today.atTime(LocalTime.MAX);

        // Calculate room metrics
        long totalRooms = roomRepository.count();
        long occupiedRooms = bookingRepository.countByStatus("CHECKED_IN");

        // Calculate booking metrics
        Double dailyRevenue = bookingRepository.sumDailyRevenue(startOfDay, endOfDay);
        long checkInsToday = bookingRepository.countCheckInsToday(startOfDay, endOfDay);
        long checkOutsToday = bookingRepository.countCheckOutsToday(startOfDay, endOfDay);

        data.setTotalRooms((int) totalRooms);
        data.setOccupiedRooms((int) occupiedRooms);
        data.setDailyRevenue(dailyRevenue);
        data.setCheckInsToday((int) checkInsToday);
        data.setCheckOutsToday((int) checkOutsToday);

        return data;
    }
}

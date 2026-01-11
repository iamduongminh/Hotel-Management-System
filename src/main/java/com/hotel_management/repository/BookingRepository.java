package com.hotel_management.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.hotel_management.api.core.domain.entity.Booking;

import java.time.LocalDateTime;

public interface BookingRepository extends JpaRepository<Booking, Long> {

    // Count bookings that checked in today
    @Query("SELECT COUNT(b) FROM Booking b WHERE b.checkInDate >= :startOfDay AND b.checkInDate < :endOfDay AND b.status = 'CHECKED_IN'")
    long countCheckInsToday(@Param("startOfDay") LocalDateTime startOfDay, @Param("endOfDay") LocalDateTime endOfDay);

    // Count bookings that checked out today
    @Query("SELECT COUNT(b) FROM Booking b WHERE b.checkOutDate >= :startOfDay AND b.checkOutDate < :endOfDay AND b.status = 'CHECKED_OUT'")
    long countCheckOutsToday(@Param("startOfDay") LocalDateTime startOfDay, @Param("endOfDay") LocalDateTime endOfDay);

    // Count bookings with BOOKED status (pending approvals)
    long countByStatus(String status);

    // Sum total amount for today's bookings (revenue from bookings made today)
    @Query("SELECT COALESCE(SUM(b.totalAmount), 0.0) FROM Booking b WHERE b.checkInDate >= :startOfDay AND b.checkInDate < :endOfDay")
    Double sumDailyRevenue(@Param("startOfDay") LocalDateTime startOfDay, @Param("endOfDay") LocalDateTime endOfDay);
}
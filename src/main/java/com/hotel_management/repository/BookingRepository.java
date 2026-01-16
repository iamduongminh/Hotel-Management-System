package com.hotel_management.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.hotel_management.api.core.domain.entity.Booking;

import java.time.LocalDateTime;

public interface BookingRepository extends JpaRepository<Booking, Long> {

        // Count bookings that checked in today
        @Query("SELECT COUNT(b) FROM Booking b WHERE b.checkInDate >= :startOfDay AND b.checkInDate < :endOfDay AND b.status = 'CHECKED_IN'")
        long countCheckInsToday(@Param("startOfDay") LocalDateTime startOfDay,
                        @Param("endOfDay") LocalDateTime endOfDay);

        // Count bookings that checked out today
        @Query("SELECT COUNT(b) FROM Booking b WHERE b.checkOutDate >= :startOfDay AND b.checkOutDate < :endOfDay AND b.status = 'CHECKED_OUT'")
        long countCheckOutsToday(@Param("startOfDay") LocalDateTime startOfDay,
                        @Param("endOfDay") LocalDateTime endOfDay);

        // Count bookings with BOOKED status (pending approvals)
        long countByStatus(String status);

        // Sum total amount for today's bookings (revenue from bookings made today)
        @Query("SELECT COALESCE(SUM(b.totalAmount), 0.0) FROM Booking b WHERE b.checkInDate >= :startOfDay AND b.checkInDate < :endOfDay")
        Double sumDailyRevenue(@Param("startOfDay") LocalDateTime startOfDay,
                        @Param("endOfDay") LocalDateTime endOfDay);

        // Find active bookings (OCCUPIED or BOOKED) to calculate room status
        // dynamically
        @Query("SELECT b FROM Booking b WHERE b.status IN ('BOOKED', 'CHECKED_IN')")
        java.util.List<Booking> findActiveBookings();

        // Find today's check-ins (bookings scheduled to check in today)
        @Query("SELECT b FROM Booking b WHERE b.status = 'BOOKED' " +
                        "AND DATE(b.checkInDate) = CURRENT_DATE " +
                        "ORDER BY b.checkInDate ASC")
        java.util.List<Booking> findTodayCheckIns();

        // Find today's check-outs (bookings scheduled to check out today)
        @Query("SELECT b FROM Booking b WHERE b.status = 'CHECKED_IN' " +
                        "AND DATE(b.checkOutDate) = CURRENT_DATE " +
                        "ORDER BY b.checkOutDate ASC")
        java.util.List<Booking> findTodayCheckOuts();

        // Find current stays ordered by check-out date (nearest first)
        @Query("SELECT b FROM Booking b WHERE b.status = 'CHECKED_IN' " +
                        "ORDER BY b.isOverdue DESC, b.checkOutDate ASC")
        java.util.List<Booking> findCurrentStaysOrderedByCheckOut();

        // Find booking history (checked out and cancelled)
        @Query("SELECT b FROM Booking b WHERE b.status IN ('CHECKED_OUT', 'CANCELLED') " +
                        "ORDER BY b.checkOutDate DESC")
        java.util.List<Booking> findBookingHistory();

        // Find bookings to auto-cancel (not checked in after 1 day)
        @Query("SELECT b FROM Booking b WHERE b.status = 'BOOKED' " +
                        "AND b.checkInDate < :cutoffDate")
        java.util.List<Booking> findBookingsToAutoCancel(@Param("cutoffDate") LocalDateTime cutoffDate);

        // Find overdue check-outs
        @Query("SELECT b FROM Booking b WHERE b.status = 'CHECKED_IN' " +
                        "AND b.checkOutDate < :currentDate " +
                        "AND b.isOverdue = false")
        java.util.List<Booking> findOverdueCheckOuts(@Param("currentDate") LocalDateTime currentDate);
}
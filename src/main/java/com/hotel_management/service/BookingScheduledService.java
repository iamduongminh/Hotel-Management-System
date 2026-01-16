package com.hotel_management.service;

import com.hotel_management.api.core.domain.entity.Booking;
import com.hotel_management.repository.BookingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;

/**
 * Scheduled service for automatic booking management
 * Runs daily to handle auto-cancellations and overdue check-outs
 */
@Service
public class BookingScheduledService {

    @Autowired
    private BookingRepository bookingRepository;

    private static final BigDecimal OVERDUE_CHARGE_PER_DAY = new BigDecimal("200000"); // 200k VND per day

    /**
     * Runs daily at midnight to process bookings
     * - Auto-cancel bookings not checked in after 1 day
     * - Flag overdue check-outs and calculate extra charges
     */
    @Scheduled(cron = "0 0 0 * * *") // Run at midnight every day
    @Transactional
    public void processBookings() {
        autoCancelNoShowBookings();
        flagOverdueCheckOuts();
    }

    /**
     * Auto-cancel bookings that were not checked in after 1 day
     */
    private void autoCancelNoShowBookings() {
        LocalDateTime cutoffDate = LocalDateTime.now().minusDays(1);
        List<Booking> bookingsToCancel = bookingRepository.findBookingsToAutoCancel(cutoffDate);

        for (Booking booking : bookingsToCancel) {
            booking.setStatus("CANCELLED");
            booking.setOverdueNotes("Auto-cancelled: No-show after 1 day");
            bookingRepository.save(booking);
        }

        if (!bookingsToCancel.isEmpty()) {
            System.out.println("Auto-cancelled " + bookingsToCancel.size() + " no-show bookings");
        }
    }

    /**
     * Flag overdue check-outs and calculate extra charges
     */
    private void flagOverdueCheckOuts() {
        LocalDateTime now = LocalDateTime.now();
        List<Booking> overdueBookings = bookingRepository.findOverdueCheckOuts(now);

        for (Booking booking : overdueBookings) {
            booking.setIsOverdue(true);

            // Calculate days overdue
            long daysOverdue = ChronoUnit.DAYS.between(booking.getCheckOutDate(), now);
            BigDecimal extraCharge = OVERDUE_CHARGE_PER_DAY.multiply(new BigDecimal(daysOverdue));

            booking.setExtraCharges(extraCharge);
            booking.setOverdueNotes("Overdue by " + daysOverdue + " day(s). Extra charge: " + extraCharge + " VND");

            bookingRepository.save(booking);
        }

        if (!overdueBookings.isEmpty()) {
            System.out.println("Flagged " + overdueBookings.size() + " overdue check-outs");
        }
    }
}

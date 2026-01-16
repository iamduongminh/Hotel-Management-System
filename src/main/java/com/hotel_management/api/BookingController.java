package com.hotel_management.api;

import com.hotel_management.api.core.domain.entity.Booking;
import com.hotel_management.dto.BookingRequest;
import com.hotel_management.service.BookingService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/bookings")
public class BookingController {
    private final BookingService bookingService;

    public BookingController(BookingService bookingService) {
        this.bookingService = bookingService;
    }

    @GetMapping
    public ResponseEntity<List<Booking>> getAllBookings() {
        return ResponseEntity.ok(bookingService.getAllBookings());
    }

    @PostMapping
    public ResponseEntity<Booking> create(@RequestBody BookingRequest req) {
        return ResponseEntity.ok(bookingService.createBooking(req));
    }

    /**
     * Get today's check-ins
     */
    @GetMapping("/today/check-ins")
    public ResponseEntity<List<Booking>> getTodayCheckIns(jakarta.servlet.http.HttpSession session) {
        com.hotel_management.api.core.domain.entity.User currentUser = (com.hotel_management.api.core.domain.entity.User) session
                .getAttribute("currentUser");

        if (currentUser == null) {
            return ResponseEntity.status(401).build();
        }

        return ResponseEntity.ok(bookingService.getTodayCheckIns());
    }

    /**
     * Get today's check-outs
     */
    @GetMapping("/today/check-outs")
    public ResponseEntity<List<Booking>> getTodayCheckOuts(jakarta.servlet.http.HttpSession session) {
        com.hotel_management.api.core.domain.entity.User currentUser = (com.hotel_management.api.core.domain.entity.User) session
                .getAttribute("currentUser");

        if (currentUser == null) {
            return ResponseEntity.status(401).build();
        }

        return ResponseEntity.ok(bookingService.getTodayCheckOuts());
    }

    /**
     * Get current stays ordered by check-out date (overdue first)
     */
    @GetMapping("/current-stays")
    public ResponseEntity<List<Booking>> getCurrentStays(jakarta.servlet.http.HttpSession session) {
        com.hotel_management.api.core.domain.entity.User currentUser = (com.hotel_management.api.core.domain.entity.User) session
                .getAttribute("currentUser");

        if (currentUser == null) {
            return ResponseEntity.status(401).build();
        }

        return ResponseEntity.ok(bookingService.getCurrentStays());
    }

    /**
     * Get booking history (checked out and cancelled)
     */
    @GetMapping("/history")
    public ResponseEntity<List<Booking>> getBookingHistory(jakarta.servlet.http.HttpSession session) {
        com.hotel_management.api.core.domain.entity.User currentUser = (com.hotel_management.api.core.domain.entity.User) session
                .getAttribute("currentUser");

        if (currentUser == null) {
            return ResponseEntity.status(401).build();
        }

        return ResponseEntity.ok(bookingService.getBookingHistory());
    }

    /**
     * Check in a booking
     */
    @PostMapping("/{id}/check-in")
    public ResponseEntity<Booking> checkIn(@PathVariable Long id) {
        return ResponseEntity.ok(bookingService.checkIn(id));
    }

    /**
     * Check out a booking (handles overdue charges)
     */
    @PostMapping("/{id}/check-out")
    public ResponseEntity<Booking> checkOut(@PathVariable Long id) {
        return ResponseEntity.ok(bookingService.checkOut(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Booking> updateBooking(@PathVariable Long id, @RequestBody BookingRequest req) {
        return ResponseEntity.ok(bookingService.updateBooking(id, req));
    }
}
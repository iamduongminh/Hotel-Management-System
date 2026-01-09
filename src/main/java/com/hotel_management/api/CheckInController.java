package com.hotel_management.api;

import com.hotel_management.api.core.domain.entity.Booking;
import com.hotel_management.service.BookingService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/checkin")
public class CheckInController {
    private final BookingService bookingService;

    public CheckInController(BookingService bookingService) {
        this.bookingService = bookingService;
    }

    @PostMapping("/{bookingId}")
    public ResponseEntity<Booking> checkIn(@PathVariable Long bookingId) {
        Booking updatedBooking = bookingService.checkIn(bookingId);
        return ResponseEntity.ok(updatedBooking);
    }
}
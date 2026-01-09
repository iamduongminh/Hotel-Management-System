package com.hotel_management.api;

import com.hotel_management.api.core.domain.entity.Booking;
import com.hotel_management.dto.BookingRequest;
import com.hotel_management.service.BookingService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/bookings")
public class BookingController {
    private final BookingService bookingService;

    public BookingController(BookingService bookingService) {
        this.bookingService = bookingService;
    }

    @PostMapping
    public ResponseEntity<Booking> create(@RequestBody BookingRequest req) {
        // Lưu ý: Bạn cần cập nhật BookingService để có hàm createBooking nhận các tham số này
        // Hoặc truyền thẳng BookingRequest vào service
        return ResponseEntity.ok(bookingService.createBooking(req));
    }
}
package com.hotel_management.service;

import com.hotel_management.api.core.domain.entity.Booking;
import com.hotel_management.api.core.domain.enums.BookingStatus;
import com.hotel_management.dto.BookingRequest;
import com.hotel_management.repository.BookingRepository;
import com.hotel_management.repository.RoomRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;

@Service
@Transactional
public class BookingService {

    private final BookingRepository bookingRepository;
    private final RoomRepository roomRepository;

    public BookingService(BookingRepository bookingRepository, RoomRepository roomRepository) {
        this.bookingRepository = bookingRepository;
        this.roomRepository = roomRepository;
    }

    public List<Booking> getAllBookings() {
        return bookingRepository.findAll();
    }

    public Booking createBooking(BookingRequest req) {
        Booking booking = new Booking();
        booking.setCustomerName(req.getCustomerName());
        booking.setCustomerPhone(req.getCustomerPhone());
        booking.setIdentityCard(req.getIdentityCard());

        if (req.getRoomId() == null) {
            throw new IllegalArgumentException("Room ID cannot be null");
        }
        booking.setRoom(roomRepository.findById(req.getRoomId())
                .orElseThrow(() -> new RuntimeException("Room not found")));
        booking.setCheckInDate(req.getCheckInDate());
        booking.setCheckOutDate(req.getCheckOutDate());

        // Use totalAmount from request or calculate it (fallback to 0 if null)
        booking.setTotalAmount(req.getTotalAmount() != null ? req.getTotalAmount() : 0.0);

        // Status is String in Entity, pass Enum.name()
        booking.setStatus(BookingStatus.BOOKED.name());
        booking.setIsOverdue(false);
        booking.setExtraCharges(BigDecimal.ZERO);
        return bookingRepository.save(booking);
    }

    public List<Booking> getTodayCheckIns() {
        return bookingRepository.findTodayCheckIns();
    }

    public List<Booking> getTodayCheckOuts() {
        return bookingRepository.findTodayCheckOuts();
    }

    public List<Booking> getCurrentStays() {
        return bookingRepository.findCurrentStaysOrderedByCheckOut();
    }

    public List<Booking> getBookingHistory() {
        return bookingRepository.findBookingHistory();
    }

    public Booking checkIn(Long id) {
        Objects.requireNonNull(id, "Booking ID cannot be null");
        Booking booking = bookingRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Booking not found"));
        // Status is String
        booking.setStatus(BookingStatus.CHECKED_IN.name());
        return bookingRepository.save(booking);
    }

    public Booking checkOut(Long id) {
        Objects.requireNonNull(id, "Booking ID cannot be null");
        Booking booking = bookingRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Booking not found"));

        LocalDateTime now = LocalDateTime.now();
        if (now.isAfter(booking.getCheckOutDate())) {
            booking.setIsOverdue(true);
        }

        booking.setStatus(BookingStatus.CHECKED_OUT.name());
        return bookingRepository.save(booking);
    }

    public Booking updateBooking(Long id, BookingRequest req) {
        Objects.requireNonNull(id, "Booking ID cannot be null");
        Booking booking = bookingRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Booking not found"));

        booking.setCustomerName(req.getCustomerName());
        booking.setCustomerPhone(req.getCustomerPhone());
        booking.setIdentityCard(req.getIdentityCard());
        if (req.getRoomId() != null) {
            Long roomId = req.getRoomId();
            booking.setRoom(roomRepository.findById(roomId)
                    .orElseThrow(() -> new RuntimeException("Room not found")));
        }
        booking.setCheckInDate(req.getCheckInDate());
        booking.setCheckOutDate(req.getCheckOutDate());
        if (req.getTotalAmount() != null) {
            booking.setTotalAmount(req.getTotalAmount());
        }

        return bookingRepository.save(booking);
    }
}

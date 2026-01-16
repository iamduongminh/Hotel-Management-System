package com.hotel_management.service;

import com.hotel_management.api.core.domain.entity.Booking;
import com.hotel_management.api.core.domain.entity.Room;
import com.hotel_management.api.core.domain.enums.BookingStatus;
import com.hotel_management.api.core.domain.enums.RoomStatus;
import com.hotel_management.dto.BookingRequest;
import com.hotel_management.repository.BookingRepository;
import com.hotel_management.repository.RoomRepository;
import org.springframework.stereotype.Service;
import jakarta.persistence.EntityNotFoundException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects; // Import thêm cái này để check null xịn hơn

@Service
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

    public Booking createBooking(BookingRequest request) {
        Long roomId = request.getRoomId();

        if (roomId == null) {
            throw new IllegalArgumentException("Room ID cannot be null");
        }

        // Lúc này 'roomId' được coi là @NonNull an toàn
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new EntityNotFoundException("Room not found with ID: " + roomId));

        Booking booking = new Booking();
        booking.setCustomerName(request.getCustomerName());
        booking.setRoom(room);
        booking.setCheckInDate(request.getCheckInDate());
        booking.setCheckOutDate(request.getCheckOutDate());
        booking.setStatus(BookingStatus.BOOKED.name());
        booking.setTotalAmount(0.0);

        room.setStatus(RoomStatus.OCCUPIED);
        roomRepository.save(room);
        return bookingRepository.save(booking);
    }

    public Booking checkIn(Long bookingId) {

        Long safeId = Objects.requireNonNull(bookingId, "Booking ID cannot be null");

        // 1. Tìm booking với safeId
        Booking booking = bookingRepository.findById(safeId)
                .orElseThrow(() -> new EntityNotFoundException("Booking not found with ID: " + safeId));

        // 2. Cập nhật trạng thái
        booking.setStatus(BookingStatus.CHECKED_IN.name());
        booking.setCheckInDate(LocalDateTime.now());

        // 3. Lưu lại
        return bookingRepository.save(booking);
    }

    /**
     * Get bookings scheduled to check in today for a specific branch
     */
    public List<Booking> getTodayCheckIns(String branchName) {
        return bookingRepository.findTodayCheckIns(branchName);
    }

    /**
     * Get bookings scheduled to check out today for a specific branch
     */
    public List<Booking> getTodayCheckOuts(String branchName) {
        return bookingRepository.findTodayCheckOuts(branchName);
    }

    /**
     * Get current stays ordered by check-out date (overdue first, then nearest)
     */
    public List<Booking> getCurrentStays(String branchName) {
        return bookingRepository.findCurrentStaysOrderedByCheckOut(branchName);
    }

    /**
     * Get booking history (checked out and cancelled)
     */
    public List<Booking> getBookingHistory(String branchName) {
        return bookingRepository.findBookingHistory(branchName);
    }

    /**
     * Check out a booking with overdue charge handling
     */
    public Booking checkOut(Long bookingId) {
        Long safeId = Objects.requireNonNull(bookingId, "Booking ID cannot be null");

        Booking booking = bookingRepository.findById(safeId)
                .orElseThrow(() -> new EntityNotFoundException("Booking not found with ID: " + safeId));

        // Update status
        booking.setStatus(BookingStatus.CHECKED_OUT.name());
        booking.setCheckOutDate(LocalDateTime.now());

        // If overdue, add extra charges to total amount
        if (booking.getIsOverdue() && booking.getExtraCharges() != null) {
            double currentTotal = booking.getTotalAmount() != null ? booking.getTotalAmount() : 0.0;
            double extraCharges = booking.getExtraCharges().doubleValue();
            booking.setTotalAmount(currentTotal + extraCharges);
        }

        // Update room status to available
        Room room = booking.getRoom();
        if (room != null) {
            room.setStatus(RoomStatus.AVAILABLE);
            roomRepository.save(room);
        }

        return bookingRepository.save(booking);
    }
}
package com.hotel_management.api.core.patterns.facade;

import com.hotel_management.api.core.domain.entity.Booking;
import com.hotel_management.api.core.domain.entity.Invoice;
import com.hotel_management.api.core.domain.enums.PaymentType;
import com.hotel_management.api.core.patterns.strategy.PaymentFactory;
import com.hotel_management.repository.BookingRepository;
import com.hotel_management.repository.InvoiceRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.math.BigDecimal;


@Service
public class CheckOutFacade {
    private final BookingRepository bookingRepository;
    private final InvoiceRepository invoiceRepository;
    private final PaymentFactory paymentFactory;

    public CheckOutFacade(BookingRepository bookingRepo, InvoiceRepository invoiceRepo, PaymentFactory paymentFactory) {
        this.bookingRepository = bookingRepo;
        this.invoiceRepository = invoiceRepo;
        this.paymentFactory = paymentFactory;
    }

    public Invoice processCheckout(Long bookingId, PaymentType paymentType) {
        if (bookingId == null) {
            throw new IllegalArgumentException("Booking ID cannot be null");
        }

        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new EntityNotFoundException("Booking not found"));
        
        // 1. Logic tính tiền thực tế
        // Nếu chưa set checkOutDate thì lấy thời điểm hiện tại
        LocalDateTime checkOutTime = LocalDateTime.now();
        booking.setCheckOutDate(checkOutTime);
        booking.setStatus("CHECKED_OUT"); // Cập nhật trạng thái
        
        // Tính số ngày ở
        long days = ChronoUnit.DAYS.between(booking.getCheckInDate(), checkOutTime);
        if (days == 0) days = 1; // Ở chưa được 24h vẫn tính 1 ngày

        // Lấy giá phòng từ Room Entity
        BigDecimal roomPrice = booking.getRoom().getPrice();
        BigDecimal total = roomPrice.multiply(BigDecimal.valueOf(days));

        // Cập nhật vào Booking luôn
        booking.setTotalAmount(total.doubleValue());
        bookingRepository.save(booking); // Lưu booking đã cập nhật

        // 2. Tạo Invoice
        Invoice invoice = new Invoice();
        invoice.setBooking(booking);
        invoice.setTotalAmount(total);
        invoice.setPaymentType(paymentType);
        
        // 3. Thanh toán & Lưu
        paymentFactory.getPaymentStrategy(paymentType).pay(invoice.getTotalAmount());
        return invoiceRepository.save(invoice);
    }
}
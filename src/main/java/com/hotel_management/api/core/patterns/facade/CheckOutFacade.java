package com.hotel_management.api.core.patterns.facade;

import com.hotel_management.api.core.domain.entity.Booking;
import com.hotel_management.api.core.domain.entity.Invoice;
import com.hotel_management.api.core.domain.enums.PaymentType;
import com.hotel_management.api.core.patterns.strategy.PaymentFactory;
import com.hotel_management.repository.BookingRepository;
import com.hotel_management.repository.InvoiceRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
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
                .orElseThrow(() -> new EntityNotFoundException("Booking not found with ID: " + bookingId));
        
        // 1. Tạo Invoice
        Invoice invoice = new Invoice();
        invoice.setBooking(booking);
        invoice.setTotalAmount(BigDecimal.valueOf(1000000)); // Demo tính tiền
        invoice.setPaymentType(paymentType);
        
        // 2. Thanh toán (Strategy)
        paymentFactory.getPaymentStrategy(paymentType).pay(invoice.getTotalAmount());
        
        // 3. Lưu DB
        return invoiceRepository.save(invoice);
    }
}
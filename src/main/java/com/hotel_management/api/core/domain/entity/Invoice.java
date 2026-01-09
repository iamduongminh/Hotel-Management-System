package com.hotel_management.api.core.domain.entity;


import jakarta.persistence.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.hotel_management.api.core.domain.enums.PaymentType;

@Entity
@Table(name = "invoices")
@Data
public class Invoice {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    private Booking booking;

    private BigDecimal totalAmount;
    private LocalDateTime createdAt = LocalDateTime.now();
    
    // Dùng Enum PaymentType nằm cùng package hoặc import
    @Enumerated(EnumType.STRING)
    private PaymentType paymentType; 
}
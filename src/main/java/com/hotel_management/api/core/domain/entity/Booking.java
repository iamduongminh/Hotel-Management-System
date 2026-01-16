package com.hotel_management.api.core.domain.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Table(name = "bookings")
@Data
public class Booking {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String customerName;
    private LocalDateTime checkInDate;
    private LocalDateTime checkOutDate;
    private Double totalAmount;
    private String status; // BOOKED, CHECKED_IN, CHECKED_OUT, CANCELLED

    @Column(nullable = false)
    private Boolean isOverdue = false;

    @Column(precision = 10, scale = 2)
    private java.math.BigDecimal extraCharges = java.math.BigDecimal.ZERO;

    @Column(length = 500)
    private String overdueNotes;

    @ManyToOne
    @JoinColumn(name = "room_id")
    private Room room;
}
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
    private String status; // BOOKED, CHECKED_IN, CHECKED_OUT

    @ManyToOne
    @JoinColumn(name = "room_id")
    private Room room;
}
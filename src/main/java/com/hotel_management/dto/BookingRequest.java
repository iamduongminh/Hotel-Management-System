package com.hotel_management.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class BookingRequest {
    private String customerName;
    private Long roomId;
    private LocalDateTime checkInDate;
    private LocalDateTime checkOutDate;
}
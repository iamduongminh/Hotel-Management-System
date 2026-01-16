package com.hotel_management.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class BookingRequest {
    private Long roomId;
    private String customerName;
    private String customerPhone;
    private String identityCard;
    private LocalDateTime checkInDate;
    private LocalDateTime checkOutDate;
    private String status;
}

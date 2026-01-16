package com.hotel_management.dto;

import lombok.Data;

@Data
public class ApprovalRequestDTO {
    private Long id;
    private Long bookingId;
    private String requestType;
    private String customerName;
    private String reason;
    private String status;
    private double discountPercent;
}

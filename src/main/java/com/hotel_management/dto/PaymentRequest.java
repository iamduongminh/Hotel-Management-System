package com.hotel_management.dto;

import com.hotel_management.api.core.domain.enums.PaymentType;
import lombok.Data;

@Data
public class PaymentRequest {
    private Long bookingId;
    private PaymentType paymentType;
}

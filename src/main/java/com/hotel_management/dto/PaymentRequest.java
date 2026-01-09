package com.hotel_management.dto;

import com.hotel_management.api.core.domain.enums.PaymentType;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class PaymentRequest {
    @NotNull(message = "Booking ID không được thiếu")
    private Long bookingId;

    @NotNull(message = "Phải chọn phương thức thanh toán")
    private PaymentType paymentType;
}
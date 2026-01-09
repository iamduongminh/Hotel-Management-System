package com.hotel_management.api.core.patterns.strategy;

import org.springframework.stereotype.Component;
import java.math.BigDecimal;

@Component
public class CardPayment implements IPaymentStrategy {
    @Override
    public String pay(BigDecimal amount) {
        return "Đã quẹt thẻ thanh toán: " + amount + " VNĐ";
    }
}
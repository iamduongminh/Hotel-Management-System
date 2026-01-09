package com.hotel_management.api.core.patterns.strategy;

import org.springframework.stereotype.Component;
import java.math.BigDecimal;

@Component
public class BankTransferPayment implements IPaymentStrategy {
    @Override
    public String pay(BigDecimal amount) {
        return "Đã chuyển khoản thành công số tiền: " + amount + " VNĐ";
    }
}
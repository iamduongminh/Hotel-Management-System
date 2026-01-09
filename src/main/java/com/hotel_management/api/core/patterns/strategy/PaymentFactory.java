package com.hotel_management.api.core.patterns.strategy;

import org.springframework.stereotype.Service;

import com.hotel_management.api.core.domain.enums.PaymentType;

@Service
public class PaymentFactory {
    private final CashPayment cash;
    // Inject thêm CardPayment, BankTransferPayment nếu có

    public PaymentFactory(CashPayment cash) {
        this.cash = cash;
    }

    public IPaymentStrategy getPaymentStrategy(PaymentType type) {
        // Demo đơn giản, mở rộng thêm case
        return switch (type) {
            case CASH -> cash;
            default -> cash; 
        };
    }
}
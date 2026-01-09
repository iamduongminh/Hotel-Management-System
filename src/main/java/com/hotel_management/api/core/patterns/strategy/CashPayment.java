package com.hotel_management.api.core.patterns.strategy;

import org.springframework.stereotype.Component;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.Locale;

@Component
public class CashPayment implements IPaymentStrategy {
    @Override
    public String pay(BigDecimal amount) {
        // Format tiền cho đẹp (VD: 100.000 đ)
        String formatted = NumberFormat.getCurrencyInstance(new Locale("vi", "VN")).format(amount);
        return "Đã thanh toán " + formatted + " bằng TIỀN MẶT.";
    }
}
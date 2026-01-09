package com.hotel_management.api.core.patterns.strategy;

import java.math.BigDecimal;

public interface IPaymentStrategy {
    String pay(BigDecimal amount);
}
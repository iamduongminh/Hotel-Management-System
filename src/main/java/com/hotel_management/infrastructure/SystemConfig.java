package com.hotel_management.infrastructure;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class SystemConfig {
    public static final String CURRENCY = "VND";
    // Sửa double -> BigDecimal để tránh sai số tiền tệ
    public static final java.math.BigDecimal TAX_RATE = java.math.BigDecimal.valueOf(0.1); 

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
package com.hotel_management.infrastructure;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SystemConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        // Dùng BCrypt để khớp với dữ liệu {bcrypt} trong Database
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable()) // Tắt CSRF để gọi API dễ dàng
                .authorizeHttpRequests(auth -> auth
                        // 1. Cho phép truy cập tự do vào các file tĩnh (CSS, JS, Ảnh)
                        .requestMatchers("/css/**", "/js/**", "/assets/**", "/pages/**", "/index.html", "/").permitAll()
                        // 2. Cho phép truy cập tự do vào API Đăng nhập
                        .requestMatchers("/api/auth/**", "/api/debug/**").permitAll()
                        // 3. Các API còn lại tạm thời cho phép hết (để bạn test cho dễ)
                        // Sau này muốn bảo mật thì sửa .permitAll() thành .authenticated()
                        .anyRequest().permitAll());

        return http.build();
    }
}
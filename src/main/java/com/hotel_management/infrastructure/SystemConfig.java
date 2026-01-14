package com.hotel_management.infrastructure;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

@Configuration
@EnableWebSecurity
public class SystemConfig {

    private final SessionAuthenticationFilter sessionAuthenticationFilter;

    public SystemConfig(SessionAuthenticationFilter sessionAuthenticationFilter) {
        this.sessionAuthenticationFilter = sessionAuthenticationFilter;
    }

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
                        // 3. BẢO MẬT: Các API còn lại BẮT BUỘC phải đăng nhập
                        .anyRequest().authenticated())
                .cors(cors -> cors.configurationSource(corsConfigurationSource())) // Kích hoạt CORS
                // Thêm Filter tùy chỉnh để đồng bộ Session với Spring Security
                .addFilterBefore(sessionAuthenticationFilter,
                        org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter.class)
                // Cấu hình xử lý khi chưa đăng nhập
                .exceptionHandling(ex -> ex
                        .authenticationEntryPoint((request, response, authException) -> {
                            response.setStatus(401);
                            response.setContentType("application/json");
                            response.getWriter().write(
                                    "{\"error\": \"Unauthorized\", \"message\": \"Bạn cần đăng nhập để truy cập tài nguyên này\"}");
                        }));

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        // Cho phép frontend từ localhost (bạn có thể thêm pattern khác nếu cần)
        configuration.setAllowedOriginPatterns(Arrays.asList("*"));
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(Arrays.asList("*"));
        configuration.setAllowCredentials(true); // QUAN TRỌNG: Cho phép gửi Cookie JSESSIONID

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
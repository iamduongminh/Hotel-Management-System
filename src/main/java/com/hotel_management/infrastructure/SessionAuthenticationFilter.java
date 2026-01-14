package com.hotel_management.infrastructure;

import com.hotel_management.api.core.domain.entity.User;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;

/**
 * Custom Filter để đồng bộ Session người dùng với Spring Security Context
 * Mỗi request sẽ kiểm tra HttpSession xem có "currentUser" không
 * Nếu có -> Cập nhật SecurityContext để Spring Security biết user đã đăng nhập
 */
@Component
public class SessionAuthenticationFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(@org.springframework.lang.NonNull HttpServletRequest request,
            @org.springframework.lang.NonNull HttpServletResponse response,
            @org.springframework.lang.NonNull FilterChain filterChain) throws ServletException, IOException {

        HttpSession session = request.getSession(false); // false = không tạo session mới

        if (session != null) {
            User currentUser = (User) session.getAttribute("currentUser");

            if (currentUser != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                // Tạo Authentication object cho Spring Security
                UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                        currentUser.getUsername(),
                        null, // Password không cần vì đã xác thực rồi
                        Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + currentUser.getRole().name())));

                // Lưu vào SecurityContext để Spring Security biết
                SecurityContextHolder.getContext().setAuthentication(authentication);
            }
        }

        // Tiếp tục chuỗi filter
        filterChain.doFilter(request, response);
    }
}

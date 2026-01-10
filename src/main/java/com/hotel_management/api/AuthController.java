package com.hotel_management.api;

import com.hotel_management.api.core.domain.entity.User;
import com.hotel_management.dto.LoginRequest;
import com.hotel_management.service.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest req, HttpSession session) {
        // 1. Gọi service xử lý đăng nhập (vẫn trả về User bình thường để lấy dữ liệu)
        User user = authService.login(req, session);

        // 2. TẠO DỮ LIỆU TRẢ VỀ THỦ CÔNG (DTO)
        // Mục đích: Cắt đứt mối quan hệ vòng lặp User <-> Booking
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Đăng nhập thành công!");
        response.put("id", user.getId());
        response.put("username", user.getUsername());
        response.put("fullName", user.getFullName());
        response.put("role", user.getRole()); // Quan trọng để phân quyền Frontend

        // 3. Trả về Map này thay vì User entity
        return ResponseEntity.ok(response);
    }

    @PostMapping("/logout")
    public ResponseEntity<String> logout(HttpSession session) {
        session.invalidate();
        return ResponseEntity.ok("Đăng xuất thành công");
    }
}
package com.hotel_management.api;

import com.hotel_management.api.core.domain.entity.User;
import com.hotel_management.dto.CreateUserRequest;
import com.hotel_management.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * User Management Controller - Only accessible by ADMIN role
 */
@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * Create new user (ADMIN only)
     * Password will be automatically encrypted with BCrypt
     */
    @PostMapping
    public ResponseEntity<?> createUser(@RequestBody CreateUserRequest request) {
        try {
            User createdUser = userService.createUser(request);

            // Return success response (without password)
            Map<String, Object> response = new HashMap<>();
            response.put("message", "Tạo tài khoản thành công!");
            response.put("userId", createdUser.getId());
            response.put("username", createdUser.getUsername());
            response.put("fullName", createdUser.getFullName());
            response.put("role", createdUser.getRole());

            return ResponseEntity.ok(response);

        } catch (IllegalArgumentException e) {
            // Validation errors (username exists, role restrictions, etc.)
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);

        } catch (Exception e) {
            // Unexpected errors
            Map<String, String> error = new HashMap<>();
            error.put("error", "Lỗi khi tạo tài khoản: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    /**
     * Get all users (ADMIN only)
     */
    @GetMapping
    public ResponseEntity<?> getAllUsers() {
        try {
            Iterable<User> users = userService.getAllUsers();
            return ResponseEntity.ok(users);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Lỗi khi lấy danh sách user: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    /**
     * Delete user (ADMIN only)
     */
    @DeleteMapping("/{userId}")
    public ResponseEntity<?> deleteUser(@PathVariable Long userId) {
        try {
            userService.deleteUser(userId);
            Map<String, String> response = new HashMap<>();
            response.put("message", "Xóa tài khoản thành công!");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Lỗi khi xóa tài khoản: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
        }
    }
}

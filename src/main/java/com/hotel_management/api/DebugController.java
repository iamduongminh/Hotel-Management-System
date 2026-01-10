package com.hotel_management.api;

import com.hotel_management.api.core.domain.entity.User;
import com.hotel_management.repository.UserRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

/**
 * DEBUG CONTROLLER - XÓA SAU KHI FIX XONG
 * Dùng để kiểm tra password hash trong database
 */
@RestController
@RequestMapping("/api/debug")
public class DebugController {

    private final UserRepository userRepo;
    private final PasswordEncoder passwordEncoder;

    public DebugController(UserRepository userRepo, PasswordEncoder passwordEncoder) {
        this.userRepo = userRepo;
        this.passwordEncoder = passwordEncoder;
    }

    @GetMapping("/check-user/{username}")
    public ResponseEntity<?> checkUser(@PathVariable String username) {
        Map<String, Object> result = new HashMap<>();

        Optional<User> userOpt = userRepo.findByUsername(username);
        if (userOpt.isEmpty()) {
            result.put("error", "User not found: " + username);
            return ResponseEntity.ok(result);
        }

        User user = userOpt.get();
        String dbPassword = user.getPassword();

        result.put("username", user.getUsername());
        result.put("fullName", user.getFullName());
        result.put("role", user.getRole());
        result.put("passwordInDb", dbPassword);
        result.put("passwordLength", dbPassword != null ? dbPassword.length() : 0);

        // Test if "123456" matches
        String testPassword = "123456";
        String hashToTest = dbPassword;
        if (hashToTest != null && hashToTest.startsWith("{bcrypt}")) {
            hashToTest = hashToTest.substring(8);
        }

        boolean matches = false;
        try {
            matches = passwordEncoder.matches(testPassword, hashToTest);
        } catch (Exception e) {
            result.put("matchError", e.getMessage());
        }
        result.put("passwordMatches123456", matches);

        return ResponseEntity.ok(result);
    }

    @GetMapping("/generate-hash/{password}")
    public ResponseEntity<?> generateHash(@PathVariable String password) {
        Map<String, String> result = new HashMap<>();
        result.put("rawPassword", password);
        result.put("bcryptHash", passwordEncoder.encode(password));
        return ResponseEntity.ok(result);
    }
}

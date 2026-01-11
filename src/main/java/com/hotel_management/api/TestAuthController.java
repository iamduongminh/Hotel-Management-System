package com.hotel_management.api;

import com.hotel_management.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * TEST CONTROLLER - Chỉ dùng để debug
 * XÓA NGAY SAU KHI FIX XONG!
 */
@RestController
@RequestMapping("/api/test")
public class TestAuthController {

    private final UserRepository userRepo;
    private final PasswordEncoder passwordEncoder;

    public TestAuthController(UserRepository userRepo, PasswordEncoder passwordEncoder) {
        this.userRepo = userRepo;
        this.passwordEncoder = passwordEncoder;
    }

    @GetMapping("/check-password")
    public Map<String, Object> checkPassword(@RequestParam String username, @RequestParam String password) {
        Map<String, Object> result = new HashMap<>();

        var userOpt = userRepo.findByUsername(username);
        if (userOpt.isEmpty()) {
            result.put("status", "ERROR");
            result.put("message", "User not found");
            return result;
        }

        var user = userOpt.get();
        String dbPassword = user.getPassword();

        result.put("status", "OK");
        result.put("username", username);
        result.put("password_in_db_starts_with",
                dbPassword != null ? dbPassword.substring(0, Math.min(20, dbPassword.length())) : "NULL");
        result.put("password_has_bcrypt_prefix", dbPassword != null && dbPassword.startsWith("{bcrypt}"));

        // Test với password gốc
        boolean matchesRaw = passwordEncoder.matches(password, dbPassword);
        result.put("matches_raw", matchesRaw);

        // Test với password sau khi remove prefix
        if (dbPassword != null && dbPassword.startsWith("{bcrypt}")) {
            String cleanPassword = dbPassword.substring(8);
            boolean matchesClean = passwordEncoder.matches(password, cleanPassword);
            result.put("matches_clean", matchesClean);
        }

        return result;
    }

    @GetMapping("/generate-hash")
    public Map<String, String> generateHash(@RequestParam String password) {
        Map<String, String> result = new HashMap<>();
        String hash = passwordEncoder.encode(password);
        result.put("password", password);
        result.put("hash", hash);
        result.put("sql_update", "UPDATE users SET password = '" + hash + "' WHERE username = 'admin';");
        return result;
    }
}

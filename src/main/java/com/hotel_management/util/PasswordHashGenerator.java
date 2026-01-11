package com.hotel_management.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * Utility class để tạo bcrypt hash cho password
 * Chạy class này để generate hash cho password mới
 */
public class PasswordHashGenerator {

    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

        // Tạo hash cho các password mẫu
        System.out.println("=== PASSWORD HASH GENERATOR ===");
        System.out.println();

        String[] passwords = { "admin123", "staff123", "123456", "password" };

        for (String password : passwords) {
            String hash = encoder.encode(password);
            System.out.println("Password: " + password);
            System.out.println("Hash:     " + hash);
            System.out.println();
        }

        System.out.println("=== Hướng dẫn sử dụng ===");
        System.out.println("1. Copy hash ở trên");
        System.out.println("2. Update vào database:");
        System.out.println("   UPDATE users SET password = '<hash>' WHERE username = 'admin';");
        System.out.println();
        System.out.println("HOẶC insert trực tiếp:");
        System.out.println("   INSERT INTO users (username, password, fullName, role)");
        System.out.println("   VALUES ('admin', '<hash>', 'Admin User', 'ADMIN');");
    }
}

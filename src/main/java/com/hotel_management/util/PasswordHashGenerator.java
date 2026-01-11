package com.hotel_management.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * Utility to generate bcrypt password hashes
 * Run this to generate real password hashes for database
 */
public class PasswordHashGenerator {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

        System.out.println("=== GENERATING BCRYPT HASHES FOR REAL PASSWORDS ===\n");

        // Regional Manager - Dương Quang Minh
        String pass1 = "MinhRM150585";
        System.out.println("Username: MinhRM");
        System.out.println("Password: " + pass1);
        System.out.println("Hash: " + encoder.encode(pass1));
        System.out.println();

        // Branch Manager - Hoàng Văn Anh
        String pass2 = "AnhBM120488";
        System.out.println("Username: AnhBM");
        System.out.println("Password: " + pass2);
        System.out.println("Hash: " + encoder.encode(pass2));
        System.out.println();

        // IT Admin - Trương Văn A
        String pass3 = "AADM120392";
        System.out.println("Username: admin");
        System.out.println("Password: " + pass3);
        System.out.println("Hash: " + encoder.encode(pass3));
        System.out.println();

        // Receptionist - Nguyễn Văn Tuấn
        String pass4 = "TuanREC150695";
        System.out.println("Username: staff");
        System.out.println("Password: " + pass4);
        System.out.println("Hash: " + encoder.encode(pass4));
        System.out.println();

        // Housekeeper - Bùi Văn Nam
        String pass5 = "NamHSK270994";
        System.out.println("Username: housekeeper");
        System.out.println("Password: " + pass5);
        System.out.println("Hash: " + encoder.encode(pass5));
        System.out.println();

        System.out.println("=== COPY THESE HASHES TO YOUR SQL SCRIPT ===");
    }
}

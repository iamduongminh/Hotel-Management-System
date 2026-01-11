package com.hotel_management.api.core.domain.entity;

import com.hotel_management.api.core.domain.enums.UserRole;
import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDate;

@Entity
@Table(name = "users")
@Data
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String username;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false)
    private String fullName;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private UserRole role;

    // Organizational fields
    private String city; // Thành phố: "Hà Nội", "HCM", etc.
    private String branchName; // Tên chi nhánh: "Ba Đình Hotel", "Quận 1 Hotel", etc.
    private LocalDate birthday; // Ngày sinh (dùng cho mật khẩu)

    // Optional contact info
    private String phoneNumber;
    private String email;
}
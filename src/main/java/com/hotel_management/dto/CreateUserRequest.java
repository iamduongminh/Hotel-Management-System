package com.hotel_management.dto;

import com.hotel_management.api.core.domain.enums.UserRole;
import lombok.Data;

import java.time.LocalDate;

/**
 * DTO for creating new users via admin dashboard
 */
@Data
public class CreateUserRequest {
    private String username;
    private String password; // Plain text password (will be encrypted by service)
    private String fullName;
    private UserRole role;

    // Optional organizational fields
    private String city;
    private String branchName;
    private LocalDate birthday;
    private String phoneNumber;
    private String email;
}

package com.hotel_management.dto;

import com.hotel_management.api.core.domain.enums.UserRole;
import lombok.Data;
import java.time.LocalDate;

@Data
public class CreateUserRequest {
    private String username;
    private String password;
    private String fullName;
    private UserRole role;
    private LocalDate birthday;
    private String phoneNumber;
    private String email;
}

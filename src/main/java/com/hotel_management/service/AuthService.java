package com.hotel_management.service;

import com.hotel_management.api.core.domain.entity.User;
import com.hotel_management.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder; // Import mới
import org.springframework.stereotype.Service;

@Service
public class AuthService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder; // Inject thêm

    public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public User login(String username, String password) {
        return userRepository.findByUsername(username)
                .filter(u -> passwordEncoder.matches(password, u.getPassword())) // So sánh mã hóa
                .orElse(null);
    }
    
}
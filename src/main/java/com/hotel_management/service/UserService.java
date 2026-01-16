package com.hotel_management.service;

import com.hotel_management.api.core.domain.entity.User;

import com.hotel_management.dto.CreateUserRequest;
import com.hotel_management.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    /**
     * Create new user with automatic password encryption
     * Includes role-based restrictions to prevent abuse
     */
    public User createUser(CreateUserRequest request) {
        // 1. Validate username is unique
        if (userRepository.existsByUsername(request.getUsername())) {
            throw new IllegalArgumentException("Username đã tồn tại!");
        }

        // 2. Create user entity
        User user = new User();
        user.setUsername(request.getUsername());

        // 3. AUTO-ENCRYPT PASSWORD with BCrypt
        user.setPassword(passwordEncoder.encode(request.getPassword()));

        user.setFullName(request.getFullName());
        user.setRole(request.getRole());
        user.setBirthday(request.getBirthday());
        user.setPhoneNumber(request.getPhoneNumber());
        user.setEmail(request.getEmail());

        // 4. Save to database
        return userRepository.save(user);
    }

    /**
     * Get all users (for admin dashboard)
     */
    public Iterable<User> getAllUsers() {
        return userRepository.findAll();
    }

    /**
     * Delete user by ID
     */
    public void deleteUser(Long userId) {
        if (userId != null) {
            userRepository.deleteById(userId);
        }
    }
}

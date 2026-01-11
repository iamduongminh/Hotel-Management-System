package com.hotel_management.repository;

import com.hotel_management.api.core.domain.enums.UserRole;
import org.springframework.data.jpa.repository.JpaRepository;

import com.hotel_management.api.core.domain.entity.User;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);

    // Check if username already exists
    boolean existsByUsername(String username);

    // Count users by role and location (for restrictions)
    long countByRoleAndCity(UserRole role, String city);

    long countByRoleAndBranchName(UserRole role, String branchName);

    long countByRole(UserRole role);
}

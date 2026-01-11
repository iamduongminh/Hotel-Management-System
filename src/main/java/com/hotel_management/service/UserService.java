package com.hotel_management.service;

import com.hotel_management.api.core.domain.entity.User;
import com.hotel_management.api.core.domain.enums.UserRole;
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

        // 2. Validate role creation restrictions
        validateRoleCreation(request.getRole(), request.getCity(), request.getBranchName());

        // 3. Create user entity
        User user = new User();
        user.setUsername(request.getUsername());

        // 4. AUTO-ENCRYPT PASSWORD with BCrypt
        user.setPassword(passwordEncoder.encode(request.getPassword()));

        user.setFullName(request.getFullName());
        user.setRole(request.getRole());
        user.setCity(request.getCity());
        user.setBranchName(request.getBranchName());
        user.setBirthday(request.getBirthday());
        user.setPhoneNumber(request.getPhoneNumber());
        user.setEmail(request.getEmail());

        // 5. Save to database
        return userRepository.save(user);
    }

    /**
     * Validate role creation to prevent abuse
     */
    private void validateRoleCreation(UserRole role, String city, String branchName) {
        switch (role) {
            case REGIONAL_MANAGER:
                // Only 1 Regional Manager per city
                long regionalCount = userRepository.countByRoleAndCity(UserRole.REGIONAL_MANAGER, city);
                if (regionalCount >= 1) {
                    throw new IllegalArgumentException(
                            "Thành phố " + city
                                    + " đã có Regional Manager. Mỗi thành phố chỉ được có 1 Regional Manager!");
                }
                break;

            case BRANCH_MANAGER:
                // Only 1 Branch Manager per branch
                if (branchName != null) {
                    long branchCount = userRepository.countByRoleAndBranchName(UserRole.BRANCH_MANAGER, branchName);
                    if (branchCount >= 1) {
                        throw new IllegalArgumentException(
                                "Chi nhánh " + branchName
                                        + " đã có Branch Manager. Mỗi chi nhánh chỉ được có 1 Manager!");
                    }
                }
                break;

            case ADMIN:
                // Max 3 admins per branch to prevent abuse
                if (branchName != null) {
                    long adminCount = userRepository.countByRoleAndBranchName(UserRole.ADMIN, branchName);
                    if (adminCount >= 3) {
                        throw new IllegalArgumentException(
                                "Chi nhánh " + branchName + " đã đủ Admin (tối đa 3). Không thể tạo thêm!");
                    }
                }
                break;

            case RECEPTIONIST:
            case HOUSEKEEPER:
                // No restrictions for staff
                break;

            default:
                throw new IllegalArgumentException("Role không hợp lệ!");
        }
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

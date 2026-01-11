package com.hotel_management.service;

import com.hotel_management.api.core.domain.entity.User;
import com.hotel_management.dto.LoginRequest;
import com.hotel_management.exception.InvalidPasswordException;
import com.hotel_management.exception.UserNotFoundException;
import com.hotel_management.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class AuthService {

    private final UserRepository userRepo;
    private final PasswordEncoder passwordEncoder;

    public AuthService(UserRepository userRepo, PasswordEncoder passwordEncoder) {
        this.userRepo = userRepo;
        this.passwordEncoder = passwordEncoder;
    }

    public User login(LoginRequest request, HttpSession session) {
        // 1. Validate
        if (request.getUsername() == null || request.getPassword() == null) {
            throw new InvalidPasswordException("Thông tin đăng nhập không hợp lệ");
        }

        // 2. Tìm user
        Optional<User> userOpt = userRepo.findByUsername(request.getUsername());
        if (userOpt.isEmpty()) {
            throw new UserNotFoundException("Tài khoản không tồn tại");
        }
        User user = userOpt.get();

        // 3. Lấy mật khẩu và KIỂM TRA NULL (Đây là chỗ bạn đang thiếu!)
        String dbPassword = user.getPassword();

        if (dbPassword == null || dbPassword.isEmpty()) {
            // Nếu DB lỗi (không có pass), báo lỗi nhẹ nhàng chứ không crash 500
            throw new InvalidPasswordException("Tài khoản lỗi: Chưa thiết lập mật khẩu");
        }

        // Xử lý tiền tố {bcrypt}
        if (dbPassword.startsWith("{bcrypt}")) {
            dbPassword = dbPassword.substring(8);
        }

        // 4. So khớp
        if (!passwordEncoder.matches(request.getPassword(), dbPassword)) {
            throw new InvalidPasswordException("Mật khẩu không chính xác");
        }

        // 5. Thành công
        session.setAttribute("currentUser", user);
        return user;
    }
}
package com.hotel_management.infrastructure;

import org.springframework.stereotype.Component;
import com.hotel_management.api.core.domain.entity.User;
import jakarta.servlet.http.HttpSession;

@Component
public class SessionManager {

    private final HttpSession httpSession;

    public SessionManager(HttpSession httpSession) {
        this.httpSession = httpSession;
    }

    public void setCurrentUser(User user) {
        // Lưu vào bộ nhớ Session của trình duyệt cụ thể
        httpSession.setAttribute("CURRENT_USER", user);
    }

    public User getCurrentUser() {
        return (User) httpSession.getAttribute("CURRENT_USER");
    }

    public void logout() {
        httpSession.removeAttribute("CURRENT_USER");
    }
}
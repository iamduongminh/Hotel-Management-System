package com.hotel_management.infrastructure;

import org.springframework.stereotype.Component;

import com.hotel_management.api.core.domain.entity.User;

@Component
public class SessionManager {
    private User currentUser;

    public void setCurrentUser(User user) {
        this.currentUser = user;
    }

    public User getCurrentUser() {
        return currentUser;
    }

    public void logout() {
        this.currentUser = null;
    }
}
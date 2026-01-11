package com.hotel_management.exception;

/**
 * Exception thrown when a user account is not found during login
 */
public class UserNotFoundException extends RuntimeException {
    public UserNotFoundException(String message) {
        super(message);
    }
}

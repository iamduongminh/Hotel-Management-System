package com.hotel_management.exception;

/**
 * Exception thrown when password validation fails during login
 */
public class InvalidPasswordException extends RuntimeException {
    public InvalidPasswordException(String message) {
        super(message);
    }
}

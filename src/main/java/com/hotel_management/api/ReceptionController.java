package com.hotel_management.api;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/reception")
public class ReceptionController {
    @GetMapping("/menu")
    public ResponseEntity<String> menu() {
        return ResponseEntity.ok("Reception Menu: /api/bookings, /api/checkin, /api/checkout");
    }
}
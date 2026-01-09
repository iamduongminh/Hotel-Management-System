package com.hotel_management.api;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.math.BigDecimal;

@RestController
@RequestMapping("/api/shift")
public class ShiftWorkController {
    @PostMapping("/start")
    public ResponseEntity<String> startShift(@RequestParam(defaultValue = "0") BigDecimal initialCash) {
        return ResponseEntity.ok("Shift started. Initial cash: " + initialCash);
    }

    @PostMapping("/end")
    public ResponseEntity<String> endShift(@RequestParam(defaultValue = "0") BigDecimal finalCash) {
        return ResponseEntity.ok("Shift ended. Final cash: " + finalCash);
    }
}
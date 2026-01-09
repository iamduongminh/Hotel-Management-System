package com.hotel_management.api;

import com.hotel_management.api.core.domain.entity.Invoice;
import com.hotel_management.api.core.patterns.facade.CheckOutFacade;
import com.hotel_management.dto.PaymentRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/checkout")
public class CheckOutController {
    private final CheckOutFacade facade;

    public CheckOutController(CheckOutFacade facade) {
        this.facade = facade;
    }

    @PostMapping
    public ResponseEntity<Invoice> checkout(@RequestBody PaymentRequest req) {
        return ResponseEntity.ok(
            facade.processCheckout(req.getBookingId(), req.getPaymentType())
        );
    }
}
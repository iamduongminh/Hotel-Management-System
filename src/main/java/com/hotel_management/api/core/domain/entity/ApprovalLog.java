package com.hotel_management.api.core.domain.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Data
public class ApprovalLog {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String commandName; // VD: ApproveDiscountCmd
    private String description; // VD: Duyệt giảm giá 10% cho Booking 1
    private LocalDateTime timestamp = LocalDateTime.now();
}
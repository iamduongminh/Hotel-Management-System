package com.hotel_management.api.core.domain.entity;

import com.hotel_management.api.core.domain.enums.RequestStatus;
import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Table(name = "approval_requests")
@Data
public class ApprovalRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String type; 
    
    @Column(nullable = false)
    private Long targetId; 
    
    private String requestData; 
    
    private String reason; 

    @Enumerated(EnumType.STRING)
    private RequestStatus status; 

    private LocalDateTime createdAt = LocalDateTime.now();
    private String createdBy;
}
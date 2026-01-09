package com.hotel_management.repository;

import com.hotel_management.api.core.domain.entity.ApprovalRequest;
import com.hotel_management.api.core.domain.enums.RequestStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ApprovalRequestRepository extends JpaRepository<ApprovalRequest, Long> {
    
    List<ApprovalRequest> findByStatus(RequestStatus status);
}
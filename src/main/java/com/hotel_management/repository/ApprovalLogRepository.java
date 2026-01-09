package com.hotel_management.repository;

import com.hotel_management.api.core.domain.entity.ApprovalLog; // Import Entity ApprovalLog
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ApprovalLogRepository extends JpaRepository<ApprovalLog, Long> {
}
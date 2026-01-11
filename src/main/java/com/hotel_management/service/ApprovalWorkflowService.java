package com.hotel_management.service;

import com.hotel_management.api.core.patterns.command.ICommand;
import com.hotel_management.api.core.domain.entity.ApprovalLog;
import com.hotel_management.dto.ApprovalRequestDTO;
import com.hotel_management.repository.ApprovalLogRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class ApprovalWorkflowService {
    private final ApprovalLogRepository logRepo;

    public ApprovalWorkflowService(ApprovalLogRepository logRepo) {
        this.logRepo = logRepo;
    }

    public void executeCommand(ICommand cmd) {
        // 1. Thực thi logic
        cmd.execute();

        // 2. Lưu log vào Database thay vì ArrayList
        ApprovalLog log = new ApprovalLog();
        log.setCommandName(cmd.getClass().getSimpleName());
        log.setDescription(cmd.toString()); // Bạn cần Override toString() trong các class Command để có nội dung ý
                                            // nghĩa
        logRepo.save(log);
    }

    public List<ApprovalRequestDTO> getPendingApprovals() {
        // Note: This is demo data. In production, query from approval_requests table
        List<ApprovalRequestDTO> pending = new ArrayList<>();

        // Demo data
        ApprovalRequestDTO req1 = new ApprovalRequestDTO();
        req1.setId(1L);
        req1.setBookingId(101L);
        req1.setRequestType("DISCOUNT");
        req1.setCustomerName("Nguyễn Văn A");
        req1.setReason("Khách hàng VIP");
        req1.setStatus("PENDING");
        req1.setDiscountPercent(10);
        pending.add(req1);

        return pending;
    }
}
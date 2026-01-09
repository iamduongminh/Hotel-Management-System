package com.hotel_management.service;

import com.hotel_management.api.core.patterns.command.ICommand;
import com.hotel_management.api.core.domain.entity.ApprovalLog;
import com.hotel_management.repository.ApprovalLogRepository;
import org.springframework.stereotype.Service;

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
        log.setDescription(cmd.toString()); // Bạn cần Override toString() trong các class Command để có nội dung ý nghĩa
        logRepo.save(log);
    }
}
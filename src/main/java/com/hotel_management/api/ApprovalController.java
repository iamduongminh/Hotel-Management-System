package com.hotel_management.api;

import com.hotel_management.api.core.patterns.command.ApproveDiscountCmd;
import com.hotel_management.api.core.patterns.command.ICommand;
import com.hotel_management.api.core.patterns.command.RejectRequestCmd;
import com.hotel_management.service.ApprovalWorkflowService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/admin/approvals")
public class ApprovalController {
    private final ApprovalWorkflowService workflowService;

    public ApprovalController(ApprovalWorkflowService workflowService) {
        this.workflowService = workflowService;
    }

    // API duyệt giảm giá (Trigger Command Pattern)
    @PostMapping("/discount")
    public ResponseEntity<String> approveDiscount(@RequestBody Map<String, Object> payload) {
        Long bookingId = Long.valueOf(payload.get("bookingId").toString());
        int percent = Integer.parseInt(payload.get("percent").toString());

        // Tạo Command và thực thi
        ICommand cmd = new ApproveDiscountCmd(bookingId, percent);
        workflowService.executeCommand(cmd);

        return ResponseEntity.ok("Đã duyệt giảm giá " + percent + "% cho đơn: " + bookingId);
    }

    // API từ chối yêu cầu
    @PostMapping("/reject")
    public ResponseEntity<String> rejectRequest(@RequestBody Map<String, Object> payload) {
        Long bookingId = Long.valueOf(payload.get("bookingId").toString());
        String reason = payload.get("reason").toString();

        ICommand cmd = new RejectRequestCmd(bookingId, reason);
        workflowService.executeCommand(cmd);

        return ResponseEntity.ok("Đã từ chối đơn: " + bookingId);
    }
}
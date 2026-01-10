package com.hotel_management.api;

import com.hotel_management.api.core.patterns.command.ApproveDiscountCmd;
import com.hotel_management.api.core.patterns.command.ICommand;
import com.hotel_management.api.core.patterns.command.RejectRequestCmd;
import com.hotel_management.dto.ApprovalRequestDTO;
import com.hotel_management.service.ApprovalWorkflowService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/approvals")
public class ApprovalController {
    private final ApprovalWorkflowService workflowService;

    public ApprovalController(ApprovalWorkflowService workflowService) {
        this.workflowService = workflowService;
    }

    @GetMapping("/pending")
    public ResponseEntity<List<ApprovalRequestDTO>> getPendingApprovals() {
        return ResponseEntity.ok(workflowService.getPendingApprovals());
    }

    // Helper method để lấy long an toàn từ Map
    private long parseLongSafe(Object value) {
        if (value == null)
            throw new IllegalArgumentException("Giá trị ID không được để trống");
        return Long.parseLong(value.toString());
    }

    @PostMapping("/discount")
    public ResponseEntity<String> approveDiscount(@RequestBody Map<String, Object> payload) {
        // SỬA LỖI: Dùng parseLongSafe để đảm bảo lấy ra kiểu primitive long
        long bookingId = parseLongSafe(payload.get("bookingId"));

        // Kiểm tra null cho percent
        Object percentObj = payload.get("percent");
        int percent = (percentObj != null) ? Integer.parseInt(percentObj.toString()) : 0;

        // Command Pattern
        ICommand cmd = new ApproveDiscountCmd(bookingId, percent);
        workflowService.executeCommand(cmd);

        return ResponseEntity.ok("Đã duyệt giảm giá " + percent + "% cho đơn: " + bookingId);
    }

    @PostMapping("/reject")
    public ResponseEntity<String> rejectRequest(@RequestBody Map<String, Object> payload) {
        long bookingId = parseLongSafe(payload.get("bookingId"));

        Object reasonObj = payload.get("reason");
        String reason = (reasonObj != null) ? reasonObj.toString() : "";

        ICommand cmd = new RejectRequestCmd(bookingId, reason);
        workflowService.executeCommand(cmd);

        return ResponseEntity.ok("Đã từ chối đơn: " + bookingId);
    }
}
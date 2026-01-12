package com.hotel_management.api;

import com.hotel_management.api.core.domain.entity.Room;
import com.hotel_management.api.core.domain.entity.User;
import com.hotel_management.api.core.domain.enums.RoomStatus;
import com.hotel_management.api.core.domain.enums.UserRole;
import com.hotel_management.service.RoomService;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/rooms")
public class RoomController {

    private final RoomService roomService;

    public RoomController(RoomService roomService) {
        this.roomService = roomService;
    }

    /**
     * Get all rooms
     */
    @GetMapping
    public ResponseEntity<List<Room>> getAllRooms() {
        return ResponseEntity.ok(roomService.getAllRooms());
    }

    /**
     * Get single room by ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<Room> getRoomById(@PathVariable Long id) {
        Room room = roomService.getRoomById(id);
        return ResponseEntity.ok(room);
    }

    /**
     * Update room status with role-based permission check
     */
    @PutMapping("/{id}/status")
    public ResponseEntity<?> updateRoomStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> request,
            HttpSession session) {

        // 1. Get current user from session
        User currentUser = (User) session.getAttribute("currentUser");
        System.out.println("DEBUG: updateRoomStatus called for room ID: " + id);

        if (currentUser == null) {
            System.out.println("DEBUG: currentUser is NULL in session!");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(createErrorResponse("Vui lòng đăng nhập để thực hiện thao tác này"));
        }

        System.out.println("DEBUG: User found: " + currentUser.getUsername() + ", Role: " + currentUser.getRole());

        // 2. Parse requested status
        String statusStr = request.get("status");
        if (statusStr == null || statusStr.trim().isEmpty()) {
            return ResponseEntity.badRequest()
                    .body(createErrorResponse("Trạng thái không được để trống"));
        }

        RoomStatus newStatus;
        try {
            newStatus = RoomStatus.valueOf(statusStr.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest()
                    .body(createErrorResponse("Trạng thái không hợp lệ: " + statusStr));
        }

        // 3. Get current room status
        Room currentRoom = roomService.getRoomById(id);
        RoomStatus currentStatus = currentRoom.getStatus();

        // 4. Validate permission based on role
        UserRole userRole = currentUser.getRole();
        String permissionError = validateStatusChangePermission(userRole, currentStatus, newStatus);

        if (permissionError != null) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(createErrorResponse(permissionError));
        }

        // 5. Update status
        Room updatedRoom = roomService.updateRoomStatus(id, newStatus);

        // 6. Return success response
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Cập nhật trạng thái phòng thành công");
        response.put("room", updatedRoom);
        return ResponseEntity.ok(response);
    }

    /**
     * Validate if user has permission to change room status
     * Returns error message if not allowed, null if allowed
     */
    private String validateStatusChangePermission(UserRole userRole, RoomStatus currentStatus, RoomStatus newStatus) {
        switch (userRole) {
            case HOUSEKEEPER:
                // Housekeeper can only change DIRTY -> AVAILABLE
                if (currentStatus != RoomStatus.DIRTY || newStatus != RoomStatus.AVAILABLE) {
                    return "Nhân viên dọn phòng chỉ có thể chuyển phòng DIRTY sang AVAILABLE";
                }
                break;

            case RECEPTIONIST:
                // Receptionist can change to AVAILABLE, BOOKED, OCCUPIED, DIRTY (NOT
                // MAINTENANCE)
                if (newStatus == RoomStatus.MAINTENANCE) {
                    return "Lễ tân không có quyền chuyển phòng sang trạng thái BẢO TRÌ";
                }
                break;

            case BRANCH_MANAGER:
            case REGIONAL_MANAGER:
            case ADMIN:
                // Managers and admins can change to any status
                // No restriction
                break;

            default:
                return "Bạn không có quyền thay đổi trạng thái phòng";
        }

        return null; // Permission granted
    }

    /**
     * Helper method to create error response
     */
    private Map<String, String> createErrorResponse(String message) {
        Map<String, String> error = new HashMap<>();
        error.put("error", message);
        return error;
    }
}

package com.hotel_management.api;

import com.hotel_management.api.core.domain.entity.Room;
import com.hotel_management.api.core.domain.enums.RoomStatus; // Import Enum
import com.hotel_management.service.RoomService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/housekeeping")
public class HousekeepingController {
    private final RoomService roomService;

    public HousekeepingController(RoomService roomService) {
        this.roomService = roomService;
    }

    // API lấy danh sách phòng
    @GetMapping("/rooms")
    public ResponseEntity<List<Room>> getAllRooms() {
        return ResponseEntity.ok(roomService.getAllRooms());
    }

    // API đánh dấu phòng sạch
    @PostMapping("/rooms/{id}/mark-clean")
    public ResponseEntity<String> markRoomClean(@PathVariable Long id) {
        roomService.updateRoomStatus(id, RoomStatus.AVAILABLE); // Truyền Enum
        return ResponseEntity.ok("Phòng đã được dọn sạch.");
    }

    // API báo bảo trì
    @PostMapping("/rooms/{id}/maintenance")
    public ResponseEntity<String> setMaintenance(@PathVariable Long id) {
        roomService.updateRoomStatus(id, RoomStatus.MAINTENANCE); // Truyền Enum
        return ResponseEntity.ok("Phòng đang được bảo trì.");
    }
}
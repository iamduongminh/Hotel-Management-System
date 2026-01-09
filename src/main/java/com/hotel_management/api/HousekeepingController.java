package com.hotel_management.api;

import com.hotel_management.api.core.domain.entity.Room;
import com.hotel_management.api.core.domain.enums.RoomStatus;
import com.hotel_management.service.RoomService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/housekeeping")
public class HousekeepingController {
    private final RoomService roomService;

    public HousekeepingController(RoomService roomService) {
        this.roomService = roomService;
    }

    @PostMapping("/rooms/{roomId}/mark-clean")
    public ResponseEntity<Room> markClean(@PathVariable Long roomId) {
        return ResponseEntity.ok(roomService.updateStatus(roomId, RoomStatus.AVAILABLE));
    }

    @PostMapping("/rooms/{roomId}/maintenance")
    public ResponseEntity<Room> setMaintenance(@PathVariable Long roomId) {
        return ResponseEntity.ok(roomService.updateStatus(roomId, RoomStatus.MAINTENANCE));
    }
}
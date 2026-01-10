package com.hotel_management.service;

import com.hotel_management.api.core.domain.entity.Room;
import com.hotel_management.api.core.domain.enums.RoomStatus;
import com.hotel_management.repository.RoomRepository;
import org.springframework.stereotype.Service;
import jakarta.persistence.EntityNotFoundException;
import java.util.List;

@Service
public class RoomService {
    private final RoomRepository roomRepo;

    public RoomService(RoomRepository roomRepo) {
        this.roomRepo = roomRepo;
    }

    // Đổi tên thành getAllRooms cho khớp với HousekeepingController
    public List<Room> getAllRooms() {
        return roomRepo.findAll();
    }
    
    // Sửa lỗi setStatus và Null safety
    public Room updateRoomStatus(Long id, RoomStatus status) {
        if (id == null) {
            throw new IllegalArgumentException("Room ID cannot be null");
        }

        Room room = roomRepo.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Room not found with ID: " + id));

        // Entity Room định nghĩa status là Enum RoomStatus
        // Nên ở đây ta truyền trực tiếp Enum vào, KHÔNG dùng .name() hoặc String
        room.setStatus(status);
        
        return roomRepo.save(room);
    }
}
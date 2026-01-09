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

    public List<Room> findAll() {
        return roomRepo.findAll();
    }
    
    public Room updateStatus(Long id, RoomStatus status) {
        Long roomId = id;

        if (roomId == null) {
            throw new IllegalArgumentException("Room ID cannot be null");
        }

        Room room = roomRepo.findById(roomId)
                .orElseThrow(() -> new EntityNotFoundException("Room not found with ID: " + roomId));

        
        // --- SỬA Ở ĐÂY ---
        // Sai: r.setStatus(status.name()); -> Vì setter nhận Enum, không nhận String
        // Đúng:
        room.setStatus(status); 
        
        return roomRepo.save(room);
    }
}
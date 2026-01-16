package com.hotel_management.service;

import com.hotel_management.api.core.domain.entity.Room;
import com.hotel_management.api.core.domain.enums.RoomStatus;
import com.hotel_management.api.core.domain.enums.RoomType; // Added import back
import com.hotel_management.repository.RoomRepository;

import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;
import jakarta.persistence.EntityNotFoundException;
import java.util.List;
import java.util.Map;

@Service
public class RoomService {
    private final RoomRepository roomRepo;
    private final com.hotel_management.repository.BookingRepository bookingRepo;

    public RoomService(RoomRepository roomRepo, com.hotel_management.repository.BookingRepository bookingRepo) {
        this.roomRepo = roomRepo;
        this.bookingRepo = bookingRepo;
    }

    public List<Room> getAllRooms() {
        return calculateRoomStatuses(roomRepo.findAll());
    }

    public List<Room> getRoomsByBranch(String branchName) {
        if (branchName == null || branchName.isEmpty()) {
            return getAllRooms();
        }
        return calculateRoomStatuses(roomRepo.findByBranchName(branchName));
    }

    private List<Room> calculateRoomStatuses(List<Room> rooms) {
        // 1. Fetch active bookings (for OCCUPIED / BOOKED overlay)
        List<com.hotel_management.api.core.domain.entity.Booking> activeBookings = bookingRepo.findActiveBookings();

        for (Room room : rooms) {
            // Base status is what's in the DB (DIRTY, MAINTENANCE, AVAILABLE, or even
            // OCCUPIED if set manually)
            // If DB status is null, default to AVAILABLE
            if (room.getStatus() == null) {
                room.setStatus(RoomStatus.AVAILABLE);
            }

            // Priority 1: MAINTENANCE from DB overrides everything (except if we want
            // bookings to show?)
            // Usually Maintenance blocks everything.
            if (room.getStatus() == RoomStatus.MAINTENANCE) {
                continue;
            }

            // Priority 2: Active Booking (System derived OCCUPIED/BOOKED)
            // This Overlays whatever is in DB (e.g. if DB says DIRTY but guest checks in,
            // it becomes OCCUPIED)
            boolean bookingFound = false;
            for (com.hotel_management.api.core.domain.entity.Booking booking : activeBookings) {
                if (booking.getRoom().getId().equals(room.getId())) {
                    if ("CHECKED_IN".equals(booking.getStatus())) {
                        room.setStatus(RoomStatus.OCCUPIED);
                        bookingFound = true;
                    } else if ("BOOKED".equals(booking.getStatus())) {
                        // Only override if not already OCCUPIED
                        if (room.getStatus() != RoomStatus.OCCUPIED) {
                            room.setStatus(RoomStatus.BOOKED);
                        }
                        bookingFound = true;
                    }
                    break;
                }
            }

            if (bookingFound) {
                continue;
            }

            // Priority 3: Retain DB status (DIRTY, AVAILABLE, etc.)
            // Already set at start of loop.
        }
        return rooms;
    }

    @NonNull
    @SuppressWarnings("null")
    public Room updateRoomStatus(Long id, RoomStatus status) {
        if (id == null) {
            throw new IllegalArgumentException("Room ID cannot be null");
        }

        Room room = roomRepo.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Room not found with ID: " + id));

        // Save status directly to DB
        room.setStatus(status);
        return roomRepo.save(room);
    }

    // Get room by ID
    @NonNull
    @SuppressWarnings("null")
    public Room getRoomById(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Room ID cannot be null");
        }

        Room room = roomRepo.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Room not found with ID: " + id));
        return room;
    }

    /**
     * Update room information (price, type, room number)
     * 
     * @param id      Room ID
     * @param updates Map containing fields to update
     * @return Updated room
     */
    @NonNull
    @SuppressWarnings("null")
    public Room updateRoom(Long id, Map<String, Object> updates) {
        if (id == null) {
            throw new IllegalArgumentException("Room ID cannot be null");
        }

        Room room = roomRepo.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Room not found with ID: " + id));

        // Update fields if present in the request
        if (updates.containsKey("roomNumber")) {
            room.setRoomNumber(updates.get("roomNumber").toString());
        }

        if (updates.containsKey("price")) {
            Object priceObj = updates.get("price");
            if (priceObj instanceof Number) {
                room.setPrice(new java.math.BigDecimal(priceObj.toString()));
            }
        }

        if (updates.containsKey("type")) {
            String typeStr = updates.get("type").toString();
            try {
                RoomType roomType = RoomType.valueOf(typeStr.toUpperCase());
                room.setType(roomType);
            } catch (IllegalArgumentException e) {
                throw new IllegalArgumentException("Invalid room type: " + typeStr);
            }
        }

        // Save and return
        return roomRepo.save(room);
    }

    /**
     * Create a new room
     * 
     * @param room Room entity to create
     * @return Created room
     */
    @NonNull
    public Room createRoom(Room room) {
        // Validate required fields
        if (room.getRoomNumber() == null || room.getRoomNumber().isEmpty()) {
            throw new IllegalArgumentException("Số phòng không được để trống");
        }
        if (room.getType() == null) {
            throw new IllegalArgumentException("Loại phòng không được để trống");
        }
        if (room.getPrice() == null) {
            throw new IllegalArgumentException("Giá phòng không được để trống");
        }

        // Set default status if not provided
        if (room.getStatus() == null) {
            room.setStatus(RoomStatus.AVAILABLE);
        }

        // Save and return
        return roomRepo.save(room);
    }

    /**
     * Get filtered rooms based on multiple criteria
     * 
     * @param branchName Branch to filter by
     * @param type       Room type filter (optional)
     * @param status     Room status filter (optional)
     * @param minPrice   Minimum price filter (optional)
     * @param maxPrice   Maximum price filter (optional)
     * @param roomNumber Room number search (optional)
     * @return List of rooms matching the criteria
     */
    public List<Room> getFilteredRooms(
            String branchName,
            RoomType type,
            RoomStatus status,
            java.math.BigDecimal minPrice,
            java.math.BigDecimal maxPrice,
            String roomNumber) {

        // Start with rooms by branch
        List<Room> rooms = getRoomsByBranch(branchName);

        // Apply filters
        return rooms.stream()
                .filter(room -> type == null || room.getType() == type)
                .filter(room -> status == null || room.getStatus() == status)
                .filter(room -> minPrice == null || room.getPrice().compareTo(minPrice) >= 0)
                .filter(room -> maxPrice == null || room.getPrice().compareTo(maxPrice) <= 0)
                .filter(room -> roomNumber == null || roomNumber.isEmpty()
                        || room.getRoomNumber().toLowerCase().contains(roomNumber.toLowerCase()))
                .toList();
    }
}
package com.hotel_management.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hotel_management.api.core.domain.entity.Room;

public interface RoomRepository extends JpaRepository<Room, Long> {
    // Single-branch system - no filtering needed
}
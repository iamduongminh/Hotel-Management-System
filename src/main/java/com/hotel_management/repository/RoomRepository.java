package com.hotel_management.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hotel_management.api.core.domain.entity.Room;

import java.util.List;

public interface RoomRepository extends JpaRepository<Room, Long> {
    List<Room> findByBranchName(String branchName);
}
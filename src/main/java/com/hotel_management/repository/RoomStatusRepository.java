package com.hotel_management.repository;

import com.hotel_management.api.core.domain.entity.RoomStatusEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RoomStatusRepository extends JpaRepository<RoomStatusEntity, Long> {
}

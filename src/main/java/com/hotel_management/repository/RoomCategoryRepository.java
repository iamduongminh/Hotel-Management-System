package com.hotel_management.repository;

import com.hotel_management.api.core.domain.entity.RoomCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RoomCategoryRepository extends JpaRepository<RoomCategory, Long> {
    // Single-branch system - use findAll()
}

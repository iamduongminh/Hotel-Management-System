package com.hotel_management.repository;

import com.hotel_management.api.core.domain.entity.RoomCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RoomCategoryRepository extends JpaRepository<RoomCategory, Long> {
    List<RoomCategory> findByBranchName(String branchName);

    List<RoomCategory> findByCityAndBranchName(String city, String branchName);

    List<RoomCategory> findByBranchNameOrderByIdDesc(String branchName);
}

package com.hotel_management.service;

import com.hotel_management.api.core.domain.entity.RoomCategory;
import com.hotel_management.repository.RoomCategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class RoomCategoryService {

    @Autowired
    private RoomCategoryRepository roomCategoryRepository;

    /**
     * Get all room categories
     */
    public List<RoomCategory> getAllCategories() {
        return roomCategoryRepository.findAll();
    }

    /**
     * Get room category by ID
     */
    @SuppressWarnings("null")
    public RoomCategory getCategoryById(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("ID không được để trống");
        }
        return roomCategoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy danh mục phòng với ID: " + id));
    }

    /**
     * Create new room category
     */
    @Transactional
    public RoomCategory createCategory(RoomCategory category) {
        // Validate required fields
        if (category.getName() == null || category.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Tên danh mục không được để trống");
        }
        if (category.getBasePrice() == null || category.getBasePrice().signum() < 0) {
            throw new IllegalArgumentException("Giá cơ bản không hợp lệ");
        }

        // Set default values
        if (category.getActive() == null) {
            category.setActive(true);
        }
        if (category.getCapacity() == null) {
            category.setCapacity(2);
        }

        return roomCategoryRepository.save(category);
    }

    /**
     * Update existing room category
     */
    @Transactional
    public RoomCategory updateCategory(Long id, RoomCategory updatedCategory) {
        RoomCategory existingCategory = getCategoryById(id);

        // Update fields
        if (updatedCategory.getName() != null && !updatedCategory.getName().trim().isEmpty()) {
            existingCategory.setName(updatedCategory.getName());
        }
        if (updatedCategory.getDescription() != null) {
            existingCategory.setDescription(updatedCategory.getDescription());
        }
        if (updatedCategory.getBasePrice() != null && updatedCategory.getBasePrice().signum() >= 0) {
            existingCategory.setBasePrice(updatedCategory.getBasePrice());
        }
        if (updatedCategory.getCapacity() != null && updatedCategory.getCapacity() > 0) {
            existingCategory.setCapacity(updatedCategory.getCapacity());
        }
        if (updatedCategory.getAmenities() != null) {
            existingCategory.setAmenities(updatedCategory.getAmenities());
        }
        if (updatedCategory.getActive() != null) {
            existingCategory.setActive(updatedCategory.getActive());
        }

        @SuppressWarnings("null")
        RoomCategory saved = roomCategoryRepository.save(existingCategory);
        return saved;
    }

    /**
     * Delete room category
     */
    @Transactional
    @SuppressWarnings("null")
    public void deleteCategory(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("ID không được để trống");
        }
        if (!roomCategoryRepository.existsById(id)) {
            throw new RuntimeException("Không tìm thấy danh mục phòng với ID: " + id);
        }
        roomCategoryRepository.deleteById(id);
    }

    /**
     * Toggle room category active status
     */
    @Transactional
    public RoomCategory toggleCategoryStatus(Long id) {
        RoomCategory category = getCategoryById(id);
        category.setActive(!category.getActive());
        return roomCategoryRepository.save(category);
    }
}

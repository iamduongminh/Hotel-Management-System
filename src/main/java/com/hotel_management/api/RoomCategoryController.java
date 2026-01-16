package com.hotel_management.api;

import com.hotel_management.api.core.domain.entity.RoomCategory;
import com.hotel_management.api.core.domain.entity.User;
import com.hotel_management.service.RoomCategoryService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/room-categories")
public class RoomCategoryController {

    @Autowired
    private RoomCategoryService roomCategoryService;

    /**
     * Get all room categories filtered by user's branch
     */
    @GetMapping
    public ResponseEntity<?> getAllCategories(HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(createErrorResponse("Vui lòng đăng nhập"));
            }

            String branchName = currentUser.getBranchName();
            List<RoomCategory> categories = roomCategoryService.getAllCategoriesByBranch(branchName);
            return ResponseEntity.ok(categories);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Lỗi: " + e.getMessage()));
        }
    }

    /**
     * Get room category by ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<?> getCategoryById(@PathVariable Long id, HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(createErrorResponse("Vui lòng đăng nhập"));
            }

            RoomCategory category = roomCategoryService.getCategoryById(id);

            // Check if category belongs to user's branch
            if (!category.getBranchName().equals(currentUser.getBranchName())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(createErrorResponse("Bạn không có quyền xem danh mục này"));
            }

            return ResponseEntity.ok(category);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(createErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Lỗi: " + e.getMessage()));
        }
    }

    /**
     * Create new room category
     */
    @PostMapping
    public ResponseEntity<?> createCategory(@RequestBody RoomCategory category, HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(createErrorResponse("Vui lòng đăng nhập"));
            }

            // Set branch info from current user
            category.setCity(currentUser.getCity());
            category.setBranchName(currentUser.getBranchName());

            RoomCategory createdCategory = roomCategoryService.createCategory(category);

            Map<String, Object> response = new HashMap<>();
            response.put("message", "Tạo danh mục phòng thành công");
            response.put("category", createdCategory);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(createErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Lỗi: " + e.getMessage()));
        }
    }

    /**
     * Update room category
     */
    @PutMapping("/{id}")
    public ResponseEntity<?> updateCategory(
            @PathVariable Long id,
            @RequestBody RoomCategory category,
            HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(createErrorResponse("Vui lòng đăng nhập"));
            }

            // Check if category belongs to user's branch
            RoomCategory existingCategory = roomCategoryService.getCategoryById(id);
            if (!existingCategory.getBranchName().equals(currentUser.getBranchName())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(createErrorResponse("Bạn không có quyền sửa danh mục này"));
            }

            RoomCategory updatedCategory = roomCategoryService.updateCategory(id, category);

            Map<String, Object> response = new HashMap<>();
            response.put("message", "Cập nhật danh mục phòng thành công");
            response.put("category", updatedCategory);
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(createErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Lỗi: " + e.getMessage()));
        }
    }

    /**
     * Delete room category
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteCategory(@PathVariable Long id, HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(createErrorResponse("Vui lòng đăng nhập"));
            }

            // Check if category belongs to user's branch
            RoomCategory existingCategory = roomCategoryService.getCategoryById(id);
            if (!existingCategory.getBranchName().equals(currentUser.getBranchName())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(createErrorResponse("Bạn không có quyền xóa danh mục này"));
            }

            roomCategoryService.deleteCategory(id);

            Map<String, String> response = new HashMap<>();
            response.put("message", "Xóa danh mục phòng thành công");
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(createErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Lỗi: " + e.getMessage()));
        }
    }

    /**
     * Toggle room category status
     */
    @PatchMapping("/{id}/toggle-status")
    public ResponseEntity<?> toggleCategoryStatus(@PathVariable Long id, HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(createErrorResponse("Vui lòng đăng nhập"));
            }

            // Check if category belongs to user's branch
            RoomCategory existingCategory = roomCategoryService.getCategoryById(id);
            if (!existingCategory.getBranchName().equals(currentUser.getBranchName())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(createErrorResponse("Bạn không có quyền thay đổi trạng thái danh mục này"));
            }

            RoomCategory updatedCategory = roomCategoryService.toggleCategoryStatus(id);

            Map<String, Object> response = new HashMap<>();
            response.put("message", "Cập nhật trạng thái thành công");
            response.put("category", updatedCategory);
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(createErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Lỗi: " + e.getMessage()));
        }
    }

    /**
     * Helper method to create error response
     */
    private Map<String, String> createErrorResponse(String message) {
        Map<String, String> error = new HashMap<>();
        error.put("error", message);
        return error;
    }
}

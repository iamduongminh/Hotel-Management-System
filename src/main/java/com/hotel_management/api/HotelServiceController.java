package com.hotel_management.api;

import com.hotel_management.api.core.domain.entity.HotelService;
import com.hotel_management.api.core.domain.entity.User;
import com.hotel_management.service.HotelServiceManagementService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/services")
public class HotelServiceController {

    @Autowired
    private HotelServiceManagementService hotelServiceManagementService;

    /**
     * Get all services
     */
    @GetMapping
    public ResponseEntity<?> getAllServices(HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(createErrorResponse("Vui lòng đăng nhập"));
            }

            List<HotelService> services = hotelServiceManagementService.getAllServices();
            return ResponseEntity.ok(services);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Lỗi: " + e.getMessage()));
        }
    }

    /**
     * Get filtered services
     */
    @GetMapping("/filter")
    public ResponseEntity<?> getFilteredServices(
            @RequestParam(required = false) String name,
            @RequestParam(required = false) com.hotel_management.api.core.domain.enums.ServiceType type,
            @RequestParam(required = false) java.math.BigDecimal minPrice,
            @RequestParam(required = false) java.math.BigDecimal maxPrice,
            HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(createErrorResponse("Vui lòng đăng nhập"));
            }

            List<HotelService> services = hotelServiceManagementService.getFilteredServices(name, type,
                    minPrice, maxPrice);
            return ResponseEntity.ok(services);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Lỗi: " + e.getMessage()));
        }
    }

    /**
     * Get service by ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<?> getServiceById(@PathVariable Long id, HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(createErrorResponse("Vui lòng đăng nhập"));
            }

            HotelService service = hotelServiceManagementService.getServiceById(id);
            return ResponseEntity.ok(service);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(createErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Lỗi: " + e.getMessage()));
        }
    }

    /**
     * Create new service
     */
    @PostMapping
    public ResponseEntity<?> createService(@RequestBody HotelService service, HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(createErrorResponse("Vui lòng đăng nhập"));
            }

            HotelService createdService = hotelServiceManagementService.createService(service);

            Map<String, Object> response = new HashMap<>();
            response.put("message", "Tạo dịch vụ thành công");
            response.put("service", createdService);
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
     * Update service
     */
    @PutMapping("/{id}")
    public ResponseEntity<?> updateService(
            @PathVariable Long id,
            @RequestBody HotelService service,
            HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(createErrorResponse("Vui lòng đăng nhập"));
            }

            HotelService updatedService = hotelServiceManagementService.updateService(id, service);

            Map<String, Object> response = new HashMap<>();
            response.put("message", "Cập nhật dịch vụ thành công");
            response.put("service", updatedService);
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
     * Delete service
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteService(@PathVariable Long id, HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(createErrorResponse("Vui lòng đăng nhập"));
            }

            hotelServiceManagementService.deleteService(id);

            Map<String, String> response = new HashMap<>();
            response.put("message", "Xóa dịch vụ thành công");
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
     * Toggle service status
     */
    @PatchMapping("/{id}/toggle-status")
    public ResponseEntity<?> toggleServiceStatus(@PathVariable Long id, HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(createErrorResponse("Vui lòng đăng nhập"));
            }

            HotelService updatedService = hotelServiceManagementService.toggleServiceStatus(id);

            Map<String, Object> response = new HashMap<>();
            response.put("message", "Cập nhật trạng thái thành công");
            response.put("service", updatedService);
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

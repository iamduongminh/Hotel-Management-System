package com.hotel_management.service;

import com.hotel_management.api.core.domain.entity.HotelService;
import com.hotel_management.repository.HotelServiceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class HotelServiceManagementService {

    @Autowired
    private HotelServiceRepository hotelServiceRepository;

    /**
     * Get all services
     */
    public List<HotelService> getAllServices() {
        return hotelServiceRepository.findAll();
    }

    /**
     * Get filtered services
     */
    public List<HotelService> getFilteredServices(
            String name,
            com.hotel_management.api.core.domain.enums.ServiceType type,
            java.math.BigDecimal minPrice,
            java.math.BigDecimal maxPrice) {

        return hotelServiceRepository.filterServices(name, type, minPrice, maxPrice);
    }

    /**
     * Get service by ID
     */
    @SuppressWarnings("null")
    public HotelService getServiceById(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("ID không được để trống");
        }
        return hotelServiceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy dịch vụ với ID: " + id));
    }

    /**
     * Create new service
     */
    @Transactional
    public HotelService createService(HotelService service) {
        // Validate required fields
        if (service.getName() == null || service.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Tên dịch vụ không được để trống");
        }
        if (service.getPrice() == null || service.getPrice().signum() < 0) {
            throw new IllegalArgumentException("Giá dịch vụ không hợp lệ");
        }

        // Set default values
        if (service.getActive() == null) {
            service.setActive(true);
        }

        return hotelServiceRepository.save(service);
    }

    /**
     * Update existing service
     */
    @Transactional
    public HotelService updateService(Long id, HotelService updatedService) {
        HotelService existingService = getServiceById(id);

        // Update fields
        if (updatedService.getName() != null && !updatedService.getName().trim().isEmpty()) {
            existingService.setName(updatedService.getName());
        }
        if (updatedService.getDescription() != null) {
            existingService.setDescription(updatedService.getDescription());
        }
        if (updatedService.getPrice() != null && updatedService.getPrice().signum() >= 0) {
            existingService.setPrice(updatedService.getPrice());
        }
        if (updatedService.getActive() != null) {
            existingService.setActive(updatedService.getActive());
        }
        if (updatedService.getType() != null) {
            existingService.setType(updatedService.getType());
        }

        @SuppressWarnings("null")
        HotelService saved = hotelServiceRepository.save(existingService);
        return saved;
    }

    /**
     * Delete service
     */
    @Transactional
    @SuppressWarnings("null")
    public void deleteService(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("ID không được để trống");
        }
        if (!hotelServiceRepository.existsById(id)) {
            throw new RuntimeException("Không tìm thấy dịch vụ với ID: " + id);
        }
        hotelServiceRepository.deleteById(id);
    }

    /**
     * Toggle service active status
     */
    @Transactional
    public HotelService toggleServiceStatus(Long id) {
        HotelService service = getServiceById(id);
        service.setActive(!service.getActive());
        return hotelServiceRepository.save(service);
    }
}

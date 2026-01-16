package com.hotel_management.repository;

import com.hotel_management.api.core.domain.entity.HotelService;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HotelServiceRepository extends JpaRepository<HotelService, Long> {
        @org.springframework.data.jpa.repository.Query("SELECT s FROM HotelService s WHERE " +
                        "(:name IS NULL OR LOWER(s.name) LIKE LOWER(CONCAT('%', :name, '%')) OR LOWER(s.description) LIKE LOWER(CONCAT('%', :name, '%'))) "
                        +
                        "AND (:type IS NULL OR s.type = :type) " +
                        "AND (:minPrice IS NULL OR s.price >= :minPrice) " +
                        "AND (:maxPrice IS NULL OR s.price <= :maxPrice) " +
                        "ORDER BY s.id DESC")
        List<HotelService> filterServices(
                        @org.springframework.data.repository.query.Param("name") String name,
                        @org.springframework.data.repository.query.Param("type") com.hotel_management.api.core.domain.enums.ServiceType type,
                        @org.springframework.data.repository.query.Param("minPrice") java.math.BigDecimal minPrice,
                        @org.springframework.data.repository.query.Param("maxPrice") java.math.BigDecimal maxPrice);
}

package com.hotel_management.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * Container class for all report-related DTOs
 */
public class ReportDTO {

    /**
     * DTO for room type distribution pie chart
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RoomTypeDistributionDTO {
        private String roomType;
        private Long count;
        private Double percentage;
    }

    /**
     * DTO for daily guest count bar chart
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DailyGuestCountDTO {
        private LocalDate date;
        private Long count;
    }

    /**
     * DTO for daily revenue bar chart
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DailyRevenueDTO {
        private LocalDate date;
        private BigDecimal revenue;
    }

    /**
     * DTO for service information
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ServiceInfoDTO {
        private Long id;
        private String name;
        private String type;
        private String description;
        private BigDecimal price;
    }

    /**
     * Response wrapper for room type distribution report
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RoomDistributionResponse {
        private List<RoomTypeDistributionDTO> distribution;
        private Long totalGuests;
    }

    /**
     * Response wrapper for daily guest count report
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DailyGuestResponse {
        private List<DailyGuestCountDTO> dailyCounts;
        private Long totalGuests;
    }

    /**
     * Response wrapper for daily revenue report
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DailyRevenueResponse {
        private List<DailyRevenueDTO> dailyRevenues;
        private BigDecimal totalRevenue;
    }

    /**
     * Response wrapper for services list
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ServicesResponse {
        private List<ServiceInfoDTO> services;
        private Integer totalServices;
    }
}

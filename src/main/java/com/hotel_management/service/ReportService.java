package com.hotel_management.service;

import com.hotel_management.api.core.domain.entity.HotelService;
import com.hotel_management.api.core.domain.enums.RoomType;
import com.hotel_management.dto.ReportDTO;
import com.hotel_management.repository.BookingRepository;
import com.hotel_management.repository.HotelServiceRepository;
import com.hotel_management.repository.InvoiceRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class ReportService {

    private final BookingRepository bookingRepository;
    private final InvoiceRepository invoiceRepository;
    private final HotelServiceRepository hotelServiceRepository;

    public ReportService(BookingRepository bookingRepository,
            InvoiceRepository invoiceRepository,
            HotelServiceRepository hotelServiceRepository) {
        this.bookingRepository = bookingRepository;
        this.invoiceRepository = invoiceRepository;
        this.hotelServiceRepository = hotelServiceRepository;
    }

    /**
     * Get room type distribution for pie chart
     */
    public ReportDTO.RoomDistributionResponse getRoomTypeDistribution(LocalDate startDate, LocalDate endDate) {
        LocalDateTime start = startDate.atStartOfDay();
        LocalDateTime end = endDate.plusDays(1).atStartOfDay();

        List<Object[]> rawData = bookingRepository.countBookingsByRoomType(start, end);
        Long totalGuests = bookingRepository.countBookingsInRange(start, end);

        List<ReportDTO.RoomTypeDistributionDTO> distribution = new ArrayList<>();

        for (Object[] row : rawData) {
            RoomType roomType = (RoomType) row[0];
            Long count = (Long) row[1];
            Double percentage = totalGuests > 0 ? (count * 100.0) / totalGuests : 0.0;

            distribution.add(new ReportDTO.RoomTypeDistributionDTO(
                    roomType != null ? roomType.name() : "UNKNOWN",
                    count,
                    Math.round(percentage * 100.0) / 100.0 // Round to 2 decimal places
            ));
        }

        return new ReportDTO.RoomDistributionResponse(distribution, totalGuests);
    }

    /**
     * Get daily guest count for bar chart
     */
    public ReportDTO.DailyGuestResponse getDailyGuestCount(LocalDate startDate, LocalDate endDate) {
        LocalDateTime start = startDate.atStartOfDay();
        LocalDateTime end = endDate.plusDays(1).atStartOfDay();

        List<Object[]> rawData = bookingRepository.countDailyGuestCheckIns(start, end);
        Long totalGuests = bookingRepository.countBookingsInRange(start, end);

        List<ReportDTO.DailyGuestCountDTO> dailyCounts = new ArrayList<>();

        // Create a map to fill in missing dates with zero
        Map<LocalDate, Long> dateCountMap = new HashMap<>();
        for (Object[] row : rawData) {
            LocalDate date = (LocalDate) row[0];
            Long count = (Long) row[1];
            dateCountMap.put(date, count);
        }

        // Fill in all dates in range
        LocalDate currentDate = startDate;
        while (!currentDate.isAfter(endDate)) {
            Long count = dateCountMap.getOrDefault(currentDate, 0L);
            dailyCounts.add(new ReportDTO.DailyGuestCountDTO(currentDate, count));
            currentDate = currentDate.plusDays(1);
        }

        return new ReportDTO.DailyGuestResponse(dailyCounts, totalGuests);
    }

    /**
     * Get daily revenue for bar chart
     */
    public ReportDTO.DailyRevenueResponse getDailyRevenue(LocalDate startDate, LocalDate endDate) {
        LocalDateTime start = startDate.atStartOfDay();
        LocalDateTime end = endDate.plusDays(1).atStartOfDay();

        List<Object[]> rawData = invoiceRepository.calculateDailyRevenue(start, end);
        BigDecimal totalRevenue = invoiceRepository.calculateTotalRevenue(start, end);

        List<ReportDTO.DailyRevenueDTO> dailyRevenues = new ArrayList<>();

        // Create a map to fill in missing dates with zero
        Map<LocalDate, BigDecimal> dateRevenueMap = new HashMap<>();
        for (Object[] row : rawData) {
            LocalDate date = (LocalDate) row[0];
            BigDecimal revenue = (BigDecimal) row[1];
            dateRevenueMap.put(date, revenue);
        }

        // Fill in all dates in range
        LocalDate currentDate = startDate;
        while (!currentDate.isAfter(endDate)) {
            BigDecimal revenue = dateRevenueMap.getOrDefault(currentDate, BigDecimal.ZERO);
            dailyRevenues.add(new ReportDTO.DailyRevenueDTO(currentDate, revenue));
            currentDate = currentDate.plusDays(1);
        }

        return new ReportDTO.DailyRevenueResponse(dailyRevenues, totalRevenue);
    }

    /**
     * Get all available services
     */
    public ReportDTO.ServicesResponse getAvailableServices() {
        List<HotelService> services = hotelServiceRepository.findAll();

        List<ReportDTO.ServiceInfoDTO> serviceInfoList = services.stream()
                .filter(HotelService::getActive)
                .map(service -> new ReportDTO.ServiceInfoDTO(
                        service.getId(),
                        service.getName(),
                        service.getType() != null ? service.getType().name() : "OTHER",
                        service.getDescription(),
                        service.getPrice()))
                .collect(Collectors.toList());

        return new ReportDTO.ServicesResponse(serviceInfoList, serviceInfoList.size());
    }
}

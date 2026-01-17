package com.hotel_management.api;

import com.hotel_management.dto.ReportDTO;
import com.hotel_management.service.ReportService;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;

@RestController
@RequestMapping("/api/manager/reports")
public class ManagerReportController {

    private final ReportService reportService;

    public ManagerReportController(ReportService reportService) {
        this.reportService = reportService;
    }

    /**
     * Get room type distribution for operational report
     * GET
     * /api/manager/reports/operational/room-distribution?start=2026-01-01&end=2026-01-31
     */
    @GetMapping("/operational/room-distribution")
    public ResponseEntity<ReportDTO.RoomDistributionResponse> getRoomDistribution(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate end) {
        return ResponseEntity.ok(reportService.getRoomTypeDistribution(start, end));
    }

    /**
     * Get daily guest count for operational report
     * GET
     * /api/manager/reports/operational/daily-guests?start=2026-01-01&end=2026-01-31
     */
    @GetMapping("/operational/daily-guests")
    public ResponseEntity<ReportDTO.DailyGuestResponse> getDailyGuests(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate end) {
        return ResponseEntity.ok(reportService.getDailyGuestCount(start, end));
    }

    /**
     * Get daily revenue for financial report
     * GET
     * /api/manager/reports/financial/daily-revenue?start=2026-01-01&end=2026-01-31
     */
    @GetMapping("/financial/daily-revenue")
    public ResponseEntity<ReportDTO.DailyRevenueResponse> getDailyRevenue(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate end) {
        return ResponseEntity.ok(reportService.getDailyRevenue(start, end));
    }

    /**
     * Get available services for financial report
     * GET /api/manager/reports/financial/services
     */
    @GetMapping("/financial/services")
    public ResponseEntity<ReportDTO.ServicesResponse> getServices(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate start,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate end) {
        // Default to last 30 days if no date provided
        if (start == null)
            start = LocalDate.now().minusDays(30);
        if (end == null)
            end = LocalDate.now();
        return ResponseEntity.ok(reportService.getTopUsedServices(start, end));
    }
}

package com.hotel_management.api;

import com.hotel_management.dto.DashboardData;
import com.hotel_management.service.DashboardService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/manager")
public class ManagerDashboardController {
    private final DashboardService dashboardService;

    public ManagerDashboardController(DashboardService dashboardService) {
        this.dashboardService = dashboardService;
    }

    @GetMapping("/dashboard")
    public ResponseEntity<DashboardData> dashboard() {
        return ResponseEntity.ok(dashboardService.getDashboardMetrics());
    }
}
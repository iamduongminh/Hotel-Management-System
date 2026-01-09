package com.hotel_management.api.core.patterns.factory;

import com.hotel_management.dto.ReportRequest;
import org.springframework.stereotype.Service;

@Service
public class ReportFactory {
    private final RevenueReport revenue;
    private final OccupancyReport occupancy;

    public ReportFactory(RevenueReport revenue, OccupancyReport occupancy) {
        this.revenue = revenue;
        this.occupancy = occupancy;
    }

    public IReport createReport(ReportRequest.ReportingType type) {
        return switch (type) {
            case REVENUE -> revenue;
            case OCCUPANCY -> occupancy;
        };
    }
}
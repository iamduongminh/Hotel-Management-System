package com.hotel_management.service;

import com.hotel_management.api.core.patterns.factory.IReport;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.Map;

@Service
public class ReportExportService {
    public String export(IReport report, LocalDateTime start, LocalDateTime end) {
        Map<String, Object> data = report.generate();
        return "Exported report: " + data.toString() + " from " + start + " to " + end;
    }
}
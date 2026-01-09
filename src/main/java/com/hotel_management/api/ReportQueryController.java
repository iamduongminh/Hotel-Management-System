package com.hotel_management.api;

import com.hotel_management.api.core.patterns.factory.IReport;
import com.hotel_management.api.core.patterns.factory.ReportFactory;
import com.hotel_management.dto.ReportRequest;
import com.hotel_management.service.ReportExportService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/reports")
public class ReportQueryController {
    private final ReportFactory factory;
    private final ReportExportService exportService;

    public ReportQueryController(ReportFactory factory, ReportExportService exportService) {
        this.factory = factory;
        this.exportService = exportService;
    }

    @PostMapping("/export")
    public ResponseEntity<String> export(@RequestBody ReportRequest req) {
        IReport report = factory.createReport(req.getType());
        String result = exportService.export(report, req.getStart(), req.getEnd());
        return ResponseEntity.ok(result);
    }
}
package com.hotel_management.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ReportRequest {
    public enum ReportingType { REVENUE, OCCUPANCY }
    
    private ReportingType type;
    private LocalDateTime start;
    private LocalDateTime end;
}
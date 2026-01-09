package com.hotel_management.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ReportRequest {
    public enum ReportingType { REVENUE, OCCUPANCY }
    
    @NotNull
    private ReportingType type;
    
    @NotNull
    private LocalDateTime start;
    
    @NotNull
    private LocalDateTime end;
}
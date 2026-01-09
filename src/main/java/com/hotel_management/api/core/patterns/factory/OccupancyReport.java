package com.hotel_management.api.core.patterns.factory;

import org.springframework.stereotype.Component;
import java.util.HashMap;
import java.util.Map;

@Component
public class OccupancyReport implements IReport {
    @Override
    public Map<String, Object> generate() {
        Map<String, Object> data = new HashMap<>();
        data.put("type", "OCCUPANCY");
        data.put("rate", "85%");
        return data;
    }
}
package com.hotel_management.api.core.patterns.factory;
import org.springframework.stereotype.Component;
import java.util.Map;

@Component
public class RevenueReport implements IReport {
    @Override
    public Map<String, Object> generate() {
        return Map.of("Type", "Revenue", "Total", 50000000);
    }
}
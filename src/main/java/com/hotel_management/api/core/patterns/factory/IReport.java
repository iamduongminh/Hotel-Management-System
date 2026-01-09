package com.hotel_management.api.core.patterns.factory;
import java.util.Map;

public interface IReport {
    Map<String, Object> generate();
}
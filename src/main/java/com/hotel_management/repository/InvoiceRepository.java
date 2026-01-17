package com.hotel_management.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.hotel_management.api.core.domain.entity.Invoice;
import java.time.LocalDateTime;
import java.math.BigDecimal;

public interface InvoiceRepository extends JpaRepository<Invoice, Long> {

    // Report queries - Daily revenue
    @Query("SELECT CAST(i.createdAt AS LocalDate), SUM(i.totalAmount) FROM Invoice i " +
            "WHERE i.createdAt >= :start AND i.createdAt < :end " +
            "GROUP BY CAST(i.createdAt AS LocalDate) " +
            "ORDER BY CAST(i.createdAt AS LocalDate)")
    java.util.List<Object[]> calculateDailyRevenue(
            @Param("start") LocalDateTime start,
            @Param("end") LocalDateTime end);

    // Calculate total revenue in date range
    @Query("SELECT COALESCE(SUM(i.totalAmount), 0) FROM Invoice i " +
            "WHERE i.createdAt >= :start AND i.createdAt < :end")
    BigDecimal calculateTotalRevenue(
            @Param("start") LocalDateTime start,
            @Param("end") LocalDateTime end);
}
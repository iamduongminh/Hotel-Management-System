package com.hotel_management.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hotel_management.api.core.domain.entity.Booking;

public interface BookingRepository extends JpaRepository<Booking, Long> {
}
package com.hotel_management.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hotel_management.api.core.domain.entity.Customer;

public interface CustomerRepository extends JpaRepository<Customer, Long> {
}
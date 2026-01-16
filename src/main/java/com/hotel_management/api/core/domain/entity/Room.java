package com.hotel_management.api.core.domain.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.math.BigDecimal; // Import bắt buộc cho kiểu tiền tệ

import com.hotel_management.api.core.domain.enums.RoomStatus;
import com.hotel_management.api.core.domain.enums.RoomType;

@Entity
@Table(name = "rooms")
@Data
public class Room {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String roomNumber;

    @Column(precision = 19, scale = 2)
    private BigDecimal price;

    @Enumerated(EnumType.STRING)
    private RoomType type;

    @Column(length = 50)
    private RoomStatus status;

    private String branchName; // Link to branch
}
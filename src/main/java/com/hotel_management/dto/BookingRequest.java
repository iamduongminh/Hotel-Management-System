package com.hotel_management.dto;

import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class BookingRequest {
    @NotNull(message = "Tên khách hàng là bắt buộc")
    private String customerName;
    
    // Thêm cái này để check trùng khách
    @NotNull(message = "CCCD/CMND là bắt buộc") 
    private String identityNumber; 

    @NotNull(message = "Chưa chọn phòng")
    private Long roomId;

    @NotNull
    @Future(message = "Ngày check-in phải là tương lai") // Không cho book lùi ngày
    private LocalDateTime checkInDate;

    @NotNull
    @Future
    private LocalDateTime checkOutDate;
}
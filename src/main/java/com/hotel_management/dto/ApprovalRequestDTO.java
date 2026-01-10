package com.hotel_management.dto;

public class ApprovalRequestDTO {
    private Long id;
    private Long bookingId;
    private String requestType; // "DISCOUNT", "REFUND", "CANCEL"
    private String customerName;
    private String reason;
    private String status; // "PENDING", "APPROVED", "REJECTED"
    private Integer discountPercent;

    // Constructors
    public ApprovalRequestDTO() {
    }

    public ApprovalRequestDTO(Long id, Long bookingId, String requestType,
            String customerName, String reason, String status) {
        this.id = id;
        this.bookingId = bookingId;
        this.requestType = requestType;
        this.customerName = customerName;
        this.reason = reason;
        this.status = status;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getBookingId() {
        return bookingId;
    }

    public void setBookingId(Long bookingId) {
        this.bookingId = bookingId;
    }

    public String getRequestType() {
        return requestType;
    }

    public void setRequestType(String requestType) {
        this.requestType = requestType;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(Integer discountPercent) {
        this.discountPercent = discountPercent;
    }
}

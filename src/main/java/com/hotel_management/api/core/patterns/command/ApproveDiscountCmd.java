package com.hotel_management.api.core.patterns.command;

public class ApproveDiscountCmd implements ICommand {
    private final Long bookingId;
    private final int discountPercent;

    public ApproveDiscountCmd(Long bookingId, int discountPercent) {
        this.bookingId = bookingId;
        this.discountPercent = discountPercent;
    }

    @Override
    public void execute() {
        // Logic thực tế: Gọi BookingService để cập nhật giá tiền (Hiện tại chỉ in ra console)
        System.out.println("Approved " + discountPercent + "% discount for booking " + bookingId);
    }

    @Override
    public String toString() {
        return "Approved " + discountPercent + "% discount for booking #" + bookingId;
    }
}
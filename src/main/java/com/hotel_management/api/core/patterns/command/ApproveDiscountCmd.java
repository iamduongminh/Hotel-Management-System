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
        System.out.println("Approved " + discountPercent + "% discount for booking " + bookingId);
    }
}
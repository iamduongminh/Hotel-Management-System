package com.hotel_management.api.core.patterns.command;

public class RejectRequestCmd implements ICommand {
    private final Long bookingId;
    private final String reason;

    public RejectRequestCmd(Long bookingId, String reason) {
        this.bookingId = bookingId;
        this.reason = reason;
    }

    @Override
    public void execute() {
        System.out.println("Rejected booking " + bookingId + " due to: " + reason);
    }
}
package com.hotel_management.service;

import com.hotel_management.api.core.patterns.command.ICommand;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;

@Service
public class ApprovalWorkflowService {
    private final List<ICommand> commandHistory = new ArrayList<>();

    public void executeCommand(ICommand cmd) {
        cmd.execute();
        commandHistory.add(cmd);
    }
}
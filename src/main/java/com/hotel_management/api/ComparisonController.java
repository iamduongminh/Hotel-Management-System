package com.hotel_management.api;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/comparison")
public class ComparisonController {
    @GetMapping("/branches")
    public ResponseEntity<String> compareBranches(@RequestParam String branchIds) {
        List<Integer> ids = Arrays.stream(branchIds.split(","))
                .map(String::trim)
                .map(Integer::parseInt)
                .collect(Collectors.toList());
        return ResponseEntity.ok("Comparing branches: " + ids);
    }
}
package com.hotel_management.util;

import org.junit.jupiter.api.Test;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class RealPasswordGenTest {
    @Test
    public void generateFullSQL() {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("ddMMyyyy");

        System.out.println("SQL_START");

        // Managers
        print(encoder, dtf, 10001, "ducnt", "Nguyễn Trung Đức", "MANAGER", LocalDate.of(1985, 10, 15), "0912345001",
                "ducnt@0001.grandhotel.com");
        print(encoder, dtf, 10002, "minhdq", "Dương Quang Minh", "MANAGER", LocalDate.of(1987, 4, 10), "0912345002",
                "minhdq@0002.grandhotel.com");

        // Admins
        print(encoder, dtf, 20001, "vanna", "Nguyễn Anh Văn", "ADMIN", LocalDate.of(1990, 5, 20), "0912345003",
                "vanna@0001.grandhotel.com");
        print(encoder, dtf, 20002, "duongnq", "Nguyễn Quang Dương", "ADMIN", LocalDate.of(1992, 8, 25), "0912345004",
                "duongnq@0002.grandhotel.com");
        print(encoder, dtf, 20003, "nguyennt", "Ngô Triệu Nguyên", "ADMIN", LocalDate.of(1991, 12, 30), "0912345005",
                "nguyennt@0003.grandhotel.com");
        print(encoder, dtf, 20004, "binhbth", "Bùi Trần Hà Bình", "ADMIN", LocalDate.of(1989, 3, 15), "0912345006",
                "binhbth@0004.grandhotel.com");
        print(encoder, dtf, 20005, "anhk", "Nguyễn Khánh Anh", "ADMIN", LocalDate.of(1993, 7, 8), "0912345007",
                "anhk@0005.grandhotel.com");

        // Receptionists
        print(encoder, dtf, 30001, "linhntt", "Nguyễn Thị Thanh Linh", "RECEPTIONIST", LocalDate.of(1995, 6, 12),
                "0912345008", "linhntt@0001.grandhotel.com");
        print(encoder, dtf, 30002, "hoanv", "Nguyễn Văn Hoà", "RECEPTIONIST", LocalDate.of(1996, 9, 18), "0912345009",
                "hoanv@0002.grandhotel.com");
        print(encoder, dtf, 30003, "thuylt", "Lê Thị Thùy", "RECEPTIONIST", LocalDate.of(1997, 2, 25), "0912345010",
                "thuylt@0003.grandhotel.com");
        print(encoder, dtf, 30004, "quanpt", "Phạm Tiến Quân", "RECEPTIONIST", LocalDate.of(1998, 11, 3), "0912345011",
                "quanpt@0004.grandhotel.com");
        print(encoder, dtf, 30005, "mynh", "Ngô Hà My", "RECEPTIONIST", LocalDate.of(1996, 4, 16), "0912345012",
                "mynh@0005.grandhotel.com");
        print(encoder, dtf, 30006, "tungnv", "Nguyễn Văn Tùng", "RECEPTIONIST", LocalDate.of(1995, 8, 22), "0912345013",
                "tungnv@0006.grandhotel.com");
        print(encoder, dtf, 30007, "huyenttm", "Trần Thị Minh Huyền", "RECEPTIONIST", LocalDate.of(1997, 1, 30),
                "0912345014", "huyenttm@0007.grandhotel.com");
        print(encoder, dtf, 30008, "datpv", "Phạm Văn Đạt", "RECEPTIONIST", LocalDate.of(1998, 5, 14), "0912345015",
                "datpv@0008.grandhotel.com");
        print(encoder, dtf, 30009, "hanhtt", "Trần Thị Hạnh", "RECEPTIONIST", LocalDate.of(1996, 12, 7), "0912345016",
                "hanhtt@0009.grandhotel.com");
        print(encoder, dtf, 30010, "phongnd", "Nguyễn Đức Phong", "RECEPTIONIST", LocalDate.of(1995, 3, 28),
                "0912345017", "phongnd@0010.grandhotel.com");
        print(encoder, dtf, 30011, "chinh", "Ngô Hải Chi", "RECEPTIONIST", LocalDate.of(1997, 10, 11), "0912345018",
                "chinh@0011.grandhotel.com");
        print(encoder, dtf, 30012, "longth", "Trần Hoàng Long", "RECEPTIONIST", LocalDate.of(1998, 7, 19), "0912345019",
                "longth@0012.grandhotel.com");

        System.out.println("SQL_END");
    }

    private void print(BCryptPasswordEncoder encoder, DateTimeFormatter dtf, long id, String username, String fullName,
            String role, LocalDate dob, String phone, String email) {
        String rawPass = username + role.toLowerCase() + dob.format(dtf);
        String hash = encoder.encode(rawPass);
        // Using comma at the end for bulk insert
        System.out.printf("(%d, '%s', '%s', '%s', '%s', '%s', '%s', '%s'),%n",
                id, username, hash, fullName, role, dob, phone, email);
    }
}

# Grand Hotel Management System

Hệ thống quản lý khách sạn (Web Application) được xây dựng bằng **Java Spring Boot** và **MySQL**, với giao diện HTML/CSS/JS thuần.

---

## Yêu cầu hệ thống

Để chạy dự án này, bạn cần cài đặt:
1.  **JDK 17** trở lên.
2.  **Maven** (để quản lý thư viện và build).
3.  **MySQL Server** (để lưu trữ dữ liệu).
4.  **Git** (để clone dự án).

---

## Hướng dẫn cài đặt & Chạy

### Bước 1: Clone dự án
Mở terminal/command prompt và chạy lệnh:
```bash
git clone <URL_REPO_CUA_BAN>
cd hotel_management_sytem_web
```

### Bước 2: Cài đặt cơ sở dữ liệu
1.  Mở MySQL Workbench hoặc công cụ quản lý DB bất kỳ.
2.  **Chạy lần lượt các script sau theo thứ tự:**
    - **Bước 2.1**: Chạy `src/main/resources/database_init.sql`  
      *(Script này sẽ tự động xóa DB cũ (nếu có), tạo DB `hotel_db` mới, tạo bảng và insert dữ liệu cơ bản)*
    - **Bước 2.2**: Chạy `src/main/resources/manager_test_data.sql`  
      *(Script này sẽ thêm dữ liệu test cho Manager Reports - bookings, invoices, services)*

### Bước 3: Cấu hình kết nối
Mở file `src/main/resources/application.properties` và cập nhật thông tin MySQL của bạn:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/hotel_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=<YOUR_DB_PASSWORD>  <-- Đổi thành mật khẩu MySQL của bạn
```

### Bước 4: Chạy ứng dụng
Tại thư mục gốc của dự án, chạy lệnh:
```bash
mvn spring-boot:run
```
*(Hoặc mở dự án bằng IntelliJ IDEA / Eclipse và chạy file `HotelManagementApplication.java`)*

---

## Truy cập & Tài khoản demo

Sau khi chạy thành công, truy cập trình duyệt tại:  
**http://localhost:8080**

### Tài khoản mẫu
Dữ liệu người dùng được khởi tạo trong `database_init.sql`.

| Vai trò (Role) | Username | Password | Ghi chú |
| :--- | :--- | :--- | :--- |
| **Manager** | `ducnt` | `ducntmanager15101985` | Quản lý khách sạn |
| **Admin** | `vanna` | `vannaadmin20051990` | Quản trị hệ thống/IT |
| **Receptionist** | `linhntt`| `linhnttreceptionist12061995` | Lễ tân |

> **⚠️ Lưu ý về Mật khẩu:**  
> Mật khẩu trong DB đã được mã hóa bằng BCrypt.
> Nếu bạn muốn đổi mật khẩu, bạn cần dùng công cụ tạo mã hash BCrypt online (ví dụ: https://bcrypt-generator.com/) để tạo chuỗi hash mới, sau đó cập nhật trực tiếp vào bảng `users` trong cơ sở dữ liệu.
> (Ví dụ: hash của `123456` là `$2a$12$R9h/cIPz0gi.URNNX3kh2OPST9/PgBkqquii.VNQJxQ6y9jgCheck`).

---

## Cấu trúc dự án

```
hotel_management_sytem_web/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── hotel_management/
│   │   │           ├── api/            # API Controllers: Các endpoint xử lý HTTP request (REST API)
│   │   │           │   └── core/       # Core Domain: Chứa Entities, Enums và Design Patterns
│   │   │           ├── dto/            # DTOs: Đối tượng truyền dữ liệu giữa Client-Server
│   │   │           ├── exception/      # Exception Handling: Xử lý lỗi tập trung
│   │   │           ├── infrastructure/ # Config & System: Cấu hình hệ thống (Session, Security)
│   │   │           ├── repository/     # Repositories: Lớp giao tiếp với Database (JPA)
│   │   │           ├── service/        # Services: Chứa logic nghiệp vụ chính của hệ thống
│   │   │           └── util/           # Utilities: Các công cụ tiện ích dùng chung
│   │   └── resources/
│   │       ├── application.properties  # File cấu hình chính (Database, Server port)
│   │       ├── hotel_db_init.sql       # Script khởi tạo Database (Schema & Data)
│   │       └── static/                 # Frontend Resources (HTML/CSS/JS thuần)
│   │           ├── assets/             # Assets: Hình ảnh, icons
│   │           ├── css/                # CSS: Stylesheets cho giao diện
│   │           ├── js/                 # JavaScript: Logic xử lý client-side (tương tác UI, gọi API)
│   │           │   ├── admin/          # JS cho trang Admin
│   │           │   ├── auth/           # JS cho Đăng nhập/Quên mật khẩu
│   │           │   ├── manager/        # JS cho trang Quản lý (Báo cáo, Dashboard)
│   │           │   └── receptionist/   # JS cho Lễ tân (Đặt phòng, Check-in/out)
│   │           └── pages/              # HTML Templates: Các trang màn hình giao diện
│   │               ├── admin/          # Màn hình Admin
│   │               ├── auth/           # Màn hình Authentication
│   │               ├── manager/        # Màn hình Manager
│   │               └── receptionist/   # Màn hình Receptionist
│   └── test/                           # Unit Tests & Integration Tests
```

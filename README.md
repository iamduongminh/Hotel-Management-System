
```
hotel_management_sytem_web
├─ .mvn
│  └─ wrapper
│     └─ maven-wrapper.properties
├─ mvnw
├─ mvnw.cmd
├─ pom.xml
├─ README.md
└─ src
   ├─ main
   │  └─ java
   │     ├─ com
   │     │  └─ hotel_management
   │     │     ├─ api
   │     │     │  ├─ AuthController.java
   │     │     │  ├─ BookingController.java
   │     │     │  ├─ CheckInController.java
   │     │     │  ├─ CheckOutController.java
   │     │     │  ├─ ComparisonController.java
   │     │     │  ├─ core
   │     │     │  │  ├─ domain
   │     │     │  │  │  ├─ entity
   │     │     │  │  │  │  ├─ Booking.java
   │     │     │  │  │  │  ├─ Customer.java
   │     │     │  │  │  │  ├─ Invoice.java
   │     │     │  │  │  │  ├─ Room.java
   │     │     │  │  │  │  └─ User.java
   │     │     │  │  │  └─ enums
   │     │     │  │  │     ├─ BookingStatus.java
   │     │     │  │  │     ├─ IdentityType.java
   │     │     │  │  │     ├─ PaymentType.java
   │     │     │  │  │     ├─ RoomStatus.java
   │     │     │  │  │     ├─ RoomType.java
   │     │     │  │  │     └─ UserRole.java
   │     │     │  │  └─ patterns
   │     │     │  │     ├─ command
   │     │     │  │     │  ├─ ApproveDiscountCmd.java
   │     │     │  │     │  ├─ ICommand.java
   │     │     │  │     │  └─ RejectRequestCmd.java
   │     │     │  │     ├─ facade
   │     │     │  │     │  └─ CheckOutFacade.java
   │     │     │  │     ├─ factory
   │     │     │  │     │  ├─ IReport.java
   │     │     │  │     │  ├─ OccupancyReport.java
   │     │     │  │     │  ├─ ReportFactory.java
   │     │     │  │     │  └─ RevenueReport.java
   │     │     │  │     ├─ observer
   │     │     │  │     │  ├─ IObserver.java
   │     │     │  │     │  └─ ISubject.java
   │     │     │  │     └─ strategy
   │     │     │  │        ├─ BankTransferPayment.java
   │     │     │  │        ├─ CardPayment.java
   │     │     │  │        ├─ CashPayment.java
   │     │     │  │        ├─ IPaymentStrategy.java
   │     │     │  │        └─ PaymentFactory.java
   │     │     │  ├─ HousekeepingController.java
   │     │     │  ├─ ManagerDashboardController.java
   │     │     │  ├─ ReceptionController.java
   │     │     │  ├─ ReportQueryController.java
   │     │     │  └─ ShiftWorkController.java
   │     │     ├─ dto
   │     │     │  ├─ BookingRequest.java
   │     │     │  ├─ LoginRequest.java
   │     │     │  ├─ PaymentRequest.java
   │     │     │  └─ ReportRequest.java
   │     │     ├─ HotelManagementApplication.java
   │     │     ├─ infrastructure
   │     │     │  ├─ SessionManager.java
   │     │     │  └─ SystemConfig.java
   │     │     ├─ repository
   │     │     │  ├─ BookingRepository.java
   │     │     │  ├─ CustomerRepository.java
   │     │     │  ├─ InvoiceRepository.java
   │     │     │  ├─ RoomRepository.java
   │     │     │  └─ UserRepository.java
   │     │     └─ service
   │     │        ├─ ApprovalWorkflowService.java
   │     │        ├─ AuthService.java
   │     │        ├─ BookingService.java
   │     │        ├─ ReportExportService.java
   │     │        └─ RoomService.java
   │     └─ resources
   │        ├─ application.properties
   │        └─ static
   │           ├─ assets
   │           │  ├─ icons
   │           │  └─ images
   │           ├─ css
   │           │  └─ style.css
   │           ├─ index.html
   │           ├─ js
   │           │  ├─ auth
   │           │  │  └─ login.js
   │           │  ├─ common
   │           │  │  └─ config.js
   │           │  ├─ manager
   │           │  │  └─ dashboard.js
   │           │  └─ staff
   │           │     └─ booking.js
   │           └─ pages
   │              ├─ admin
   │              │  └─ dashboard.html
   │              ├─ auth
   │              │  └─ login.html
   │              └─ staff
   │                 └─ booking-list.html
   └─ test

```
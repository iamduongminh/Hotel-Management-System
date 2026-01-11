# LOGIN CREDENTIALS - Hotel Chain Management System

## Organizational Structure

### 5 Cities → 16 Branches → ~1,700 Employees

| City | Branches | Regional Manager |
|------|----------|-----------------|
| Hà Nội | 4 | Dương Quang Minh |
| Hồ Chí Minh | 4 | Nguyễn Thị Lan |
| Đà Nẵng | 3 | Trần Văn Hưng |
| Đà Lạt | 3 | Phạm Thị Hương |
| Phú Quốc | 2 | Lê Văn Thành |

---

## Test Accounts

### 🌟 Regional Managers (Lãnh đạo cấp khu vực)

| Username | Password | Full Name | City |
|----------|----------|-----------|------|
| `DuongQuangMinh` | `MinhRM150585` | Dương Quang Minh | Hà Nội |
| `NguyenThiLan` | `LanRM220883` | Nguyễn Thị Lan | Hồ Chí Minh |
| `TranVanHung` | `HungRM100387` | Trần Văn Hưng | Đà Nẵng |
| `PhamThiHuong` | `HuongRM051286` | Phạm Thị Hương | Đà Lạt |
| `LeVanThanh` | `ThanhRM180784` | Lê Văn Thành | Phú Quốc |

**Dashboard:** `/pages/manager/dashboard.html` (Quản lý kinh doanh, báo cáo, hiệu suất)

---

### 🏨 Branch Managers (Quản lý chi nhánh) - Samples

| Username | Password | Full Name | City | Branch |
|----------|----------|-----------|------|--------|
| `HoangVanAnh` | `AnhBM120488` | Hoàng Văn Anh | Hà Nội | Ba Đình Hotel |
| `VuThiMai` | `MaiBM250989` | Vũ Thị Mai | Hà Nội | Hoàn Kiếm Hotel |
| `NguyenVanBinh` | `BinhBM140288` | Nguyễn Văn Bình | Hồ Chí Minh | Quận 1 Hotel |
| `VoVanPhuc` | `PhucBM221087` | Võ Văn Phúc | Đà Nẵng | Hải Châu Hotel |

**Dashboard:** `/pages/manager/dashboard.html` (Quản lý kinh doanh, doanh thu, nhân sự)

---

### 💻 IT Administrators (Quản trị viên hệ thống) - Samples

| Username | Password | Full Name | Branch |
|----------|----------|-----------|--------|
| `TruongVanA` | `AADM120392` | Trương Văn A | Ba Đình Hotel |
| `NguyenThiB` | `BADM180793` | Nguyễn Thị B | Ba Đình Hotel |
| `LeVanC` | `CADM251191` | Lê Văn C | Ba Đình Hotel |
| `PhamThiD` | `DADM080594` | Phạm Thị D | Ba Đình Hotel |

**Dashboard:** `/pages/admin/dashboard.html` (Quản trị hệ thống, công nghệ, database)

---

### 👔 Receptionists (Lễ tân) - Samples

| Username | Password | Full Name | Branch |
|----------|----------|-----------|--------|
| `NguyenVanTuan` | `TuanREC150695` | Nguyễn Văn Tuấn | Ba Đình Hotel |
| `TranThiHoa` | `HoaREC220896` | Trần Thị Hoa | Ba Đình Hotel |
| `LeThiLinh` | `LinhREC100297` | Lê Thị Linh | Ba Đình Hotel |
| `PhamVanDat` | `DatREC051295` | Phạm Văn Đạt | Ba Đình Hotel |

**Dashboard:** `/pages/staff/staff_dashboard.html` (Đặt phòng, check-in/out)

---

### 🧹 Housekeepers (Nhân viên dọn phòng) - Samples

| Username | Password | Full Name | Branch |
|----------|----------|-----------|--------|
| `BuiVanNam` | `NamHSK270994` | Bùi Văn Nam | Ba Đình Hotel |
| `DaoThiOanh` | `OanhHSK141196` | Đào Thị Oanh | Ba Đình Hotel |
| `NguyenVanPhong` | `PhongHSK030795` | Nguyễn Văn Phong | Ba Đình Hotel |
| `TranThiQuyen` | `QuyenHSK200197` | Trần Thị Quyên | Ba Đình Hotel |

**Dashboard:** `/pages/staff/staff_dashboard.html` (Trạng thái phòng, dọn dẹp)

---

## Password Format

`FirstName` + `RoleAbbr` + `DDMMYY`

**Examples:**
- Dương Quang Minh, RM, 15/05/85 → `MinhRM150585`
- Hoàng Văn Anh, BM, 12/04/88 → `AnhBM120488`
- Trương Văn A, ADMIN, 12/03/92 → `AADM120392`
- Nguyễn Văn Tuấn, REC, 15/06/95 → `TuanREC150695`
- Bùi Văn Nam, HSK, 27/09/94 → `NamHSK270994`

---

## Role Abbreviations

| Role | Abbr | Vietnamese | Dashboard |
|------|------|------------|-----------|
| REGIONAL_MANAGER | RM | Lãnh đạo khu vực | Manager Dashboard |
| BRANCH_MANAGER | BM | Quản lý chi nhánh | Manager Dashboard |
| ADMIN | ADM | Quản trị viên IT | Admin Dashboard |
| RECEPTIONIST | REC | Lễ tân | Staff Dashboard |
| HOUSEKEEPER | HSK | Dọn phòng | Staff Dashboard |

---

## Next Steps

1. ✅ Run SQL script: `hotel_database_realistic.sql`
2. ⏳ Compile backend: `mvnw.cmd clean compile`
3. ⏳ Restart server
4. ⏳ Create `/pages/manager/dashboard.html` (copy from admin dashboard)
5. ⏳ Test login with different roles
6. ⏳ Generate full 1,700 users programmatically (optional)

---

## Notes

- Current SQL script has ~30 sample users
- Full implementation needs programmatic generation for 1,700 users
- All passwords use bcrypt hashing (shown hashes are placeholders)
- Manager dashboard needs to be created from admin template

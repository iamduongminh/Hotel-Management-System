
document.addEventListener('DOMContentLoaded', function () {
    const currentUser = getCurrentUser();
    if (!currentUser) {
        window.location.href = '/pages/auth/login.html';
        return;
    }

    if (document.getElementById('user-fullname')) {
        document.getElementById('user-fullname').textContent = currentUser.fullName;
        document.getElementById('user-role-display').textContent = currentUser.role;
    }

    updateSidebarForRole(currentUser.role);
});

async function startShift() {
    const startCash = document.getElementById('startCash').value;
    if (startCash === "") {
        showWarning("Vui lòng nhập tiền đầu ca!");
        return;
    }

    try {
        // Gọi API ShiftWorkController
        const msg = await callAPI(`/shift/start?initialCash=${startCash}`, 'POST');

        document.getElementById('shift-status').innerHTML = `<span style="color:green; font-weight:bold;">${msg}</span>`;
        showSuccess("Đã bắt đầu ca làm việc!");
    } catch (error) {
        showError("Lỗi: " + error.message);
    }
}

async function endShift() {
    const endCash = document.getElementById('endCash').value;
    if (endCash === "") {
        showWarning("Vui lòng nhập tiền cuối ca!");
        return;
    }

    try {
        const msg = await callAPI(`/shift/end?finalCash=${endCash}`, 'POST');

        document.getElementById('shift-status').innerHTML = `<span style="color:blue; font-weight:bold;">${msg}</span>`;
        showSuccess("🏁 Đã kết thúc ca làm việc!");
    } catch (error) {
        showError("Lỗi: " + error.message);
    }
}

/**
 * Update sidebar links based on role
 */
function updateSidebarForRole(role) {
    const sidebar = document.querySelector('.sidebar');
    if (!sidebar) return;

    if (role === 'BRANCH_MANAGER') {
        sidebar.innerHTML = `
            <h3><i class="fas fa-user-tie"></i> Quản Lý Chi Nhánh</h3>
            <a href="../manager/branch_dashboard.html"><i class="fas fa-chart-line"></i> Dashboard</a>
            <a href="room_management.html"><i class="fas fa-door-open"></i> Quản Lý Phòng</a>
            <a href="../admin/reports.html"><i class="fas fa-file-alt"></i> Báo Cáo</a>
            <a href="shift.html" class="active"><i class="fas fa-clock"></i> Ca Làm Việc</a>
            <a href="#" onclick="handleLogout(); return false;"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
        `;
    } else if (role === 'REGIONAL_MANAGER') {
        sidebar.innerHTML = `
            <h3><i class="fas fa-globe"></i> Lãnh Đạo Khu Vực</h3>
            <a href="../manager/regional_dashboard.html"><i class="fas fa-chart-line"></i> Tổng Quan</a>
            <a href="room_management.html"><i class="fas fa-door-open"></i> Quản Lý Phòng</a>
            <a href="../admin/reports.html"><i class="fas fa-chart-bar"></i> Báo Cáo</a>
            <a href="#" onclick="handleLogout(); return false;"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
        `;
    } else if (role === 'HOUSEKEEPER') {
        sidebar.innerHTML = `
            <h3><i class="fas fa-broom"></i> Buồng Phòng</h3>
            <a href="housekeeper_dashboard.html"><i class="fas fa-chart-line"></i> Tổng Quan</a>
            <a href="room_management.html"><i class="fas fa-door-open"></i> Trạng Thái Phòng</a>
            <a href="shift.html" class="active"><i class="fas fa-clock"></i> Ca Làm Việc</a>
            <a href="#" onclick="handleLogout(); return false;"><i class="fas fa-sign-out-alt"></i> Đăng Xuất</a>
        `;
    } else if (role === 'RECEPTIONIST') {
        sidebar.innerHTML = `
            <h3><i class="fas fa-hotel"></i> Lễ Tân</h3>
            <a href="receptionist_dashboard.html"><i class="fas fa-clipboard-list"></i> Quản Lý Đặt Phòng</a>
            <a href="room_management.html"><i class="fas fa-door-open"></i> Quản Lý Phòng</a>
            <a href="shift.html" class="active"><i class="fas fa-clock"></i> Ca Làm Việc</a>
            <a href="#" onclick="handleLogout(); return false;"><i class="fas fa-sign-out-alt"></i> Đăng Xuất</a>
        `;
    }
}
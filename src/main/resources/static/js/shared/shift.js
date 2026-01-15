/**
 * Shared Shift Management Logic
 */

document.addEventListener('DOMContentLoaded', function () {
    const currentUser = getCurrentUser();
    if (!currentUser) {
        window.location.href = '/pages/auth/login.html';
        return;
    }

    if (document.getElementById('user-fullname')) {
        document.getElementById('user-fullname').textContent = currentUser.fullName || currentUser.username;
        document.getElementById('user-role-display').textContent = getRoleDisplayName(currentUser.role);
    }

    if (typeof updateSidebarForRole === 'function') {
        updateSidebarForRole(currentUser.role);
    }
});

async function startShift() {
    const startCash = document.getElementById('startCash').value;
    if (startCash === "") {
        showWarning("Vui lòng nhập tiền đầu ca!");
        return;
    }

    try {
        const msg = await callAPI(`/shift/start?initialCash=${startCash}`, 'POST');
        if (typeof showSuccess === 'function') showSuccess("Đã bắt đầu ca làm việc!");

        const statusDiv = document.getElementById('start-status') || document.getElementById('shift-status');
        if (statusDiv) statusDiv.innerHTML = `<span style="color:green; font-weight:bold;">${msg || 'Bắt đầu thành công'}</span>`;

    } catch (error) {
        if (typeof showError === 'function') showError("Lỗi: " + error.message);
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
        if (typeof showSuccess === 'function') showSuccess("🏁 Đã kết thúc ca làm việc!");

        const statusDiv = document.getElementById('shift-status');
        if (statusDiv) statusDiv.innerHTML = `<span style="color:blue; font-weight:bold;">${msg}</span>`;

    } catch (error) {
        if (typeof showError === 'function') showError("Lỗi: " + error.message);
    }
}

/**
 * Sidebar Update Logic (Combined)
 */
function updateSidebarForRole(role) {
    const sidebar = document.querySelector('.sidebar');
    if (!sidebar) return;

    if (role === 'BRANCH_MANAGER') {
        sidebar.innerHTML = `
            <h3><i class="fas fa-user-tie"></i> Quản Lý Chi Nhánh</h3>
            <a href="../branch_manager/dashboard.html"><i class="fas fa-chart-line"></i> Dashboard</a>
            <a href="room_management.html"><i class="fas fa-door-open"></i> Quản Lý Phòng</a>
            <a href="../branch_manager/branch_report.html"><i class="fas fa-file-alt"></i> Báo Cáo</a>
            <a href="shift.html" class="active"><i class="fas fa-clock"></i> Ca Làm Việc</a>
            <a href="#" onclick="handleLogout(); return false;"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
        `;
    } else if (role === 'REGIONAL_MANAGER') {
        sidebar.innerHTML = `
            <h3><i class="fas fa-globe"></i> Lãnh Đạo Khu Vực</h3>
            <a href="../regional_manager/dashboard.html"><i class="fas fa-chart-line"></i> Tổng Quan</a>
            <a href="../regional_manager/branch_management.html"><i class="fas fa-building"></i> Quản Lý Chi Nhánh</a>
            <a href="../regional_manager/regional_report.html"><i class="fas fa-chart-bar"></i> Báo Cáo Tổng Hợp</a>
            <a href="#" onclick="handleLogout(); return false;"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
        `;
    } else if (role === 'HOUSEKEEPER') {
        sidebar.innerHTML = `
            <h3><i class="fas fa-broom"></i> Buồng Phòng</h3>
            <a href="../housekeeper/dashboard.html"><i class="fas fa-chart-line"></i> Tổng Quan</a>
            <a href="room_management.html"><i class="fas fa-door-open"></i> Trạng Thái Phòng</a>
            <a href="shift.html" class="active"><i class="fas fa-clock"></i> Ca Làm Việc</a>
            <a href="#" onclick="handleLogout(); return false;"><i class="fas fa-sign-out-alt"></i> Đăng Xuất</a>
        `;
    } else if (role === 'RECEPTIONIST') {
        sidebar.innerHTML = `
            <h3><i class="fas fa-hotel"></i> Lễ Tân</h3>
            <a href="../receptionist/dashboard.html"><i class="fas fa-clipboard-list"></i> Quản Lý Đặt Phòng</a>
            <a href="room_management.html"><i class="fas fa-door-open"></i> Quản Lý Phòng</a>
            <a href="shift.html" class="active"><i class="fas fa-clock"></i> Ca Làm Việc</a>
            <a href="#" onclick="handleLogout(); return false;"><i class="fas fa-sign-out-alt"></i> Đăng Xuất</a>
        `;
    }
}

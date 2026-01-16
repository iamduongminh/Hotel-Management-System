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
            <h3>Quản lý chi nhánh</h3>
            <a href="../branch_manager/dashboard.html">Tổng quan</a>
            <a href="room_management.html">Quản lý phòng</a>
            <a href="../branch_manager/branch_report.html">Báo cáo</a>
            <a href="shift.html" class="active">Ca làm việc</a>
            <a href="#" onclick="handleLogout(); return false;">Đăng xuất</a>
        `;
    } else if (role === 'REGIONAL_MANAGER') {
        sidebar.innerHTML = `
            <h3>Lãnh đạo khu vực</h3>
            <a href="../regional_manager/dashboard.html">Tổng quan</a>
            <a href="../regional_manager/branch_management.html">Quản lý chi nhánh</a>
            <a href="../regional_manager/regional_report.html">Báo cáo tổng hợp</a>
            <a href="#" onclick="handleLogout(); return false;">Đăng xuất</a>
        `;
    } else if (role === 'HOUSEKEEPER') {
        sidebar.innerHTML = `
            <h3>Buồng phòng</h3>
            <a href="../housekeeper/dashboard.html">Tổng quan</a>
            <a href="room_management.html">Trạng thái phòng</a>
            <a href="shift.html" class="active">Ca làm việc</a>
            <a href="#" onclick="handleLogout(); return false;">Đăng xuất</a>
        `;
    } else if (role === 'RECEPTIONIST') {
        sidebar.innerHTML = `
            <h3>Lễ tân</h3>
            <a href="../receptionist/dashboard.html">Đặt phòng</a>
            <a href="room_management.html">Quản lý phòng</a>
            <a href="shift.html" class="active">Ca làm việc</a>
            <a href="#" onclick="handleLogout(); return false;">Đăng xuất</a>
        `;
    }
}

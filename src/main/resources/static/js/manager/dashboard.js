// Manager Dashboard Logic
document.addEventListener('DOMContentLoaded', async () => {
    await checkAuth();
    await loadManagerInfo();
    await loadStatistics();
});

async function loadManagerInfo() {
    try {
        const response = await apiCall('/api/auth/me');
        if (response.success) {
            const user = response.data;
            // Update UI
            document.getElementById('manager-name').textContent = user.fullName || user.username;
            document.getElementById('manager-role').textContent = getRoleDisplayName(user.role);

            let location = '';
            if (user.city) location += user.city;
            if (user.branchName) location += (location ? ' - ' : '') + user.branchName;
            document.getElementById('manager-location').textContent = location || 'N/A';

            // Sync with localStorage so other pages (sidebar) see the correct role immediately
            saveCurrentUser(user);
        }
    } catch (error) {
        console.error('Error loading manager info:', error);
    }
}

function getRoleDisplayName(role) {
    const roleMap = {
        'REGIONAL_MANAGER': 'Quản Lý Khu Vực',
        'BRANCH_MANAGER': 'Quản Lý Chi Nhánh',
        'ADMIN': 'IT Admin',
        'RECEPTIONIST': 'Lễ Tân',
        'HOUSEKEEPER': 'Nhân Viên Dọn Phòng'
    };
    return roleMap[role] || role;
}

async function loadStatistics() {
    // Placeholder - would connect to real API endpoints
    try {
        // These would be real API calls in production
        document.getElementById('monthly-revenue').textContent = '125,500,000 VNĐ';
        document.getElementById('total-bookings').textContent = '142';
        document.getElementById('staff-count').textContent = '28';
        document.getElementById('avg-rating').textContent = '4.7';

        showSuccess('Dashboard đã tải thành công');
    } catch (error) {
        console.error('Error loading statistics:', error);
        showError('Không thể tải thống kê');
    }
}

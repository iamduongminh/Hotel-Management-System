// Manager Dashboard Logic
document.addEventListener('DOMContentLoaded', async () => {
    // await checkAuth(); // Common auth should handle this
    await loadManagerInfo();
    await loadStatistics();
});

async function loadManagerInfo() {
    try {
        const user = getCurrentUser(); // Get from localStorage/common auth
        if (user) {
            // Update UI
            document.getElementById('manager-name').textContent = user.fullName || user.username;
            document.getElementById('manager-role').textContent = getRoleDisplayName(user.role);
            // Location logic removed
        }
    } catch (error) {
        console.error('Error loading manager info:', error);
    }
}

function getRoleDisplayName(role) {
    const roleMap = {
        'MANAGER': 'Quản Lý Khách Sạn',
        'ADMIN': 'IT Admin',
        'RECEPTIONIST': 'Lễ Tân'
    };
    return roleMap[role] || role;
}

async function loadStatistics() {
    // Placeholder - would connect to real API endpoints
    try {
        // These would be real API calls in production
        // Updated IDs to match HTML
        const totalRevenue = document.getElementById('total-revenue');
        if (totalRevenue) totalRevenue.textContent = '125,500,000 VNĐ';

        const occupancyRate = document.getElementById('occupancy-rate');
        if (occupancyRate) occupancyRate.textContent = '85%';

        // showSuccess('Dashboard đã tải thành công'); // Optional
    } catch (error) {
        console.error('Error loading statistics:', error);
        showError('Không thể tải thống kê');
    }
}

/**
 * Room Management JavaScript
 * Handles room status updates with role-based permissions
 */

let allRooms = [];
let currentUser = null;
let pendingStatusUpdate = null;

// Initialize on page load
document.addEventListener('DOMContentLoaded', async function () {
    // Check authentication
    currentUser = getCurrentUser();
    if (!currentUser) {
        window.location.href = '/pages/auth/login.html';
        return;
    }

    // Display user info
    document.getElementById('user-fullname').textContent = currentUser.fullName;
    document.getElementById('user-role-display').textContent = getRoleDisplayName(currentUser.role);

    // Update Sidebar Navigation based on Role
    updateSidebarForRole(currentUser.role);

    // Load rooms
    await loadRooms();

    // Close dropdown when clicking outside
    document.addEventListener('click', function (e) {
        if (!e.target.closest('.action-dropdown')) {
            closeAllDropdowns();
        }
    });
});

/**
 * Load all rooms from API
 */
async function loadRooms() {
    try {
        const rooms = await callAPI('/rooms', 'GET');
        allRooms = rooms;
        renderRooms(rooms);
    } catch (error) {
        console.error('Error loading rooms:', error);
        showError('Không thể tải danh sách phòng: ' + error.message);
        document.getElementById('rooms-tbody').innerHTML = `
            <tr>
                <td colspan="5" class="empty-state">
                    <i class="fas fa-exclamation-triangle"></i>
                    <p>Lỗi khi tải dữ liệu</p>
                </td>
            </tr>
        `;
    }
}

/**
 * Render rooms table
 */
function renderRooms(rooms) {
    const tbody = document.getElementById('rooms-tbody');

    if (!rooms || rooms.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="4" class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <p>Không có phòng nào</p>
                </td>
            </tr>
        `;
        return;
    }

    tbody.innerHTML = rooms.map(room => `
        <tr>
            <td><strong>${room.roomNumber}</strong></td>
            <td>${getTypeDisplayName(room.type)}</td>
            <td class="room-price">${formatCurrency(room.price)}</td>
            <td>${renderStatusWithDropdown(room)}</td>
        </tr>
    `).join('');
}

/**
 * Render status badge with dropdown for changing status
 * Combined status display + action in one element
 */
function renderStatusWithDropdown(room) {
    const userRole = currentUser.role;
    const currentStatus = room.status;
    let menuItems = [];

    const statusConfig = {
        'AVAILABLE': { label: 'Phòng Trống', class: 'available', icon: 'fa-check-circle' },
        'BOOKED': { label: 'Đã Đặt', class: 'booked', icon: 'fa-calendar-check' },
        'OCCUPIED': { label: 'Có Khách', class: 'occupied', icon: 'fa-user' },
        'DIRTY': { label: 'Cần Dọn', class: 'dirty', icon: 'fa-broom' },
        'MAINTENANCE': { label: 'Bảo Trì', class: 'maintenance', icon: 'fa-wrench' }
    };

    // Determine what status changes are allowed based on role
    if (userRole === 'HOUSEKEEPER') {
        if (currentStatus === 'DIRTY') {
            menuItems.push('AVAILABLE');
        }
    } else if (userRole === 'RECEPTIONIST') {
        ['AVAILABLE', 'BOOKED', 'OCCUPIED', 'DIRTY'].forEach(status => {
            if (currentStatus !== status) menuItems.push(status);
        });
    } else if (userRole === 'BRANCH_MANAGER' || userRole === 'REGIONAL_MANAGER' || userRole === 'ADMIN') {
        Object.keys(statusConfig).forEach(status => {
            if (currentStatus !== status) menuItems.push(status);
        });
    }

    const currentConfig = statusConfig[currentStatus] || { label: currentStatus, class: '', icon: 'fa-circle' };

    // If no actions available, just show the badge without dropdown
    if (menuItems.length === 0) {
        return `<span class="no-action ${currentStatus}">${currentConfig.label}</span>`;
    }

    // Build dropdown menu items
    const menuItemsHtml = menuItems.map(status => {
        const config = statusConfig[status];
        return `
            <button class="action-dropdown-item ${config.class}" onclick="requestStatusChange(${room.id}, '${status}', '${room.roomNumber}'); event.stopPropagation();">
                <i class="fas ${config.icon}"></i> ${config.label}
            </button>
        `;
    }).join('');

    // Return status badge that acts as dropdown trigger
    return `
        <div class="action-dropdown">
            <button class="status-badge-btn ${currentStatus}" onclick="toggleDropdown(this, event)">
                ${currentConfig.label}
                <i class="fas fa-chevron-down dropdown-arrow"></i>
            </button>
            <div class="action-dropdown-menu">
                <div class="dropdown-header">Đổi trạng thái</div>
                ${menuItemsHtml}
            </div>
        </div>
    `;
}

/**
 * Legacy function - kept for compatibility
 */
function renderActionButtons(room) {
    return renderStatusWithDropdown(room);
}

/**
 * Toggle dropdown menu
 */
function toggleDropdown(btn, event) {
    event.stopPropagation();
    const menu = btn.nextElementSibling;
    const isOpen = menu.classList.contains('show');

    // Close all other dropdowns first
    closeAllDropdowns();

    // Toggle current dropdown
    if (!isOpen) {
        menu.classList.add('show');
    }
}

/**
 * Close all dropdown menus
 */
function closeAllDropdowns() {
    document.querySelectorAll('.action-dropdown-menu.show').forEach(menu => {
        menu.classList.remove('show');
    });
}

/**
 * Request status change (show confirmation modal)
 */
function requestStatusChange(roomId, newStatus, roomNumber) {
    pendingStatusUpdate = { roomId, newStatus, roomNumber };

    const statusName = getStatusDisplayName(newStatus);
    const message = `Bạn có chắc muốn chuyển phòng <strong>${roomNumber}</strong> sang trạng thái <strong>${statusName}</strong>?`;

    document.getElementById('confirm-message').innerHTML = message;
    document.getElementById('confirm-modal').classList.add('active');
}

/**
 * Confirm and execute status change
 */
async function confirmStatusChange() {
    if (!pendingStatusUpdate) return;

    const { roomId, newStatus } = pendingStatusUpdate;

    try {
        // Close modal first
        closeConfirmModal();

        // Call API
        const result = await callAPI(`/rooms/${roomId}/status`, 'PUT', { status: newStatus });

        showSuccess(result.message || 'Cập nhật trạng thái phòng thành công!');

        // Reload rooms
        await loadRooms();

    } catch (error) {
        console.error('Error updating room status:', error);
        showError(error.message || 'Không thể cập nhật trạng thái phòng');
    } finally {
        pendingStatusUpdate = null;
    }
}

/**
 * Close confirmation modal
 */
function closeConfirmModal() {
    document.getElementById('confirm-modal').classList.remove('active');
    pendingStatusUpdate = null;
}

/**
 * Filter rooms by status, type, and search term
 */
function filterRooms() {
    const statusFilter = document.getElementById('status-filter').value;
    const typeFilter = document.getElementById('type-filter').value;
    const searchTerm = document.getElementById('search-input').value.toLowerCase().trim();

    let filtered = allRooms;

    // Filter by status
    if (statusFilter) {
        filtered = filtered.filter(room => room.status === statusFilter);
    }

    // Filter by type
    if (typeFilter) {
        filtered = filtered.filter(room => room.type === typeFilter);
    }

    // Filter by search term
    if (searchTerm) {
        filtered = filtered.filter(room =>
            room.roomNumber.toLowerCase().includes(searchTerm)
        );
    }

    renderRooms(filtered);
}

/**
 * Helper: Get room type display name
 */
function getTypeDisplayName(type) {
    const types = {
        'VIP': 'VIP',
        'DELUXE': 'Deluxe',
        'STANDARD': 'Standard'
    };
    return types[type] || type;
}

/**
 * Helper: Get status display name
 */
function getStatusDisplayName(status) {
    const statuses = {
        'AVAILABLE': 'Phòng Trống',
        'BOOKED': 'Đã Đặt',
        'OCCUPIED': 'Có Khách',
        'DIRTY': 'Cần Dọn',
        'MAINTENANCE': 'Bảo Trì'
    };
    return statuses[status] || status;
}

/**
 * Helper: Get role display name
 */
function getRoleDisplayName(role) {
    const roles = {
        'RECEPTIONIST': 'Lễ Tân',
        'HOUSEKEEPER': 'Nhân Viên Dọn Phòng',
        'BRANCH_MANAGER': 'Quản Lý Chi Nhánh',
        'REGIONAL_MANAGER': 'Quản Lý Khu Vực',
        'ADMIN': 'Quản Trị Viên'
    };
    return roles[role] || role;
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
            <a href="room_management.html" class="active"><i class="fas fa-door-open"></i> Quản Lý Phòng</a>
            <a href="../admin/reports.html"><i class="fas fa-file-alt"></i> Báo Cáo</a>
            <a href="shift.html"><i class="fas fa-clock"></i> Ca Làm Việc</a>
            <a href="#" onclick="handleLogout(); return false;"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
        `;
    } else if (role === 'REGIONAL_MANAGER') {
        sidebar.innerHTML = `
            <h3><i class="fas fa-globe"></i> Lãnh Đạo Khu Vực</h3>
            <a href="../manager/regional_dashboard.html"><i class="fas fa-chart-line"></i> Tổng Quan</a>
            <a href="room_management.html" class="active"><i class="fas fa-door-open"></i> Quản Lý Phòng</a>
            <a href="../admin/reports.html"><i class="fas fa-chart-bar"></i> Báo Cáo</a>
            <a href="#" onclick="handleLogout(); return false;"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
        `;
    } else if (role === 'HOUSEKEEPER') {
        sidebar.innerHTML = `
            <h3><i class="fas fa-broom"></i> Buồng Phòng</h3>
            <a href="housekeeper_dashboard.html"><i class="fas fa-chart-line"></i> Tổng Quan</a>
            <a href="room_management.html" class="active"><i class="fas fa-door-open"></i> Trạng Thái Phòng</a>
            <a href="shift.html"><i class="fas fa-clock"></i> Ca Làm Việc</a>
            <a href="#" onclick="handleLogout(); return false;"><i class="fas fa-sign-out-alt"></i> Đăng Xuất</a>
        `;
    } else if (role === 'RECEPTIONIST') {
        sidebar.innerHTML = `
            <h3><i class="fas fa-hotel"></i> Lễ Tân</h3>
            <a href="receptionist_dashboard.html"><i class="fas fa-clipboard-list"></i> Quản Lý Đặt Phòng</a>
            <a href="room_management.html" class="active"><i class="fas fa-door-open"></i> Quản Lý Phòng</a>
            <a href="shift.html"><i class="fas fa-clock"></i> Ca Làm Việc</a>
            <a href="#" onclick="handleLogout(); return false;"><i class="fas fa-sign-out-alt"></i> Đăng Xuất</a>
        `;
    }
}

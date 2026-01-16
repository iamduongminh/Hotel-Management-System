/**
 * Shared Room Management JavaScript
 * Handles room status updates with role-based permissions
 * Used by: Manager, Receptionist, Housekeeper
 */

let allRooms = [];
let filteredRooms = [];
let currentUser = null;
let pendingStatusUpdate = null; // For Manager/Receptionist (confirm modal usually handled differently or same?)
let pendingStatusChange = null; // For Housekeeper style
// We'll unify to 'pendingStatusChange'

document.addEventListener('DOMContentLoaded', async function () {
    // Check authentication
    currentUser = getCurrentUser();
    if (!currentUser) {
        window.location.href = '/pages/auth/login.html';
        return;
    }

    // Display user info
    if (document.getElementById('user-fullname')) {
        document.getElementById('user-fullname').textContent = currentUser.fullName || currentUser.username;
    }
    if (document.getElementById('user-role-display')) {
        document.getElementById('user-role-display').textContent = getRoleDisplayName(currentUser.role) + ' - ' + (currentUser.fullName || currentUser.username);
    }
    if (document.getElementById('branch-name-display') && currentUser.branchName) {
        document.getElementById('branch-name-display').textContent = '📍 Chi nhánh: ' + currentUser.branchName;
    }

    // Update Sidebar Navigation based on Role
    // Note: pages/common/room_management.html needs to have the sidebar container
    if (typeof updateSidebarForRole === 'function') {
        updateSidebarForRole(currentUser.role);
    }

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
        const response = await fetch(`${CONFIG.API_BASE_URL}/rooms`, {
            method: 'GET',
            credentials: 'include',
            headers: {
                'Content-Type': 'application/json'
            }
        });

        if (!response.ok) {
            throw new Error('Failed to load rooms');
        }

        allRooms = await response.json();
        filterRooms(); // Initial filter
    } catch (error) {
        console.error('Error loading rooms:', error);
        if (typeof showError === 'function') showError('Không thể tải danh sách phòng: ' + error.message);
        else if (typeof showToast === 'function') showToast('Không thể tải danh sách phòng', 'error');

        const tbody = document.getElementById('rooms-tbody');
        if (tbody) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="5" class="empty-state">
                        <i class="fas fa-exclamation-triangle"></i>
                        <p>Lỗi khi tải dữ liệu</p>
                    </td>
                </tr>
            `;
        }
    }
}

/**
 * Filter rooms
 */
function filterRooms() {
    const statusFilter = document.getElementById('status-filter')?.value;
    const typeFilter = document.getElementById('type-filter')?.value;
    const searchInput = document.getElementById('search-input');
    const searchQuery = searchInput ? searchInput.value.toLowerCase() : '';

    filteredRooms = allRooms.filter(room => {
        const matchesStatus = !statusFilter || room.status === statusFilter;
        const matchesType = !typeFilter || room.type === typeFilter;
        const matchesSearch = !searchQuery || room.roomNumber.toLowerCase().includes(searchQuery);
        return matchesStatus && matchesType && matchesSearch;
    });

    renderRoomsTable(filteredRooms);
}

/**
 * Render rooms table
 */
function renderRoomsTable(rooms) {
    const tbody = document.getElementById('rooms-tbody');
    if (!tbody) return;

    if (!rooms || rooms.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="5" class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <p>Không có phòng nào</p>
                </td>
            </tr>
        `;
        return;
    }

    // Check if user should see price
    const showPrice = ['BRANCH_MANAGER', 'REGIONAL_MANAGER', 'ADMIN', 'RECEPTIONIST'].includes(currentUser.role);

    tbody.innerHTML = rooms.map(room => `
        <tr>
            <td><strong>${room.roomNumber}</strong></td>
            <td>${getTypeDisplayName(room.type)}</td>
            ${showPrice ? `<td class="room-price">${formatCurrency(room.price)}</td>` : ''}
            <td>${renderStatusBadge(room)}</td>
        </tr>
    `).join('');
}

/**
 * Get display name for room type
 */
function getTypeDisplayName(type) {
    const typeMap = {
        'SINGLE': 'Đơn',
        'DOUBLE': 'Đôi',
        'VIP': 'VIP',
        'DELUXE': 'Deluxe',
        'STANDARD': 'Tiêu chuẩn'
    };
    return typeMap[type] || type;
}

/**
 * Render status badge (with or without dropdown based on role)
 */
function renderStatusBadge(room) {
    const statusText = getStatusText(room.status);

    // Logic for dropdown availability
    let canChange = false;

    if (['BRANCH_MANAGER', 'REGIONAL_MANAGER', 'ADMIN'].includes(currentUser.role)) {
        // Managers can change any status
        canChange = true;
    } else if (currentUser.role === 'RECEPTIONIST') {
        // Receptionist usually changes generic status or Booked/Occupied logic (via checkin/out often, but here maybe manual status fix)
        canChange = true;
    } else if (currentUser.role === 'HOUSEKEEPER') {
        // Housekeeper can only change DIRTY -> AVAILABLE
        if (room.status === 'DIRTY') {
            canChange = true;
        }
    }

    if (!canChange) {
        return `<span class="status-badge-btn ${room.status} disabled" style="cursor: not-allowed;">${statusText}</span>`;
    }

    // Dropdown content
    let options = '';

    if (currentUser.role === 'HOUSEKEEPER') {
        // Only allow finish cleaning
        options = `
            <div class="dropdown-header">Thay đổi trạng thái</div>
            <button class="action-dropdown-item available" onclick="requestStatusChange(${room.id}, 'AVAILABLE')">
                <i class="fas fa-check-circle"></i> Đã dọn xong
            </button>
        `;
    } else {
        // Others can set to various statuses (simplified list for now, or full list)
        // Managers might want to set Maintenance, etc.
        options = `
            <div class="dropdown-header">Thay đổi trạng thái</div>
            <button class="action-dropdown-item available" onclick="requestStatusChange(${room.id}, 'AVAILABLE')"><i class="fas fa-check-circle"></i> Trống</button>
            <button class="action-dropdown-item dirty" onclick="requestStatusChange(${room.id}, 'DIRTY')"><i class="fas fa-broom"></i> Bẩn</button>
            <button class="action-dropdown-item maintenance" onclick="requestStatusChange(${room.id}, 'MAINTENANCE')"><i class="fas fa-tools"></i> Bảo trì</button>
            ${currentUser.role !== 'HOUSEKEEPER' ? `<button class="action-dropdown-item booked" onclick="requestStatusChange(${room.id}, 'BOOKED')"><i class="fas fa-calendar-check"></i> Đã đặt</button>` : ''}
        `;
    }

    return `
        <div class="action-dropdown">
            <button class="status-badge-btn ${room.status}" onclick="toggleDropdown(event, ${room.id})">
                ${statusText} <i class="fas fa-chevron-down dropdown-arrow"></i>
            </button>
            <div class="action-dropdown-menu" id="dropdown-${room.id}">
                ${options}
            </div>
        </div>
    `;
}

function getStatusText(status) {
    const map = {
        'AVAILABLE': 'Phòng trống',
        'BOOKED': 'Đã đặt',
        'OCCUPIED': 'Đang có khách',
        'DIRTY': 'Cần dọn dẹp',
        'CLEANING': 'Đang dọn dẹp',
        'MAINTENANCE': 'Bảo trì'
    };
    return map[status] || status;
}

// Dropdown handling
function toggleDropdown(event, roomId) {
    event.stopPropagation();
    const dropdown = document.getElementById(`dropdown-${roomId}`);
    const allDropdowns = document.querySelectorAll('.action-dropdown-menu');

    allDropdowns.forEach(d => {
        if (d.id !== `dropdown-${roomId}`) {
            d.classList.remove('show');
            d.closest('.action-dropdown')?.classList.remove('open');
        }
    });

    dropdown.classList.toggle('show');
    dropdown.closest('.action-dropdown').classList.toggle('open');
}

function closeAllDropdowns() {
    document.querySelectorAll('.action-dropdown-menu').forEach(d => {
        d.classList.remove('show');
        d.closest('.action-dropdown')?.classList.remove('open');
    });
}

// Status Change Logic
function requestStatusChange(roomId, newStatus) {
    const room = allRooms.find(r => r.id === roomId);
    if (!room) return;
    closeAllDropdowns();

    const statusText = getStatusText(newStatus);
    const message = `Bạn có chắc muốn đổi trạng thái phòng ${room.roomNumber} thành "${statusText}"?`;

    const confirmMsg = document.getElementById('confirm-message');
    if (confirmMsg) confirmMsg.textContent = message;

    const modal = document.getElementById('confirm-modal');
    if (modal) modal.classList.add('active');

    pendingStatusChange = { roomId, newStatus };
}

async function confirmStatusChange() {
    if (!pendingStatusChange) return;
    const { roomId, newStatus } = pendingStatusChange;

    try {
        const response = await fetch(`${CONFIG.API_BASE_URL}/rooms/${roomId}/status`, {
            method: 'PUT',
            credentials: 'include',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ status: newStatus })
        });

        if (!response.ok) throw new Error('Failed to update status');

        // Update local
        const room = allRooms.find(r => r.id === roomId);
        if (room) room.status = newStatus;

        filterRooms(); // re-render
        if (typeof showSuccess === 'function') showSuccess('Cập nhật trạng thái thành công');
        else if (typeof showToast === 'function') showToast('Cập nhật trạng thái thành công', 'success');

        closeConfirmModal();
    } catch (e) {
        console.error(e);
        if (typeof showError === 'function') showError(e.message);
        else if (typeof showToast === 'function') showToast('Lỗi cập nhật', 'error');
    }
}

function closeConfirmModal() {
    document.getElementById('confirm-modal').classList.remove('active');
    pendingStatusChange = null;
}

/**
 * Sidebar Update Logic (Ported from individual files)
 */
function updateSidebarForRole(role) {
    const sidebar = document.querySelector('.sidebar');
    if (!sidebar) return;

    if (role === 'BRANCH_MANAGER') {
        sidebar.innerHTML = `
            <h3>Quản lý chi nhánh</h3>
            <a href="../branch_manager/dashboard.html">Tổng quan</a>
            <a href="room_management.html" class="active">Quản lý phòng</a>
            <a href="../branch_manager/branch_report.html">Báo cáo</a>
            <a href="shift.html">Ca làm việc</a>
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
            <a href="room_management.html" class="active">Trạng thái phòng</a>
            <a href="shift.html">Ca làm việc</a>
            <a href="#" onclick="handleLogout(); return false;">Đăng xuất</a>
        `;
    } else if (role === 'RECEPTIONIST') {
        sidebar.innerHTML = `
            <h3>Lễ tân</h3>
            <a href="../receptionist/dashboard.html">Đặt phòng</a>
            <a href="room_management.html" class="active">Quản lý phòng</a>
            <a href="shift.html">Ca làm việc</a>
            <a href="#" onclick="handleLogout(); return false;">Đăng xuất</a>
        `;
    }
}

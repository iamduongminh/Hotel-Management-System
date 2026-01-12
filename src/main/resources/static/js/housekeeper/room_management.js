// Housekeeper Room Management JavaScript
let allRooms = [];
let filteredRooms = [];
let pendingStatusChange = null;

// Load rooms on page load
document.addEventListener('DOMContentLoaded', function () {
    loadUserInfo();
    loadRooms();

    // Close dropdown when clicking outside
    document.addEventListener('click', function (e) {
        if (!e.target.closest('.action-dropdown')) {
            closeAllDropdowns();
        }
    });
});

// Load user information
function loadUserInfo() {
    const userStr = localStorage.getItem(CONFIG.STORAGE_USER_KEY);
    if (userStr) {
        const user = JSON.parse(userStr);
        document.getElementById('user-fullname').textContent = user.fullName || user.username;
        document.getElementById('user-role-display').textContent =
            'Nhân viên buồng phòng - ' + (user.fullName || user.username);
    }
}

// Load all rooms
async function loadRooms() {
    try {
        const response = await fetch(`${CONFIG.API_BASE_URL}/rooms`, {
            method: 'GET',
            credentials: 'include',  // Use session cookie instead of Bearer token
            headers: {
                'Content-Type': 'application/json'
            }
        });

        if (!response.ok) {
            throw new Error('Failed to load rooms');
        }

        allRooms = await response.json();
        filterRooms();
    } catch (error) {
        console.error('Error loading rooms:', error);
        showToast('Không thể tải danh sách phòng', 'error');
        document.getElementById('rooms-tbody').innerHTML = `
            <tr>
                <td colspan="3" class="empty-state">
                    <i class="fas fa-exclamation-circle"></i>
                    <h3>Không thể tải dữ liệu</h3>
                    <p>Vui lòng thử lại sau</p>
                </td>
            </tr>
        `;
    }
}

// Filter and display rooms
function filterRooms() {
    const statusFilter = document.getElementById('status-filter').value;
    const typeFilter = document.getElementById('type-filter').value;
    const searchQuery = document.getElementById('search-input').value.toLowerCase();

    filteredRooms = allRooms.filter(room => {
        const matchesStatus = !statusFilter || room.status === statusFilter;
        const matchesType = !typeFilter || room.type === typeFilter;
        const matchesSearch = !searchQuery || room.roomNumber.toLowerCase().includes(searchQuery);
        return matchesStatus && matchesType && matchesSearch;
    });

    renderRoomsTable();
}

// Render rooms table
function renderRoomsTable() {
    const tbody = document.getElementById('rooms-tbody');

    if (filteredRooms.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="3" class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <h3>Không có phòng nào</h3>
                    <p>Không tìm thấy phòng phù hợp với bộ lọc</p>
                </td>
            </tr>
        `;
        return;
    }

    tbody.innerHTML = filteredRooms.map(room => `
        <tr>
            <td><strong>${room.roomNumber}</strong></td>
            <td>${room.type}</td>
            <td>${renderStatusBadge(room)}</td>
        </tr>
    `).join('');
}

// Render status badge with dropdown (only for DIRTY status)
function renderStatusBadge(room) {
    const statusText = getStatusText(room.status);

    // Housekeeper can ONLY change DIRTY → AVAILABLE
    // All other statuses are disabled (gray)
    if (room.status === 'DIRTY') {
        return `
            <div class="action-dropdown">
                <button class="status-badge-btn ${room.status}" onclick="toggleDropdown(event, ${room.id})">
                    ${statusText}
                    <i class="fas fa-chevron-down dropdown-arrow"></i>
                </button>
                <div class="action-dropdown-menu" id="dropdown-${room.id}">
                    <div class="dropdown-header">Thay đổi trạng thái</div>
                    <button class="action-dropdown-item available" onclick="requestStatusChange(${room.id}, 'AVAILABLE')">
                        <i class="fas fa-check-circle"></i>
                        Đã dọn xong
                    </button>
                </div>
            </div>
        `;
    } else {
        // All other statuses are disabled (cannot be changed by housekeeper)
        return `<span class="status-badge-btn disabled" style="cursor: not-allowed;">${statusText}</span>`;
    }
}

// Get localized status text
function getStatusText(status) {
    const statusMap = {
        'AVAILABLE': 'Phòng trống',
        'DIRTY': 'Cần dọn dẹp',
        'MAINTENANCE': 'Bảo trì',
        'OCCUPIED': 'Đang có khách',
        'BOOKED': 'Đã đặt trước'
    };
    return statusMap[status] || status;
}

// Toggle dropdown menu
function toggleDropdown(event, roomId) {
    event.stopPropagation();

    const dropdown = document.getElementById(`dropdown-${roomId}`);
    const allDropdowns = document.querySelectorAll('.action-dropdown-menu');

    // Close all other dropdowns
    allDropdowns.forEach(d => {
        if (d.id !== `dropdown-${roomId}`) {
            d.classList.remove('show');
            d.closest('.action-dropdown')?.classList.remove('open');
        }
    });

    // Toggle current dropdown
    dropdown.classList.toggle('show');
    dropdown.closest('.action-dropdown').classList.toggle('open');
}

// Close all dropdowns
function closeAllDropdowns() {
    document.querySelectorAll('.action-dropdown-menu').forEach(dropdown => {
        dropdown.classList.remove('show');
        dropdown.closest('.action-dropdown')?.classList.remove('open');
    });
}

// Request status change with confirmation
function requestStatusChange(roomId, newStatus) {
    const room = allRooms.find(r => r.id === roomId);
    if (!room) return;

    closeAllDropdowns();

    const statusText = getStatusText(newStatus);
    const message = `Bạn có chắc muốn đổi trạng thái phòng ${room.roomNumber} thành "${statusText}"?`;

    document.getElementById('confirm-message').textContent = message;
    document.getElementById('confirm-modal').classList.add('active');

    pendingStatusChange = { roomId, newStatus };
}

// Confirm status change
async function confirmStatusChange() {
    if (!pendingStatusChange) return;

    const { roomId, newStatus } = pendingStatusChange;

    try {
        const response = await fetch(`${CONFIG.API_BASE_URL}/rooms/${roomId}/status`, {
            method: 'PUT',
            credentials: 'include',  // Use session cookie instead of Bearer token
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ status: newStatus })
        });

        if (!response.ok) {
            throw new Error('Failed to update room status');
        }

        // Update local data
        const room = allRooms.find(r => r.id === roomId);
        if (room) {
            room.status = newStatus;
        }

        filterRooms();
        showToast('Đã cập nhật trạng thái phòng thành công', 'success');
        closeConfirmModal();
    } catch (error) {
        console.error('Error updating room status:', error);
        showToast('Không thể cập nhật trạng thái phòng', 'error');
    }

    pendingStatusChange = null;
}

// Close confirmation modal
function closeConfirmModal() {
    document.getElementById('confirm-modal').classList.remove('active');
    pendingStatusChange = null;
}

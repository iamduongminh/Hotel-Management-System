/**
 * Rooms Management - Admin Dashboard
 * View, edit, and filter rooms
 */

// Global variables
let allRooms = [];
let currentFilters = {
    type: '',
    status: '',
    minPrice: null,
    maxPrice: null,
    roomNumber: ''
};

// Load rooms when page loads
document.addEventListener('DOMContentLoaded', () => {
    loadRooms();
});

/**
 * Load all rooms from API
 */
async function loadRooms() {
    try {
        const rooms = await callAPI('/rooms', 'GET');
        allRooms = rooms;
        displayRooms(rooms);
    } catch (error) {
        console.error('Error loading rooms:', error);
        showError('Không thể tải danh sách phòng: ' + error.message);
    }
}

/**
 * Apply filters and reload room list
 */
async function applyFilters() {
    // Get filter values
    currentFilters.type = document.getElementById('filter-type').value;
    currentFilters.status = document.getElementById('filter-status').value;
    currentFilters.minPrice = document.getElementById('filter-min-price').value || null;
    currentFilters.maxPrice = document.getElementById('filter-max-price').value || null;
    currentFilters.roomNumber = document.getElementById('filter-room-number').value;

    // Build query string
    const params = new URLSearchParams();
    if (currentFilters.type) params.append('type', currentFilters.type);
    if (currentFilters.status) params.append('status', currentFilters.status);
    if (currentFilters.minPrice) params.append('minPrice', currentFilters.minPrice);
    if (currentFilters.maxPrice) params.append('maxPrice', currentFilters.maxPrice);
    if (currentFilters.roomNumber) params.append('roomNumber', currentFilters.roomNumber);

    try {
        const queryString = params.toString();
        const endpoint = queryString ? `/rooms/filter?${queryString}` : '/rooms';
        const rooms = await callAPI(endpoint, 'GET');
        displayRooms(rooms);
        showSuccess('Đã áp dụng bộ lọc');
    } catch (error) {
        console.error('Error filtering rooms:', error);
        showError('Không thể lọc phòng: ' + error.message);
    }
}

/**
 * Clear all filters and reload
 */
function clearFilters() {
    // Reset filter inputs
    document.getElementById('filter-type').value = '';
    document.getElementById('filter-status').value = '';
    document.getElementById('filter-min-price').value = '';
    document.getElementById('filter-max-price').value = '';
    document.getElementById('filter-room-number').value = '';

    // Reset filter state
    currentFilters = {
        type: '',
        status: '',
        minPrice: null,
        maxPrice: null,
        roomNumber: ''
    };

    // Reload all rooms
    loadRooms();
    showSuccess('Đã xóa bộ lọc');
}

/**
 * Display rooms in table
 */
function displayRooms(rooms) {
    const tbody = document.getElementById('rooms-tbody');
    const countBadge = document.getElementById('room-count');

    // Update count
    countBadge.textContent = `${rooms.length} phòng`;

    if (!rooms || rooms.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" style="text-align: center;">Không có phòng nào</td></tr>';
        return;
    }

    tbody.innerHTML = rooms.map(room => `
        <tr>
            <td>${room.id}</td>
            <td><strong>${room.roomNumber}</strong></td>
            <td>${getRoomTypeLabel(room.type)}</td>
            <td>${formatCurrency(room.price)}</td>
            <td>
                <span class="status-badge ${getStatusClass(room.status)}">
                    ${getRoomStatusLabel(room.status)}
                </span>
            </td>
            <td>${room.city || '-'}</td>
            <td>${room.branchName || '-'}</td>
            <td>
                <div class="action-buttons">
                    <button class="btn-primary btn-sm" onclick="viewRoomDetails(${room.id})" title="Xem chi tiết">
                        👁️
                    </button>
                    <button class="btn-secondary btn-sm" onclick="editRoom(${room.id})" title="Sửa">
                        ✏️
                    </button>
                </div>
            </td>
        </tr>
    `).join('');
}

/**
 * View room details
 */
function viewRoomDetails(roomId) {
    const room = allRooms.find(r => r.id === roomId);
    if (!room) {
        showError('Không tìm thấy phòng!');
        return;
    }

    // Populate modal
    document.getElementById('detail-room-id').textContent = room.id;
    document.getElementById('detail-room-number').textContent = room.roomNumber;
    document.getElementById('detail-room-type').textContent = getRoomTypeLabel(room.type);
    document.getElementById('detail-room-price').textContent = formatCurrency(room.price);
    document.getElementById('detail-room-status').innerHTML = 
        `<span class="status-badge ${getStatusClass(room.status)}">${getRoomStatusLabel(room.status)}</span>`;
    document.getElementById('detail-room-city').textContent = room.city || '-';
    document.getElementById('detail-room-branch').textContent = room.branchName || '-';

    // Open modal
    ModalManager.open('room-details-modal');
}

/**
 * Edit room - open modal with pre-filled data
 */
function editRoom(roomId) {
    const room = allRooms.find(r => r.id === roomId);
    if (!room) {
        showError('Không tìm thấy phòng!');
        return;
    }

    // Fill form with room data
    document.getElementById('edit-room-id').value = room.id;
    document.getElementById('edit-room-number').value = room.roomNumber;
    document.getElementById('edit-room-type').value = room.type;
    document.getElementById('edit-room-price').value = room.price;

    // Open modal
    ModalManager.open('edit-room-modal');
}

/**
 * Handle edit room form submission
 */
async function handleEditRoom(event) {
    event.preventDefault();

    const formData = new FormData(event.target);
    const roomId = formData.get('id');

    const roomData = {
        roomNumber: formData.get('roomNumber'),
        type: formData.get('type'),
        price: parseFloat(formData.get('price'))
    };

    try {
        const response = await callAPI(`/rooms/${roomId}`, 'PUT', roomData);

        showSuccess(response.message || 'Cập nhật phòng thành công!');

        // Close modal and reload rooms
        ModalManager.close('edit-room-modal');
        event.target.reset();
        
        // Reload with current filters
        if (hasActiveFilters()) {
            applyFilters();
        } else {
            loadRooms();
        }

    } catch (error) {
        console.error('Error updating room:', error);
        showError(error.message || 'Không thể cập nhật phòng!');
    }
}

/**
 * Check if any filters are active
 */
function hasActiveFilters() {
    return currentFilters.type || currentFilters.status || 
           currentFilters.minPrice || currentFilters.maxPrice || 
           currentFilters.roomNumber;
}

/**
 * Get room type label in Vietnamese
 */
function getRoomTypeLabel(type) {
    const labels = {
        'SINGLE': 'Đơn',
        'DOUBLE': 'Đôi',
        'DORM': 'Dormitory',
        'STANDARD': 'Tiêu chuẩn',
        'DELUXE': 'Cao cấp',
        'SUITE': 'Suite',
        'VIP': 'VIP'
    };
    return labels[type] || type;
}

/**
 * Get room status label in Vietnamese
 */
function getRoomStatusLabel(status) {
    const labels = {
        'AVAILABLE': 'Trống',
        'BOOKED': 'Đã đặt',
        'OCCUPIED': 'Đang ở',
        'DIRTY': 'Cần dọn',
        'CLEANING': 'Đang dọn',
        'MAINTENANCE': 'Bảo trì'
    };
    return labels[status] || status;
}

/**
 * Get CSS class for room status
 */
function getStatusClass(status) {
    const classes = {
        'AVAILABLE': 'status-available',
        'BOOKED': 'status-booked',
        'OCCUPIED': 'status-occupied',
        'DIRTY': 'status-dirty',
        'CLEANING': 'status-cleaning',
        'MAINTENANCE': 'status-maintenance'
    };
    return classes[status] || 'status-default';
}

/**
 * Format currency in VND
 */
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(amount);
}

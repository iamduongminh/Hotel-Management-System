/**
 * Room Category Management - Admin Dashboard
 * View, edit, filter, and create rooms with compact filters
 */

// Global variables
let allRooms = [];
let currentFilters = {
    type: '',
    minPrice: null,
    maxPrice: null,
    roomNumber: ''
};
let currentBranchName = '';
let currentOpenDropdown = null;
let roomToDeleteId = null;

// Base prices for room types
const ROOM_PRICES = {
    'SINGLE': 500000,
    'DOUBLE': 800000,
    'DORM': 200000,
    'STANDARD': 1000000,
    'DELUXE': 3000000,
    'SUITE': 5000000,
    'VIP': 10000000
};

/**
 * Update price input based on selected room type
 * @param {string} mode - 'create' or 'edit'
 */
function updateRoomPrice(mode) {
    const typeSelectId = mode === 'create' ? 'create-room-type' : 'edit-room-type';
    const priceInputId = mode === 'create' ? 'create-room-price' : 'edit-room-price';

    const typeSelect = document.getElementById(typeSelectId);
    const priceInput = document.getElementById(priceInputId);

    const selectedType = typeSelect.value;
    if (selectedType && ROOM_PRICES[selectedType]) {
        priceInput.value = formatNumberWithDots(ROOM_PRICES[selectedType]);
    } else {
        priceInput.value = '';
    }
}

// Load rooms when page loads
document.addEventListener('DOMContentLoaded', () => {
    loadCurrentUser();
    updatePriceDisplay(); // Initialize slider UI
    loadRooms();

    // Close dropdown when clicking outside
    document.addEventListener('click', (e) => {
        if (currentOpenDropdown && !e.target.closest('.action-menu-container')) {
            currentOpenDropdown.classList.remove('show');
            currentOpenDropdown = null;
        }
    });

    // Setup delete confirmation handler
    const confirmDeleteBtn = document.getElementById('confirm-delete-btn');
    if (confirmDeleteBtn) {
        confirmDeleteBtn.addEventListener('click', handleDeleteRoom);
    }
});

/**
 * Load current user and update page title with branch name
 */
async function loadCurrentUser() {
    try {
        const user = await callAPI('/users/current', 'GET');
        if (user && user.branchName) {
            currentBranchName = user.branchName;
            document.getElementById('page-title').textContent = `Danh sách phòng của chi nhánh ${user.branchName}`;
        }
    } catch (error) {
        console.error('Error loading current user:', error);
        // Keep default title if error
    }
}

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
 * Update price display values and slider track
 */
function updatePriceDisplay() {
    const minInput = document.getElementById('filter-min-price');
    const maxInput = document.getElementById('filter-max-price');
    const minDisplay = document.getElementById('price-min-display');
    const maxDisplay = document.getElementById('price-max-display');
    const track = document.querySelector('.slider-track');

    let minVal = parseInt(minInput.value);
    let maxVal = parseInt(maxInput.value);

    // Prevent cross-over
    if (minVal > maxVal) {
        let temp = minVal;
        minVal = maxVal;
        maxVal = temp;
    }

    // Format for display
    minDisplay.textContent = formatCurrency(minVal);
    maxDisplay.textContent = formatCurrency(maxVal);

    // Update track color fill
    const minPercent = (minVal / minInput.max) * 100;
    const maxPercent = (maxVal / maxInput.max) * 100;

    track.style.background = `linear-gradient(to right, var(--border) ${minPercent}%, var(--primary) ${minPercent}%, var(--primary) ${maxPercent}%, var(--border) ${maxPercent}%)`;

    // Trigger local filter immediately
    applyFilters();
}

/**
 * Apply filters locally
 */
function applyFilters() {
    // Get filter values
    const minInput = document.getElementById('filter-min-price');
    const maxInput = document.getElementById('filter-max-price');

    let minVal = parseInt(minInput.value);
    let maxVal = parseInt(maxInput.value);

    // Ensure min <= max
    if (minVal > maxVal) {
        [minVal, maxVal] = [maxVal, minVal];
    }

    currentFilters.type = document.getElementById('filter-type').value;
    currentFilters.minPrice = minVal;
    currentFilters.maxPrice = maxVal;
    currentFilters.roomNumber = document.getElementById('filter-room-number').value.trim().toLowerCase();

    // Client-side filtering
    const filteredRooms = allRooms.filter(room => {
        const matchesType = !currentFilters.type || room.type === currentFilters.type;
        const matchesPrice = room.price >= currentFilters.minPrice && room.price <= currentFilters.maxPrice;
        const matchesNumber = !currentFilters.roomNumber || room.roomNumber.toString().toLowerCase().includes(currentFilters.roomNumber);

        return matchesType && matchesPrice && matchesNumber;
    });

    displayRooms(filteredRooms);
}

/**
 * Display rooms in table
 */
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
            <td style="text-align: center;">${room.id}</td>
            <td style="text-align: center;"><strong>${room.roomNumber}</strong></td>
            <td style="text-align: center;">${room.type}</td>
            <td style="text-align: center;">${formatCurrency(room.price)}</td>
            <td style="text-align: center;">
                <span class="status-badge ${getStatusClass(room.status)}">
                    ${getRoomStatusLabel(room.status)}
                </span>
            </td>
            <td style="text-align: center;">
                <div class="action-menu-container">
                    <button class="action-menu-btn" onclick="toggleActionMenu(event, ${room.id})">
                        ⋮
                    </button>
                    <div class="action-dropdown" id="dropdown-${room.id}">
                        <button class="action-dropdown-item" onclick="editRoom(${room.id})">
                            ✏️ Sửa
                        </button>
                        <button class="action-dropdown-item" onclick="confirmDeleteRoom(${room.id}, '${room.roomNumber}')">
                            🗑️ Xóa
                        </button>
                    </div>
                </div>
            </td>
        </tr>
    `).join('');
}

/**
 * Toggle action dropdown menu
 */
function toggleActionMenu(event, roomId) {
    event.stopPropagation();
    const dropdown = document.getElementById(`dropdown-${roomId}`);

    // Close current dropdown if exists
    if (currentOpenDropdown && currentOpenDropdown !== dropdown) {
        currentOpenDropdown.classList.remove('show');
    }

    // Toggle the clicked dropdown
    dropdown.classList.toggle('show');
    currentOpenDropdown = dropdown.classList.contains('show') ? dropdown : null;
}

/**
 * Confirm delete room
 */
function confirmDeleteRoom(roomId, roomNumber) {
    roomToDeleteId = roomId;
    document.getElementById('delete-room-number').textContent = roomNumber;
    ModalManager.open('confirm-delete-modal');
}

/**
 * Handle delete room
 */
async function handleDeleteRoom() {
    if (!roomToDeleteId) return;

    try {
        await callAPI(`/rooms/${roomToDeleteId}`, 'DELETE');
        showSuccess('Xóa phòng thành công!');
        ModalManager.close('confirm-delete-modal');

        // Refresh data and re-apply filters
        await loadRooms();
        if (hasActiveFilters()) {
            applyFilters();
        }
    } catch (error) {
        console.error('Error deleting room:', error);
        showError(error.message || 'Không thể xóa phòng!');
    } finally {
        roomToDeleteId = null;
    }
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
    document.getElementById('edit-room-price').value = formatNumberWithDots(room.price);

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
        price: parseNumberFromDots(formData.get('price'))
    };

    try {
        const response = await callAPI(`/rooms/${roomId}`, 'PUT', roomData);

        showSuccess(response.message || 'Cập nhật phòng thành công!');

        // Close modal and reload rooms
        ModalManager.close('edit-room-modal');
        event.target.reset();

        // Refresh data and re-apply filters
        await loadRooms();
        if (hasActiveFilters()) {
            applyFilters();
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
    return currentFilters.type || currentFilters.minPrice ||
        currentFilters.maxPrice || currentFilters.roomNumber;
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

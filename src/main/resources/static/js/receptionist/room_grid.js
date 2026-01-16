/**
 * Room Grid Management
 * Visual grid display of rooms organized by floor
 */

let roomsData = [];
let selectedRoom = null;

// Status Transitions Map
// Status Transitions Map
const STATUS_TRANSITIONS = {
    'AVAILABLE': ['OCCUPIED', 'BOOKED', 'DIRTY', 'CLEANING', 'MAINTENANCE'],
    'OCCUPIED': ['AVAILABLE', 'BOOKED', 'DIRTY', 'CLEANING', 'MAINTENANCE'],
    'BOOKED': ['AVAILABLE', 'OCCUPIED', 'DIRTY', 'CLEANING', 'MAINTENANCE'],
    'DIRTY': ['AVAILABLE', 'OCCUPIED', 'BOOKED', 'CLEANING', 'MAINTENANCE'],
    'CLEANING': ['AVAILABLE', 'OCCUPIED', 'BOOKED', 'DIRTY', 'MAINTENANCE'],
    'MAINTENANCE': ['AVAILABLE', 'OCCUPIED', 'BOOKED', 'DIRTY', 'CLEANING']
};

const STATUS_DISPLAY = {
    'AVAILABLE': { text: 'Trống', class: 'available', icon: 'fa-check' },
    'OCCUPIED': { text: 'Có khách', class: 'occupied', icon: 'fa-user' },
    'BOOKED': { text: 'Đã đặt', class: 'booked', icon: 'fa-calendar-check' },
    'DIRTY': { text: 'Cần dọn', class: 'dirty', icon: 'fa-broom' },
    'CLEANING': { text: 'Đang dọn', class: 'cleaning', icon: 'fa-soap' },
    'MAINTENANCE': { text: 'Bảo trì', class: 'maintenance', icon: 'fa-tools' }
};

// Initialize
// Initialize
document.addEventListener('DOMContentLoaded', function () {
    // Display branch name
    const currentUser = getCurrentUser();
    if (currentUser && currentUser.branchName) {
        document.getElementById('branch-name-display').textContent = currentUser.branchName;
    } else {
        document.getElementById('branch-name-display').textContent = 'Chi nhánh';
    }

    loadRooms();
    startClock();

    // Auto-refresh every 3 seconds
    setInterval(() => {
        // Silent update (pass true to indicate background reload if needed, 
        // though loadRooms implementation replaces innerHTML so it might flicker slightly. 
        // Ideally we'd diff, but for now just reload is requested.)
        loadRooms();
    }, 3000);
});

// Load all rooms
async function loadRooms() {
    try {
        const rooms = await callAPI('/rooms', 'GET');
        roomsData = rooms;
        renderRoomGrid(rooms);
        updateStats(rooms);
    } catch (error) {
        document.getElementById('room-grid-container').innerHTML = `
            <div style="text-align: center; padding: 60px;">
                <i class="fas fa-exclamation-triangle" style="font-size: 48px; color: var(--error);"></i>
                <p style="margin-top: 20px; color: var(--error);">Lỗi tải dữ liệu: ${error.message}</p>
            </div>
        `;
    }
}

// Render room grid organized by floor
function renderRoomGrid(rooms) {
    const container = document.getElementById('room-grid-container');

    if (!rooms || rooms.length === 0) {
        container.innerHTML = `
            <div style="text-align: center; padding: 60px;">
                <i class="fas fa-bed" style="font-size: 48px; color: var(--text-muted);"></i>
                <p style="margin-top: 20px; color: var(--text-muted);">Không có phòng nào trong hệ thống</p>
            </div>
        `;
        return;
    }

    // Group rooms by floor
    const roomsByFloor = {};
    rooms.forEach(room => {
        // Floor is the first digit of the room number
        const floor = room.roomNumber ? String(room.roomNumber).charAt(0) : 1;

        if (!roomsByFloor[floor]) {
            roomsByFloor[floor] = [];
        }
        roomsByFloor[floor].push(room);
    });

    // Sort floors
    const floors = Object.keys(roomsByFloor).sort((a, b) => b - a); // Descending order

    // Render each floor
    container.innerHTML = floors.map(floor => {
        const floorRooms = roomsByFloor[floor].sort((a, b) => a.roomNumber - b.roomNumber);

        return `
            <div class="floor-section">
                <div class="floor-header">
                    <i class="fas fa-layer-group"></i>
                    <span>Tầng ${floor}</span>
                    <span style="font-size: 14px; font-weight: 400; color: var(--text-muted); margin-left: auto;">
                        ${floorRooms.length} phòng
                    </span>
                </div>
                <div class="rooms-grid">
                    ${floorRooms.map(room => renderRoomBox(room)).join('')}
                </div>
            </div>
        `;
    }).join('');
}

// Render individual room box
function renderRoomBox(room) {
    const status = room.status ? room.status.toLowerCase() : 'available';
    const statusText = getStatusText(room.status);

    // Get guest name if occupied/booked
    let guestName = '';
    if (room.currentBooking && (room.status === 'OCCUPIED' || room.status === 'BOOKED')) {
        guestName = `<div class="room-guest-name">${room.currentBooking.customerName || 'N/A'}</div>`;
    }

    return `
        <div class="room-box ${status}" 
             onclick="handleRoomClick(event, ${room.id})" 
             data-room-id="${room.id}">
            <div class="room-number">${room.roomNumber}</div>
            <div class="room-type">${room.type || 'Standard'}</div>
            <div class="room-status-text">${statusText}</div>
            ${guestName}
        </div>
    `;
}

// Get status display text
function getStatusText(status) {
    const statusMap = {
        'AVAILABLE': 'Trống',
        'OCCUPIED': 'Có khách',
        'BOOKED': 'Đã đặt',
        'DIRTY': 'Cần dọn',
        'MAINTENANCE': 'Bảo trì'
    };
    return statusMap[status] || status;
}

// Update statistics
function updateStats(rooms) {
    const stats = {
        available: 0,
        occupied: 0,
        booked: 0,
        dirty: 0,
        cleaning: 0,
        maintenance: 0
    };

    rooms.forEach(room => {
        const status = room.status ? room.status.toLowerCase() : 'available';
        if (stats[status] !== undefined) {
            stats[status]++;
        }
    });

    document.getElementById('stat-available').textContent = stats.available;
    document.getElementById('stat-occupied').textContent = stats.occupied;
    document.getElementById('stat-booked').textContent = stats.booked;
    document.getElementById('stat-dirty').textContent = stats.dirty;
    document.getElementById('stat-cleaning').textContent = stats.cleaning;
    document.getElementById('stat-maintenance').textContent = stats.maintenance;
}

// Show room details modal
async function showRoomDetails(roomId) {
    const room = roomsData.find(r => r.id === roomId);
    if (!room) return;

    selectedRoom = room;

    // Update Modal Title
    document.getElementById('modalRoomTitle').textContent = `Phòng ${room.roomNumber} - ${room.type}`;

    // Dynamic Status Buttons
    const buttonsContainer = document.getElementById('status-transition-buttons');
    if (buttonsContainer) {
        buttonsContainer.innerHTML = '';
        const currentStatus = room.status || 'AVAILABLE';
        const allowedStatuses = STATUS_TRANSITIONS[currentStatus] || [];

        if (allowedStatuses.length > 0) {
            allowedStatuses.forEach(status => {
                const config = STATUS_DISPLAY[status];
                const btn = document.createElement('button');
                btn.className = `status-btn ${config.class}`;
                btn.innerHTML = `<i class="fas ${config.icon}"></i>${config.text}`;
                btn.onclick = () => updateRoomStatus(status);
                buttonsContainer.appendChild(btn);
            });
            document.getElementById('status-buttons-section').style.display = 'block';
        } else {
            document.getElementById('status-buttons-section').style.display = 'none';
        }
    }

    // Show Modal
    const modal = document.getElementById('room-details-modal');
    // Using simple display block as per previous code, ignoring ModalManager for now to keep it working
    // But wait, the HTML uses ModalManager. Let's try to use ModalManager if available, or fallback.
    if (window.ModalManager) {
        ModalManager.open('room-details-modal');
    } else {
        modal.style.display = 'block';
    }
}

// Update Room Status directly
async function updateRoomStatus(newStatus) {
    if (!selectedRoom) return;

    if (!confirm(`Bạn có chắc chắn muốn chuyển trạng thái phòng sang ${STATUS_DISPLAY[newStatus].text}?`)) {
        return;
    }

    try {
        // Send status in body as expected by Controller
        await callAPI(`/rooms/${selectedRoom.id}/status`, 'PUT', {
            status: newStatus
        });

        // Update local data
        selectedRoom.status = newStatus;

        // Close modal
        if (window.ModalManager) {
            ModalManager.close('room-details-modal');
        } else {
            document.getElementById('room-details-modal').style.display = 'none';
        }

        // Reload rooms to refresh grid
        loadRooms();

        // Show success toast if available
        if (window.showToast) {
            showToast('Cập nhật trạng thái thành công', 'success');
        } else {
            alert('Cập nhật trạng thái thành công');
        }

    } catch (error) {
        alert('Lỗi cập nhật trạng thái: ' + error.message);
    }
}

// Show Edit Room Form
function showEditRoomForm() {
    if (!selectedRoom) return;

    ModalManager.close('room-details-modal');

    // Populate form with current room data
    document.getElementById('edit-room-id').value = selectedRoom.id;
    document.getElementById('edit-room-number').value = selectedRoom.roomNumber;
    document.getElementById('edit-room-type').value = selectedRoom.type || 'STANDARD';
    document.getElementById('edit-room-price').value = selectedRoom.price || 0;
    document.getElementById('edit-room-branch').value = selectedRoom.branchName || '';

    ModalManager.open('edit-room-modal');
}

// Handle Update Room Information
async function handleUpdateRoomInfo(event) {
    event.preventDefault();

    const formData = new FormData(event.target);
    const roomId = document.getElementById('edit-room-id').value;

    const updates = {
        roomNumber: formData.get('roomNumber'),
        type: formData.get('type'),
        price: parseFloat(formData.get('price'))
    };

    try {
        const response = await callAPI(`/rooms/${roomId}`, 'PUT', updates);

        alert('Cập nhật thông tin phòng thành công!');

        // Close modal
        ModalManager.close('edit-room-modal');

        // Reload rooms to refresh grid
        loadRooms();

    } catch (error) {
        alert('Lỗi cập nhật thông tin phòng: ' + error.message);
    }
}

// Handle Room Click (Context Menu style)
function handleRoomClick(event, roomId) {
    // Stop propagation so it doesn't trigger global click close immediately if bubbled?
    // Actually we need to be careful. The document click listener closes it.
    // So we should stopImmediatePropagation or handle styling.
    event.stopPropagation();

    event.preventDefault(); // Good habit
    const room = roomsData.find(r => r.id === roomId);
    if (!room) return;

    selectedRoom = room;
    const menu = document.getElementById('context-menu');
    const currentStatus = room.status || 'AVAILABLE';
    const allowedStatuses = STATUS_TRANSITIONS[currentStatus] || [];

    let menuContent = `
        <div class="context-menu-item" style="cursor: default; opacity: 0.7; border-bottom: 1px solid rgba(255,255,255,0.1); font-weight: 600;">
            <i class="fas fa-info-circle"></i> Phòng ${room.roomNumber} (${getStatusText(currentStatus)})
        </div>
    `;

    if (allowedStatuses.length > 0) {
        allowedStatuses.forEach(status => {
            const config = STATUS_DISPLAY[status];
            menuContent += `
                <div class="context-menu-item" onclick="updateRoomStatus('${status}')">
                    <i class="fas ${config.icon}" style="color: ${getColorForStatus(status)}"></i> 
                    ${config.text}
                </div>
            `;
        });
    } else {
        menuContent += `
            <div class="context-menu-item" style="cursor: default; font-style: italic; color: #94a3b8;">
                <i class="fas fa-ban"></i> Không có hành động
            </div>
        `;
    }

    // Add "View Details" option
    menuContent += `
        <div class="context-menu-divider"></div>
        <div class="context-menu-item" onclick="showRoomDetails(${room.id})">
            <i class="fas fa-eye"></i> Xem chi tiết
        </div>
    `;

    menu.innerHTML = menuContent;

    // Position menu
    menu.style.display = 'block';

    // Adjust position to stay within viewport
    let x = event.pageX;
    let y = event.pageY;

    if (x + 200 > window.innerWidth) x -= 200;

    menu.style.left = x + 'px';
    menu.style.top = y + 'px';
}

function hideContextMenu() {
    const menu = document.getElementById('context-menu');
    if (menu) menu.style.display = 'none';
}

// Helper to get color for icon
function getColorForStatus(status) {
    const map = {
        'AVAILABLE': '#10b981',
        'OCCUPIED': '#ef4444',
        'BOOKED': '#3b82f6',
        'DIRTY': '#f97316',
        'CLEANING': '#eab308',
        'MAINTENANCE': '#6b7280'
    };
    return map[status] || '#fff';
}

// Start clock
function startClock() {
    function updateTime() {
        const now = new Date();
        document.getElementById('current-time').textContent = now.toLocaleTimeString('vi-VN');
    }
    updateTime();
    setInterval(updateTime, 1000);
}

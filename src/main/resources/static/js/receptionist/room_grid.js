/**
 * Room Grid Management
 * Visual grid display of rooms organized by floor
 */

let roomsData = [];
let selectedRoom = null;

// Initialize
document.addEventListener('DOMContentLoaded', function () {
    loadRooms();
    startClock();
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
        <div class="room-box ${status}" onclick="showRoomDetails(${room.id})" data-room-id="${room.id}">
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
    document.getElementById('stat-maintenance').textContent = stats.maintenance;
}

// Show room details modal
async function showRoomDetails(roomId) {
    const room = roomsData.find(r => r.id === roomId);
    if (!room) return;

    selectedRoom = room;

    // Update Modal Title
    document.getElementById('modalRoomTitle').textContent = `Phòng ${room.roomNumber} - ${room.type}`;

    // Show Modal
    const modal = document.getElementById('roomModal');
    modal.style.display = 'block';

    // Setup close button
    const span = modal.querySelector('.close-modal');
    span.onclick = function () {
        modal.style.display = 'none';
    }

    window.onclick = function (event) {
        if (event.target == modal) {
            modal.style.display = 'none';
        }
    }
}

// Update Room Status directly
async function updateRoomStatus(newStatus) {
    if (!selectedRoom) return;

    try {
        // Send status in body as expected by Controller
        await callAPI(`/rooms/${selectedRoom.id}/status`, 'PUT', {
            status: newStatus
        });

        // Update local data
        selectedRoom.status = newStatus;

        // Close modal
        document.getElementById('roomModal').style.display = 'none';

        // Reload rooms to refresh grid
        loadRooms();

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

// Start clock
function startClock() {
    function updateTime() {
        const now = new Date();
        document.getElementById('current-time').textContent = now.toLocaleTimeString('vi-VN');
    }
    updateTime();
    setInterval(updateTime, 1000);
}

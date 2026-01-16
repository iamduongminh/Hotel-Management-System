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

// Menu configurations for each room status
const MENU_CONFIGS = {
    AVAILABLE: [
        { icon: 'fa-user-plus', text: 'Khách đến (Check-in)', action: 'showWalkInModal', color: '#10b981' },
        { type: 'divider' },
        { icon: 'fa-broom', text: 'Cần dọn', action: 'updateRoomStatus', status: 'DIRTY', color: '#f97316' },
        { icon: 'fa-tools', text: 'Bảo trì', action: 'updateRoomStatus', status: 'MAINTENANCE', color: '#6b7280' }
    ],
    BOOKED: [
        { icon: 'fa-calendar-check', text: 'Chi tiết booking', action: 'showBookingInfo', color: '#3b82f6' },
        { type: 'divider' },
        { icon: 'fa-door-open', text: 'Check-in', action: 'confirmCheckIn', color: '#10b981' },
        { icon: 'fa-times-circle', text: 'Hủy booking', action: 'cancelBooking', color: '#ef4444' },
        { type: 'divider' },
        { icon: 'fa-broom', text: 'Cần dọn', action: 'updateRoomStatus', status: 'DIRTY' },
        { icon: 'fa-tools', text: 'Bảo trì', action: 'updateRoomStatus', status: 'MAINTENANCE' }
    ],
    OCCUPIED: [
        { icon: 'fa-concierge-bell', text: 'Dịch vụ đã dùng', action: 'showServices' },
        { type: 'divider' },
        { icon: 'fa-cash-register', text: 'Check-out & Thanh toán', action: 'showCheckoutModal', color: '#f59e0b' }
    ],
    CHECKED_IN: [
        { icon: 'fa-cash-register', text: 'Check-out & Thanh toán', action: 'showCheckoutModal', color: '#f59e0b' }
    ],
    DIRTY: [
        { icon: 'fa-soap', text: 'Đang dọn', action: 'updateRoomStatus', status: 'CLEANING', color: '#eab308' },
        { icon: 'fa-check', text: 'Sẵn sàng (Trống)', action: 'updateRoomStatus', status: 'AVAILABLE', color: '#10b981' },
        { icon: 'fa-tools', text: 'Bảo trì', action: 'updateRoomStatus', status: 'MAINTENANCE' }
    ],
    CLEANING: [
        { icon: 'fa-check', text: 'Hoàn tất (Trống)', action: 'updateRoomStatus', status: 'AVAILABLE', color: '#10b981' },
        { icon: 'fa-broom', text: 'Vẫn còn bẩn', action: 'updateRoomStatus', status: 'DIRTY', color: '#f97316' },
        { icon: 'fa-tools', text: 'Bảo trì', action: 'updateRoomStatus', status: 'MAINTENANCE' }
    ],
    MAINTENANCE: [
        { icon: 'fa-check', text: 'Hoàn tất (Trống)', action: 'updateRoomStatus', status: 'AVAILABLE', color: '#10b981' },
        { icon: 'fa-broom', text: 'Cần dọn', action: 'updateRoomStatus', status: 'DIRTY' }
    ]
};

// Initialize
// Initialize
document.addEventListener('DOMContentLoaded', function () {
    // Branch name display logic removed

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

// Load all rooms and bookings
async function loadRooms() {
    try {
        const [rooms, bookings] = await Promise.all([
            callAPI('/rooms', 'GET'),
            callAPI('/bookings', 'GET')
        ]);

        // Map active bookings to rooms
        const activeBookings = bookings.filter(b =>
            ['OCCUPIED', 'BOOKED', 'CHECKED_IN'].includes(b.status)
        );

        rooms.forEach(room => {
            // Find booking for this room
            // Note: If multiple, take the one that overlaps "now" or is active
            const booking = activeBookings.find(b => b.room && b.room.id === room.id);
            if (booking) {
                room.currentBooking = booking;
            }
        });

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
                    <span style="font-size: 14px; font-weight: 400; color: var(--text-muted); margin-top: 4px;">
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
    // Show guest name for OCCUPIED and BOOKED, checking if currentBooking exists
    if (room.currentBooking && (room.status === 'OCCUPIED' || room.status === 'BOOKED' || room.status === 'CHECKED_IN')) {
        guestName = `<div class="room-guest-name">${room.currentBooking.customerName || 'Khách'}</div>`;
    }

    // Format tooltip info
    const priceFormatted = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(room.price);
    const tooltipText = `Phòng ${room.roomNumber} • ${room.type || 'Standard'} • ${priceFormatted}/đêm`;

    return `
        <div class="room-box ${status}" 
             onclick="handleRoomClick(event, ${room.id})" 
             data-room-id="${room.id}">
            <div class="room-tooltip">${tooltipText}</div>
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
        'APP_AVAILABLE': 'Trống', // Handle potential alias
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
        let status = room.status ? room.status.toLowerCase() : 'available';
        // Normalize status
        if (status === 'app_available') status = 'available';

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

    // Populate details in body
    const detailsContent = document.getElementById('room-details-content');
    if (detailsContent) {
        let bookingInfo = '';
        if (room.currentBooking) {
            const b = room.currentBooking;
            const checkInDate = b.checkInDate ? new Date(b.checkInDate).toLocaleString('vi-VN', { dateStyle: 'short', timeStyle: 'short' }) : 'N/A';
            const checkOutDate = b.checkOutDate ? new Date(b.checkOutDate).toLocaleString('vi-VN', { dateStyle: 'short', timeStyle: 'short' }) : 'N/A';
            const nights = calculateNights(b.checkInDate, b.checkOutDate);

            bookingInfo = `
                <div class="detail-section" style="margin-top: 20px;">
                    <div class="section-title" style="color: var(--primary); margin-bottom: 12px;">
                        <i class="fas fa-calendar-check"></i> Thông tin lưu trú
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Khách hàng</span>
                        <span class="detail-value">${b.customerName || 'N/A'}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Check-in</span>
                        <span class="detail-value" style="color: var(--success);">${checkInDate}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Check-out dự kiến</span>
                        <span class="detail-value" style="color: var(--warning);">${checkOutDate}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Số đêm</span>
                        <span class="detail-value">${nights} đêm</span>
                    </div>
                </div>
            `;
        }

        detailsContent.innerHTML = `
            <div class="detail-section">
                <div class="section-title" style="color: var(--primary); margin-bottom: 12px;">
                    <i class="fas fa-door-open"></i> Thông tin phòng
                </div>
                <div class="detail-row">
                    <span class="detail-label">Số phòng</span>
                    <span class="detail-value" style="font-weight: 700; font-size: 16px;">${room.roomNumber}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Loại phòng</span>
                    <span class="detail-value">${room.type || 'Standard'}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Giá phòng/đêm</span>
                    <span class="detail-value" style="color: var(--success); font-weight: 600;">${new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(room.price)}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Trạng thái</span>
                    <span class="detail-value">
                        <span class="status-badge ${room.status ? room.status.toLowerCase() : ''}" style="padding: 4px 12px; border-radius: 12px; font-size: 12px;">
                            ${getStatusText(room.status)}
                        </span>
                    </span>
                </div>
            </div>
            ${bookingInfo}
        `;
    }


    // Configure Edit Button
    const editBtn = document.getElementById('modal-edit-btn');
    if (editBtn) {
        editBtn.innerHTML = '<i class="fas fa-edit"></i> Chỉnh sửa thông tin phòng';
        editBtn.onclick = showEditRoomForm;
        editBtn.style.display = 'inline-block';
    }

    // Show Modal
    if (window.ModalManager) {
        ModalManager.open('room-details-modal');
    } else {
        document.getElementById('room-details-modal').style.display = 'block';
    }
}


// Calculate nights between two dates
function calculateNights(checkIn, checkOut) {
    if (!checkIn || !checkOut) return 0;
    const start = new Date(checkIn);
    const end = new Date(checkOut);
    const diff = end - start;
    return Math.ceil(diff / (1000 * 60 * 60 * 24));
}

// Update Room Status directly
async function updateRoomStatus(roomId, newStatus) {
    // Legacy support if called with single argument
    if (newStatus === undefined) {
        newStatus = roomId;
        roomId = selectedRoom ? selectedRoom.id : null;
    }

    if (!roomId) {
        alert("Không xác định được phòng cần cập nhật");
        return;
    }

    try {
        await callAPI(`/rooms/${roomId}/status`, 'PUT', {
            status: newStatus
        });

        // Update local data
        const room = roomsData.find(r => r.id == roomId);
        if (room) {
            room.status = newStatus;
        }

        // Also update global selectedRoom if it matches
        if (selectedRoom && selectedRoom.id == roomId) {
            selectedRoom.status = newStatus;
        }

        // Close modal if open
        if (window.ModalManager) {
            ModalManager.close('room-details-modal');
        } else {
            const modal = document.getElementById('room-details-modal');
            if (modal) modal.style.display = 'none';
        }

        // Reload rooms to refresh grid
        loadRooms();

        if (window.showToast) {
            showToast('Cập nhật trạng thái thành công', 'success');
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
        await callAPI(`/rooms/${roomId}`, 'PUT', updates);
        alert('Cập nhật thông tin phòng thành công!');
        ModalManager.close('edit-room-modal');
        loadRooms();

    } catch (error) {
        alert('Lỗi cập nhật thông tin phòng: ' + error.message);
    }
}

// Show Edit Booking Form
function showEditBookingForm(bookingId) {
    // If selectedRoom is not set or doesn't match, find the room
    if (!selectedRoom || (selectedRoom.currentBooking && selectedRoom.currentBooking.id !== bookingId)) {
        selectedRoom = roomsData.find(r => r.currentBooking && r.currentBooking.id === bookingId);
    }

    if (!selectedRoom || !selectedRoom.currentBooking) {
        alert("Không tìm thấy thông tin booking để sửa");
        return;
    }

    const booking = selectedRoom.currentBooking;

    ModalManager.close('room-details-modal');

    document.getElementById('edit-booking-id').value = booking.id;
    document.getElementById('edit-booking-customer').value = booking.customerName;

    // Format dates for datetime-local input (YYYY-MM-DDTHH:mm)
    // Assuming backend returns ISO string or similar
    const checkIn = booking.checkInDate ? new Date(booking.checkInDate).toISOString().slice(0, 16) : '';
    const checkOut = booking.checkOutDate ? new Date(booking.checkOutDate).toISOString().slice(0, 16) : '';

    document.getElementById('edit-booking-checkin').value = checkIn;
    document.getElementById('edit-booking-checkout').value = checkOut;

    ModalManager.open('edit-booking-modal');
}

// Handle Update Booking Information
async function handleUpdateBookingInfo(event) {
    event.preventDefault();

    const formData = new FormData(event.target);
    const bookingId = document.getElementById('edit-booking-id').value;

    const updates = {
        customerName: formData.get('customerName'),
        checkInDate: formData.get('checkInDate'),
        checkOutDate: formData.get('checkOutDate')
    };

    try {
        await callAPI(`/bookings/${bookingId}`, 'PUT', updates);
        alert('Cập nhật thông tin booking thành công!');
        ModalManager.close('edit-booking-modal');
        loadRooms();
    } catch (error) {
        alert('Lỗi cập nhật booking: ' + error.message);
    }
}

// Show Walk-in Modal
function showWalkInModal(roomId) {
    const room = roomsData.find(r => r.id === roomId);
    if (!room) return;

    selectedRoom = room;

    document.getElementById('walkin-room-id').value = roomId;
    document.getElementById('walkin-room-number').textContent = room.roomNumber;

    // Set default check-out to tomorrow noon
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    tomorrow.setHours(12, 0, 0, 0);

    // Adjust to local ISO string for input
    const tzOffset = tomorrow.getTimezoneOffset() * 60000; // offset in milliseconds
    const localISOTime = (new Date(tomorrow - tzOffset)).toISOString().slice(0, 16);

    document.getElementById('walkin-checkout').value = localISOTime;

    ModalManager.open('walkin-modal');
}

// Handle Walk-in Submit
async function handleWalkInSubmit(event) {
    event.preventDefault();

    const formData = new FormData(event.target);
    const roomId = formData.get('roomId');

    const bookingData = {
        roomId: parseInt(roomId),
        customerName: formData.get('customerName'),
        customerPhone: formData.get('customerPhone'),
        identityCard: formData.get('identityCard'),
        checkInDate: new Date(), // Now
        checkOutDate: new Date(formData.get('checkOutDate')),
        status: 'CHECKED_IN' // Attempt to set directly to CHECKED_IN
    };

    try {
        // First create booking
        // Note: Backend might define status logic. If we can't set CHECKED_IN directly,
        // we might need to create (BOOKED) then Check-in.
        // Let's try sending status 'CHECKED_IN' first.

        const response = await callAPI('/bookings', 'POST', bookingData);

        // If response doesn't error, assume success.
        // We might need to handle separate check-in call if status wasn't accepted.
        // But for "Walk-in", a single API is ideal.
        // If the backend forces BOOKED, we'd check response.status.

        // Assuming success:
        showSuccess(`✅ Check-in thành công cho phòng ${document.getElementById('walkin-room-number').textContent}`);
        ModalManager.close('walkin-modal');
        event.target.reset();

        loadRooms(); // Refresh grid

    } catch (error) {
        showError('Lỗi check-in: ' + error.message);
    }
}

// Build context menu HTML based on room status
function buildContextMenu(room) {
    const status = room.status || 'AVAILABLE';
    const config = MENU_CONFIGS[status] || MENU_CONFIGS.AVAILABLE;

    let html = `
        <div class="context-menu-item" style="cursor: default; opacity: 0.7; border-bottom: 1px solid rgba(255,255,255,0.1); font-weight: 600;">
            <i class="fas fa-door-open"></i> Phòng ${room.roomNumber} • ${getStatusText(status)}
        </div>
    `;

    // Add booking info if exists
    if (room.currentBooking) {
        const checkIn = room.currentBooking.checkInDate ? new Date(room.currentBooking.checkInDate).toLocaleDateString('vi-VN') : '';
        const checkOut = room.currentBooking.checkOutDate ? new Date(room.currentBooking.checkOutDate).toLocaleDateString('vi-VN') : '';

        html += `
            <div class="context-menu-item" style="cursor: default; font-size: 12px; color: var(--text-muted); border-bottom: 1px solid rgba(255,255,255,0.1); padding: 8px 16px;">
                <div style="display: flex; flex-direction: column; gap: 4px; width: 100%;">
                    <div><i class="fas fa-user"></i> ${room.currentBooking.customerName || 'N/A'}</div>
                    ${checkIn ? `<div style="font-size: 11px;"><i class="fas fa-calendar-check"></i> ${checkIn} → ${checkOut}</div>` : ''}
                </div>
            </div>
        `;
    }

    config.forEach(section => {
        // Handle dividers
        if (section.type === 'divider') {
            html += `<div class="context-menu-divider"></div>`;
        }
        // Handle regular menu items
        else {
            const onclick = section.status
                ? `hideContextMenu(); ${section.action}(${room.id}, '${section.status}')`
                : `hideContextMenu(); ${section.action}(${room.id})`;
            html += `
                <div class="context-menu-item" onclick="${onclick}">
                    <i class="fas ${section.icon}" style="${section.color ? 'color: ' + section.color : ''}"></i> 
                    ${section.text}
                </div>
            `;
        }
    });

    return html;
}

// Show booking information modal
function showBookingInfo(roomId) {
    const room = roomsData.find(r => r.id === roomId);
    if (!room || !room.currentBooking) {
        alert('Không tìm thấy thông tin booking');
        return;
    }

    hideContextMenu();

    const booking = room.currentBooking;
    const checkIn = booking.checkInDate ? new Date(booking.checkInDate).toLocaleString('vi-VN') : 'N/A';
    const checkOut = booking.checkOutDate ? new Date(booking.checkOutDate).toLocaleString('vi-VN') : 'N/A';
    const nights = calculateNights(booking.checkInDate, booking.checkOutDate);

    const content = `
        <div style="background: rgba(30, 41, 59, 0.5); padding: 20px; border-radius: 8px;">
            <h3 style="margin: 0 0 16px 0; color: var(--text-primary);">
                <i class="fas fa-calendar-check"></i> Thông Tin Booking #${booking.id}
            </h3>
            <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px;">
                <div>
                    <div style="color: var(--text-muted); font-size: 12px; margin-bottom: 4px;">Tên khách</div>
                    <div style="color: var(--text-primary); font-weight: 600;">${booking.customerName || 'N/A'}</div>
                </div>
                <div>
                    <div style="color: var(--text-muted); font-size: 12px; margin-bottom: 4px;">Số phòng</div>
                    <div style="color: var(--text-primary); font-weight: 600;">Phòng ${room.roomNumber}</div>
                </div>
                <div>
                    <div style="color: var(--text-muted); font-size: 12px; margin-bottom: 4px;">Check-in dự kiến</div>
                    <div style="color: var(--success); font-weight: 600;">${checkIn}</div>
                </div>
                <div>
                    <div style="color: var(--text-muted); font-size: 12px; margin-bottom: 4px;">Check-out dự kiến</div>
                    <div style="color: var(--warning); font-weight: 600;">${checkOut}</div>
                </div>
                <div>
                    <div style="color: var(--text-muted); font-size: 12px; margin-bottom: 4px;">Số đêm</div>
                    <div style="color: var(--text-primary); font-weight: 600;">${nights} đêm</div>
                </div>
                <div>
                    <div style="color: var(--text-muted); font-size: 12px; margin-bottom: 4px;">Trạng thái</div>
                    <div style="color: var(--info); font-weight: 600;">${booking.status || 'N/A'}</div>
                </div>
            </div>
        </div>
    `;

    // Reuse room details modal
    document.getElementById('room-details-content').innerHTML = content;
    document.getElementById('modal-room-number').textContent = room.roomNumber;
    document.getElementById('status-buttons-section').style.display = 'none';

    // Configure Edit Button for Booking
    const editBtn = document.getElementById('modal-edit-btn');
    if (editBtn) {
        editBtn.innerHTML = '<i class="fas fa-edit"></i> Chỉnh sửa thông tin booking';
        editBtn.onclick = () => showEditBookingForm(booking.id);
        editBtn.style.display = 'inline-block';
    }

    ModalManager.open('room-details-modal');
}

// Show guest information
function showGuestInfo(roomId) {
    const room = roomsData.find(r => r.id === roomId);
    if (!room || !room.currentBooking) {
        alert('Không có thông tin khách');
        return;
    }

    hideContextMenu();
    showBookingInfo(roomId); // For now, same as booking info
}

// Show services used
function showServices(roomId) {
    hideContextMenu();
    alert('Chức năng xem dịch vụ đang phát triển');
}

// Check-in for existing booking
async function confirmCheckIn(roomId) {
    const room = roomsData.find(r => r.id === roomId);
    if (!room || !room.currentBooking) {
        alert('Không tìm thấy booking');
        return;
    }

    hideContextMenu();

    if (!confirm(`Xác nhận check-in cho ${room.currentBooking.customerName}?`)) return;

    try {
        await callAPI(`/checkin/${room.currentBooking.id}`, 'POST');
        showSuccess('✅ Check-in thành công!');
        loadRooms();
    } catch (error) {
        showError('Lỗi check-in: ' + error.message);
    }
}

// Cancel booking
async function cancelBooking(roomId) {
    const room = roomsData.find(r => r.id === roomId);
    if (!room || !room.currentBooking) {
        alert('Không tìm thấy booking');
        return;
    }

    hideContextMenu();

    if (!confirm(`Xác nhận HỦY booking cho ${room.currentBooking.customerName}?\n\nHành động này không thể hoàn tác!`)) return;

    try {
        await callAPI(`/bookings/${room.currentBooking.id}`, 'DELETE');
        showSuccess('✅ Đã hủy booking');
        loadRooms();
    } catch (error) {
        showError('Lỗi: ' + error.message);
    }
}

// Show checkout modal (similar to stay_management.js)
async function showCheckoutModal(roomId) {
    const room = roomsData.find(r => r.id === roomId);
    if (!room || !room.currentBooking) {
        alert('Không có thông tin lưu trú');
        return;
    }

    hideContextMenu();

    // Redirect to stay management for full checkout flow
    if (confirm('Chuyển đến trang Quản lý lưu trú để check-out?')) {
        window.location.href = 'stay_management.html';
    }
}



// Handle Room Click (Context Menu style)
function handleRoomClick(event, roomId) {
    event.stopPropagation();
    event.preventDefault();

    const room = roomsData.find(r => r.id === roomId);
    if (!room) return;

    selectedRoom = room;
    const menu = document.getElementById('context-menu');

    // Build menu using new structure
    menu.innerHTML = buildContextMenu(room);
    menu.style.display = 'block';

    // Get the room box element position
    const roomBox = event.currentTarget;
    const rect = roomBox.getBoundingClientRect();

    // Position menu to the right of the room box
    // getBoundingClientRect gives viewport coords, need to add scroll offset for absolute positioning
    let x = rect.right + window.scrollX + 10; // 10px gap
    let y = rect.top + window.scrollY;

    // Adjust if going off-screen
    const menuWidth = 240;
    const menuHeight = 300; // Approximate

    // If menu would go off right edge, show on left
    if (x + menuWidth > window.innerWidth + window.scrollX) {
        x = rect.left + window.scrollX - menuWidth - 10;
    }

    // If still off-screen, position inside viewport
    if (x < window.scrollX) {
        x = window.scrollX + 10;
    }

    // Adjust vertical position if needed
    if (y + menuHeight > window.innerHeight + window.scrollY) {
        y = window.innerHeight + window.scrollY - menuHeight - 10;
    }

    if (y < window.scrollY) {
        y = window.scrollY + 10;
    }

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

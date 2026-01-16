/**
 * Stay Management - Check-in & Check-out
 * Main workflow for receptionist
 */

let bookedData = [];
let occupiedData = [];
let selectedBooking = null;

// Initialize
document.addEventListener('DOMContentLoaded', function () {
    loadBookings();
    setupSearch();
    startClock();
});

// Load bookings
async function loadBookings() {
    try {
        const bookings = await callAPI('/bookings', 'GET');

        // Filter by status
        bookedData = bookings.filter(b => b.status === 'BOOKED');
        occupiedData = bookings.filter(b => b.status === 'CHECKED_IN');

        renderBookedTable(bookedData);
        renderOccupiedTable(occupiedData);
        updateStats(bookedData, occupiedData);

        // Populate room filters
        populateRoomFilters(bookings);
    } catch (error) {
        console.error('Error loading bookings:', error);
        document.getElementById('booked-tbody').innerHTML = `
            <tr><td colspan="7" style="text-align: center; color: var(--error); padding: 20px;">
                ❌ Lỗi:  ${error.message}
            </td></tr>
        `;
        document.getElementById('occupied-tbody').innerHTML = `
            <tr><td colspan="7" style="text-align: center; color: var(--error); padding: 20px;">
                ❌ Lỗi: ${error.message}
            </td></tr>
        `;
    }
}

// Render booked table
function renderBookedTable(bookings) {
    const tbody = document.getElementById('booked-tbody');

    if (!bookings || bookings.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; padding: 20px; color: var(--text-muted);">Không có booking chờ check-in</td></tr>';
        return;
    }

    tbody.innerHTML = bookings.map(booking => {
        const checkIn = booking.checkInDate ? new Date(booking.checkInDate).toLocaleString('vi-VN', { dateStyle: 'short', timeStyle: 'short' }) : 'N/A';
        const checkOut = booking.checkOutDate ? new Date(booking.checkOutDate).toLocaleString('vi-VN', { dateStyle: 'short', timeStyle: 'short' }) : 'N/A';
        const nights = calculateNights(booking.checkInDate, booking.checkOutDate);

        return `
            <tr>
                <td><strong>#${booking.id}</strong></td>
                <td><strong>Phòng ${booking.room?.roomNumber || 'N/A'}</strong></td>
                <td>${booking.customerName || 'N/A'}</td>
                <td>${checkIn}</td>
                <td>${checkOut}</td>
                <td>${nights} đêm</td>
                <td>
                    <button class="btn btn-success" style="padding: 8px 16px; font-size: 13px;" 
                            onclick="showCheckInModal(${booking.id})">
                        <i class="fas fa-door-open"></i> Check-in
                    </button>
                </td>
            </tr>
        `;
    }).join('');
}

// Render occupied table
function renderOccupiedTable(bookings) {
    const tbody = document.getElementById('occupied-tbody');

    if (!bookings || bookings.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; padding: 20px; color: var(--text-muted);">Không có khách đang lưu trú</td></tr>';
        return;
    }

    tbody.innerHTML = bookings.map(booking => {
        const checkIn = booking.checkInDate ? new Date(booking.checkInDate).toLocaleString('vi-VN', { dateStyle: 'short', timeStyle: 'short' }) : 'N/A';
        const checkOut = booking.checkOutDate ? new Date(booking.checkOutDate).toLocaleString('vi-VN', { dateStyle: 'short', timeStyle: 'short' }) : 'N/A';
        const nights = calculateNights(booking.checkInDate, booking.checkOutDate);

        return `
            <tr>
                <td><strong>#${booking.id}</strong></td>
                <td><strong>Phòng ${booking.room?.roomNumber || 'N/A'}</strong></td>
                <td>${booking.customerName || 'N/A'}</td>
                <td>${checkIn}</td>
                <td>${checkOut}</td>
                <td>${nights} đêm</td>
                <td>
                    <button class="btn" style="padding: 8px 16px; font-size: 13px; background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);" 
                            onclick="showCheckOutModal(${booking.id})">
                        <i class="fas fa-cash-register"></i> Check-out
                    </button>
                </td>
            </tr>
        `;
    }).join('');
}

// Calculate nights
function calculateNights(checkIn, checkOut) {
    if (!checkIn || !checkOut) return 0;
    const start = new Date(checkIn);
    const end = new Date(checkOut);
    const diff = end - start;
    return Math.ceil(diff / (1000 * 60 * 60 * 24));
}

// Update stats
function updateStats(booked, occupied) {
    document.getElementById('stat-booked').textContent = booked.length;
    document.getElementById('stat-occupied').textContent = occupied.length;

    // Check-out today
    const today = new Date().toDateString();
    const checkoutToday = occupied.filter(b => {
        if (!b.checkOutDate) return false;
        return new Date(b.checkOutDate).toDateString() === today;
    }).length;

    document.getElementById('stat-checkout-today').textContent = checkoutToday;
}

// Switch tabs
function switchTab(tabName) {
    // Update tab buttons
    document.querySelectorAll('.tab').forEach(tab => {
        tab.classList.remove('active');
    });
    document.querySelector(`[data-tab="${tabName}"]`).classList.add('active');

    // Update tab content
    document.querySelectorAll('.tab-content').forEach(content => {
        content.classList.remove('active');
    });
    document.getElementById(`${tabName}-tab`).classList.add('active');
}

// Show check-in modal
function showCheckInModal(bookingId) {
    const booking = [...bookedData, ...occupiedData].find(b => b.id === bookingId);
    if (!booking) return;

    selectedBooking = booking;

    const content = document.getElementById('checkin-content');
    const checkIn = booking.checkInDate ? new Date(booking.checkInDate).toLocaleString('vi-VN') : 'N/A';
    const checkOut = booking.checkOutDate ? new Date(booking.checkOutDate).toLocaleString('vi-VN') : 'N/A';
    const nights = calculateNights(booking.checkInDate, booking.checkOutDate);

    content.innerHTML = `
        <div style="background: rgba(30, 41, 59, 0.5); padding: 20px; border-radius: var(--radius-sm); margin-bottom: 20px;">
            <h3 style="margin: 0 0 16px 0; color: var(--text-primary);">
                <i class="fas fa-info-circle"></i> Thông Tin Check-in
            </h3>
            <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px;">
                <div>
                    <div style="color: var(--text-muted); font-size: 12px; margin-bottom: 4px;">Booking ID</div>
                    <div style="color: var(--text-primary); font-weight: 600;">#${booking.id}</div>
                </div>
                <div>
                    <div style="color: var(--text-muted); font-size: 12px; margin-bottom: 4px;">Số phòng</div>
                    <div style="color: var(--text-primary); font-weight: 600;">Phòng ${booking.room?.roomNumber || 'N/A'}</div>
                </div>
                <div>
                    <div style="color: var(--text-muted); font-size: 12px; margin-bottom: 4px;">Tên khách</div>
                    <div style="color: var(--text-primary); font-weight: 600;">${booking.customerName || 'N/A'}</div>
                </div>
                <div>
                    <div style="color: var(--text-muted); font-size: 12px; margin-bottom: 4px;">Số đêm</div>
                    <div style="color: var(--text-primary); font-weight: 600;">${nights} đêm</div>
                </div>
                <div>
                    <div style="color: var(--text-muted); font-size: 12px; margin-bottom: 4px;">Check-in</div>
                    <div style="color: var(--success); font-weight: 600;">${checkIn}</div>
                </div>
                <div>
                    <div style="color: var(--text-muted); font-size: 12px; margin-bottom: 4px;">Check-out dự kiến</div>
                    <div style="color: var(--warning); font-weight: 600;">${checkOut}</div>
                </div>
            </div>
        </div>

        <div style="background: rgba(59, 130, 246, 0.1); padding: 16px; border-radius: var(--radius-sm); border-left: 4px solid var(--info);">
            <p style="margin: 0; color: var(--text-primary);">
                <i class="fas fa-info-circle"></i> 
                Vui lòng xác nhận thông tin khách hàng trước khi check-in. 
                Phòng sẽ chuyển sang trạng thái OCCUPIED sau khi hoàn tất.
            </p>
        </div>
    `;

    ModalManager.open('checkin-modal');
}

// Confirm check-in
async function confirmCheckIn() {
    if (!selectedBooking) return;

    try {
        await callAPI(`/checkin/${selectedBooking.id}`, 'POST');
        showSuccess(`✅ Check-in thành công cho khách ${selectedBooking.customerName} - Phòng ${selectedBooking.room?.roomNumber}`);
        ModalManager.close('checkin-modal');
        await loadBookings();
    } catch (error) {
        showError('Lỗi: ' + error.message);
    }
}

// Show check-out modal
async function showCheckOutModal(bookingId) {
    const booking = occupiedData.find(b => b.id === bookingId);
    if (!booking) return;

    selectedBooking = booking;

    const nights = calculateNights(booking.checkInDate, booking.checkOutDate);
    const roomPrice = booking.room?.price || 500000; // Default price
    const roomTotal = nights * roomPrice;

    // Mock service charges (would come from API in real implementation)
    const services = [];
    const servicesTotal = services.reduce((sum, s) => sum + s.price, 0);

    const grandTotal = roomTotal + servicesTotal;

    const content = document.getElementById('checkout-content');
    content.innerHTML = `
        <input type="hidden" name="bookingId" value="${booking.id}">
        
        <div style="background: rgba(30, 41, 59, 0.5); padding: 20px; border-radius: var(--radius-sm); margin-bottom: 20px;">
            <h3 style="margin: 0 0 16px 0; color: var(--text-primary);">
                <i class="fas fa-user"></i> Thông Tin Khách
            </h3>
            <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px;">
                <div>
                    <span style="color: var(--text-muted); font-size: 13px;">Tên khách:</span>
                    <span style="color: var(--text-primary); font-weight: 600; margin-left: 8px;">${booking.customerName}</span>
                </div>
                <div>
                    <span style="color: var(--text-muted); font-size: 13px;">Phòng:</span>
                    <span style="color: var(--text-primary); font-weight: 600; margin-left: 8px;">${booking.room?.roomNumber}</span>
                </div>
                <div>
                    <span style="color: var(--text-muted); font-size: 13px;">Số đêm:</span>
                    <span style="color: var(--text-primary); font-weight: 600; margin-left: 8px;">${nights} đêm</span>
                </div>
            </div>
        </div>

        <div class="billing-section">
            <h3 style="margin: 0 0 16px 0; color: var(--text-primary);">
                <i class="fas fa-file-invoice-dollar"></i> Chi Tiết Hóa Đơn
            </h3>
            
            <div class="billing-row">
                <span>Tiền phòng (${nights} đêm × ${roomPrice.toLocaleString('vi-VN')} VNĐ)</span>
                <strong>${roomTotal.toLocaleString('vi-VN')} VNĐ</strong>
            </div>

            ${services.length > 0 ? `
                <div class="billing-row">
                    <span>Dịch vụ</span>
                    <strong>${servicesTotal.toLocaleString('vi-VN')} VNĐ</strong>
                </div>
                ${services.map(s => `
                    <div class="service-item">
                        <span>${s.name}</span>
                        <span>${s.price.toLocaleString('vi-VN')} VNĐ</span>
                    </div>
                `).join('')}
            ` : `
                <div class="billing-row">
                    <span style="color: var(--text-muted); font-style: italic;">Không có dịch vụ</span>
                    <span>0 VNĐ</span>
                </div>
            `}

            <div class="billing-row total">
                <span>TỔNG CỘNG</span>
                <span>${grandTotal.toLocaleString('vi-VN')} VNĐ</span>
            </div>
        </div>

        <div class="form-group">
            <label>Phương Thức Thanh Toán *</label>
            <select name="paymentMethod" required>
                <option value="CASH">Tiền mặt</option>
                <option value="CARD">Thẻ</option>
                <option value="TRANSFER">Chuyển khoản</option>
            </select>
        </div>

        <div style="background: rgba(245, 158, 11, 0.1); padding: 16px; border-radius: var(--radius-sm); border-left: 4px solid var(--warning);">
            <p style="margin: 0; color: var(--text-primary);">
                <i class="fas fa-exclamation-triangle"></i> 
                Sau khi check-out, phòng sẽ được chuyển sang trạng thái DIRTY (cần dọn dẹp).
            </p>
        </div>
    `;

    ModalManager.open('checkout-modal');
}

// Confirm check-out
async function confirmCheckOut(event) {
    event.preventDefault();

    if (!selectedBooking) return;

    const formData = new FormData(event.target);
    const paymentMethod = formData.get('paymentMethod');

    try {
        await callAPI('/checkout', 'POST', {
            bookingId: selectedBooking.id,
            paymentMethod: paymentMethod
        });

        showSuccess(`✅ Check-out thành công! Phòng ${selectedBooking.room?.roomNumber} đã chuyển sang trạng thái cần dọn dẹp.`);
        ModalManager.close('checkout-modal');
        await loadBookings();
    } catch (error) {
        showError('Lỗi: ' + error.message);
    }
}

// Setup search and filters
function setupSearch() {
    document.getElementById('search-booked').addEventListener('input', applyBookedFilters);
    document.getElementById('search-occupied').addEventListener('input', applyOccupiedFilters);
}

// Populate room filters
function populateRoomFilters(bookings) {
    const roomNumbers = [...new Set(bookings.map(b => b.room?.roomNumber).filter(r => r))].sort((a, b) => a - b);

    const bookedSelect = document.getElementById('booked-room-filter');
    const occupiedSelect = document.getElementById('occupied-room-filter');

    roomNumbers.forEach(roomNum => {
        const option1 = document.createElement('option');
        option1.value = roomNum;
        option1.textContent = `Phòng ${roomNum}`;
        bookedSelect.appendChild(option1);

        const option2 = document.createElement('option');
        option2.value = roomNum;
        option2.textContent = `Phòng ${roomNum}`;
        occupiedSelect.appendChild(option2);
    });
}

// Apply Booked filters
function applyBookedFilters() {
    const searchQuery = document.getElementById('search-booked').value.toLowerCase();
    const dateFrom = document.getElementById('booked-date-from').value;
    const dateTo = document.getElementById('booked-date-to').value;
    const roomFilter = document.getElementById('booked-room-filter').value;

    let filtered = bookedData.filter(b => {
        // Search filter
        const matchesSearch = !searchQuery ||
            b.customerName?.toLowerCase().includes(searchQuery) ||
            b.room?.roomNumber?.toString().includes(searchQuery) ||
            b.id?.toString().includes(searchQuery);

        // Date range filter (check-in date)
        const checkInDate = b.checkInDate ? new Date(b.checkInDate).toISOString().split('T')[0] : null;
        const matchesDateFrom = !dateFrom || !checkInDate || checkInDate >= dateFrom;
        const matchesDateTo = !dateTo || !checkInDate || checkInDate <= dateTo;

        // Room filter
        const matchesRoom = !roomFilter || b.room?.roomNumber?.toString() === roomFilter;

        return matchesSearch && matchesDateFrom && matchesDateTo && matchesRoom;
    });

    renderBookedTable(filtered);
}

// Apply Occupied filters
function applyOccupiedFilters() {
    const searchQuery = document.getElementById('search-occupied').value.toLowerCase();
    const dateFrom = document.getElementById('occupied-date-from').value;
    const dateTo = document.getElementById('occupied-date-to').value;
    const roomFilter = document.getElementById('occupied-room-filter').value;

    let filtered = occupiedData.filter(b => {
        // Search filter
        const matchesSearch = !searchQuery ||
            b.customerName?.toLowerCase().includes(searchQuery) ||
            b.room?.roomNumber?.toString().includes(searchQuery) ||
            b.id?.toString().includes(searchQuery);

        // Date range filter (check-out date)
        const checkOutDate = b.checkOutDate ? new Date(b.checkOutDate).toISOString().split('T')[0] : null;
        const matchesDateFrom = !dateFrom || !checkOutDate || checkOutDate >= dateFrom;
        const matchesDateTo = !dateTo || !checkOutDate || checkOutDate <= dateTo;

        // Room filter
        const matchesRoom = !roomFilter || b.room?.roomNumber?.toString() === roomFilter;

        return matchesSearch && matchesDateFrom && matchesDateTo && matchesRoom;
    });

    renderOccupiedTable(filtered);
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

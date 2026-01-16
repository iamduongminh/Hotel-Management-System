/**
 * Stay History
 * View completed and cancelled bookings
 */

let historyData = [];
let filteredData = [];

// Initialize
document.addEventListener('DOMContentLoaded', function () {
    setDefaultDateRange();
    loadHistory();
    setupSearch();
    startClock();
});

// Set default date range (last 30 days)
function setDefaultDateRange() {
    const today = new Date();
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(today.getDate() - 30);

    document.getElementById('date-from').valueAsDate = thirtyDaysAgo;
    document.getElementById('date-to').valueAsDate = today;
}

// Load history
async function loadHistory() {
    try {
        const bookings = await callAPI('/bookings', 'GET');

        // Filter completed and cancelled
        historyData = bookings.filter(b =>
            b.status === 'CHECKED_OUT' || b.status === 'CANCELLED'
        );

        filteredData = historyData;
        applyFilters();
    } catch (error) {
        console.error('Error loading history:', error);
        document.getElementById('history-tbody').innerHTML = `
            <tr><td colspan="9" style="text-align: center; color: var(--error); padding: 20px;">
                ❌ Lỗi: ${error.message}
            </td></tr>
        `;
    }
}

// Apply filters
function applyFilters() {
    const dateFrom = document.getElementById('date-from').value;
    const dateTo = document.getElementById('date-to').value;
    const statusFilter = document.getElementById('status-filter').value;
    const searchQuery = document.getElementById('search-input').value.toLowerCase();

    let filtered = historyData;

    // Date filter
    if (dateFrom) {
        const fromDate = new Date(dateFrom);
        filtered = filtered.filter(b => {
            if (!b.checkOutDate) return false;
            return new Date(b.checkOutDate) >= fromDate;
        });
    }

    if (dateTo) {
        const toDate = new Date(dateTo);
        toDate.setHours(23, 59, 59);
        filtered = filtered.filter(b => {
            if (!b.checkOutDate) return false;
            return new Date(b.checkOutDate) <= toDate;
        });
    }

    // Status filter
    if (statusFilter) {
        filtered = filtered.filter(b => b.status === statusFilter);
    }

    // Search filter
    if (searchQuery) {
        filtered = filtered.filter(b =>
            b.customerName?.toLowerCase().includes(searchQuery) ||
            b.id?.toString().includes(searchQuery) ||
            b.room?.roomNumber?.toString().includes(searchQuery)
        );
    }

    filteredData = filtered;
    renderHistoryTable(filtered);
    updateStats(historyData);
}

// Render history table
function renderHistoryTable(bookings) {
    const tbody = document.getElementById('history-tbody');

    if (!bookings || bookings.length === 0) {
        tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; padding: 20px; color: var(--text-muted);">Không tìm thấy kết quả</td></tr>';
        return;
    }

    tbody.innerHTML = bookings.map(booking => {
        const checkIn = booking.checkInDate ? new Date(booking.checkInDate).toLocaleDateString('vi-VN') : 'N/A';
        const checkOut = booking.checkOutDate ? new Date(booking.checkOutDate).toLocaleDateString('vi-VN') : 'N/A';
        const nights = calculateNights(booking.checkInDate, booking.checkOutDate);
        const total = calculateTotal(booking, nights);

        return `
            <tr>
                <td><strong>#${booking.id}</strong></td>
                <td>${booking.customerName || 'N/A'}</td>
                <td><strong>P.${booking.room?.roomNumber || 'N/A'}</strong></td>
                <td>${checkIn}</td>
                <td>${checkOut}</td>
                <td>${nights} đêm</td>
                <td><strong>${total.toLocaleString('vi-VN')} VNĐ</strong></td>
                <td><span class="status ${booking.status}">${booking.status === 'CHECKED_OUT' ? 'Hoàn thành' : 'Đã hủy'}</span></td>
                <td>
                    <a class="action-link" onclick="showBookingDetails(${booking.id})">
                        <i class="fas fa-eye"></i> Xem
                    </a>
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
    return Math.max(1, Math.ceil(diff / (1000 * 60 * 60 * 24)));
}

// Calculate total (mock calculation)
function calculateTotal(booking, nights) {
    const roomPrice = booking.room?.price || 500000;
    return nights * roomPrice;
}

// Update stats
function updateStats(bookings) {
    const checkedOut = bookings.filter(b => b.status === 'CHECKED_OUT').length;
    const cancelled = bookings.filter(b => b.status === 'CANCELLED').length;

    // Calculate total revenue
    const totalRevenue = bookings
        .filter(b => b.status === 'CHECKED_OUT')
        .reduce((sum, b) => {
            const nights = calculateNights(b.checkInDate, b.checkOutDate);
            return sum + calculateTotal(b, nights);
        }, 0);

    document.getElementById('stat-checked-out').textContent = checkedOut;
    document.getElementById('stat-cancelled').textContent = cancelled;
    document.getElementById('stat-total-revenue').textContent = (totalRevenue / 1000000).toFixed(1) + 'M';
}

// Show booking details
function showBookingDetails(bookingId) {
    const booking = historyData.find(b => b.id === bookingId);
    if (!booking) return;

    const checkIn = booking.checkInDate ? new Date(booking.checkInDate).toLocaleString('vi-VN') : 'N/A';
    const checkOut = booking.checkOutDate ? new Date(booking.checkOutDate).toLocaleString('vi-VN') : 'N/A';
    const nights = calculateNights(booking.checkInDate, booking.checkOutDate);
    const total = calculateTotal(booking, nights);

    const content = document.getElementById('booking-details-content');
    content.innerHTML = `
        <div style="background: rgba(30, 41, 59, 0.5); padding: 20px; border-radius: var(--radius-sm); margin-bottom: 20px;">
            <h3 style="margin: 0 0 16px 0; color: var(--text-primary);">
                <i class="fas fa-user"></i> Thông Tin Khách
            </h3>
            <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px;">
                <div>
                    <div style="color: var(--text-muted); font-size: 12px;">Booking ID</div>
                    <div style="color: var(--text-primary); font-weight: 600;">#${booking.id}</div>
                </div>
                <div>
                    <div style="color: var(--text-muted); font-size: 12px;">Tên khách</div>
                    <div style="color: var(--text-primary); font-weight: 600;">${booking.customerName}</div>
                </div>
                <div>
                    <div style="color: var(--text-muted); font-size: 12px;">Số phòng</div>
                    <div style="color: var(--text-primary); font-weight: 600;">Phòng ${booking.room?.roomNumber}</div>
                </div>
                <div>
                    <div style="color: var(--text-muted); font-size: 12px;">Loại phòng</div>
                    <div style="color: var(--text-primary); font-weight: 600;">${booking.room?.type || 'Standard'}</div>
                </div>
            </div>
        </div>

        <div style="background: rgba(30, 41, 59, 0.5); padding: 20px; border-radius: var(--radius-sm); margin-bottom: 20px;">
            <h3 style="margin: 0 0 16px 0; color: var(--text-primary);">
                <i class="fas fa-calendar"></i> Thời Gian Lưu Trú
            </h3>
            <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px;">
                <div>
                    <div style="color: var(--text-muted); font-size: 12px;">Check-in</div>
                    <div style="color: var(--success); font-weight: 600;">${checkIn}</div>
                </div>
                <div>
                    <div style="color: var(--text-muted); font-size: 12px;">Check-out</div>
                    <div style="color: var(--warning); font-weight: 600;">${checkOut}</div>
                </div>
                <div>
                    <div style="color: var(--text-muted); font-size: 12px;">Số đêm lưu trú</div>
                    <div style="color: var(--text-primary); font-weight: 600;">${nights} đêm</div>
                </div>
                <div>
                    <div style="color: var(--text-muted); font-size: 12px;">Trạng thái</div>
                    <div><span class="status ${booking.status}">${booking.status === 'CHECKED_OUT' ? 'Hoàn thành' : 'Đã hủy'}</span></div>
                </div>
            </div>
        </div>

        ${booking.status === 'CHECKED_OUT' ? `
            <div style="background: rgba(30, 41, 59, 0.5); padding: 20px; border-radius: var(--radius-sm);">
                <h3 style="margin: 0 0 16px 0; color: var(--text-primary);">
                    <i class="fas fa-file-invoice-dollar"></i> Thông Tin Thanh Toán
                </h3>
                <div style="padding: 16px; background: rgba(59, 130, 246, 0.1); border-radius: var(--radius-sm); margin-bottom: 12px;">
                    <div style="display: flex; justify-content: space-between; padding: 8px 0;">
                        <span style="color: var(--text-secondary);">Tiền phòng (${nights} đêm):</span>
                        <strong style="color: var(--text-primary);">${total.toLocaleString('vi-VN')} VNĐ</strong>
                    </div>
                    <div style="display: flex; justify-content: space-between; padding: 8px 0; border-top: 1px solid var(--border);">
                        <span style="color: var(--text-secondary);">Dịch vụ:</span>
                        <span style="color: var(--text-primary);">0 VNĐ</span>
                    </div>
                    <div style="display: flex; justify-content: space-between; padding: 12px 0; border-top: 2px solid var(--border); margin-top: 8px;">
                        <strong style="color: var(--primary); font-size: 18px;">TỔNG CỘNG:</strong>
                        <strong style="color: var(--primary); font-size: 20px;">${total.toLocaleString('vi-VN')} VNĐ</strong>
                    </div>
                </div>
                <div style="color: var(--text-muted); font-size: 13px;">
                    <i class="fas fa-credit-card"></i> Phương thức thanh toán: 
                    <span style="color: var(--text-primary); font-weight: 600;">Tiền mặt</span>
                </div>
            </div>
        ` : ''}
    `;

    ModalManager.open('booking-details-modal');
}

// Setup search
function setupSearch() {
    document.getElementById('search-input').addEventListener('input', applyFilters);
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

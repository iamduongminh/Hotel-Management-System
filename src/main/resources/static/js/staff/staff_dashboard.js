/**
 * Staff Dashboard SPA
 * All-in-one dashboard with modal-based interactions
 */

let bookingsData = [];

// Initialize dashboard
document.addEventListener('DOMContentLoaded', function () {
    loadUserInfo();
    loadBookings();
    startClock();
    setupSearch();
});

// Load current user info
function loadUserInfo() {
    const userStr = localStorage.getItem(CONFIG.STORAGE_USER_KEY);
    if (!userStr) {
        window.location.href = '/pages/auth/login.html';
        return;
    }

    const user = JSON.parse(userStr);
    document.getElementById('user-fullname').textContent = user.fullName || user.username;
}

// Load all bookings
async function loadBookings() {
    try {
        const bookings = await callAPI('/bookings', 'GET');
        bookingsData = bookings;
        renderBookingsTable(bookings);
        updateStats(bookings);
    } catch (error) {
        document.getElementById('bookings-tbody').innerHTML = `
            <tr><td colspan="7" style="text-align: center; color: #ef4444; padding: 20px;">
                ❌ Lỗi tải dữ liệu: ${error.message}
            </td></tr>
        `;
    }
}

// Render bookings table
function renderBookingsTable(bookings) {
    const tbody = document.getElementById('bookings-tbody');

    if (!bookings || bookings.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; padding: 20px;">Chưa có booking nào</td></tr>';
        return;
    }

    tbody.innerHTML = bookings.map(booking => {
        const checkIn = booking.checkInDate ? new Date(booking.checkInDate).toLocaleString('vi-VN') : 'N/A';
        const checkOut = booking.checkOutDate ? new Date(booking.checkOutDate).toLocaleString('vi-VN') : 'N/A';
        const status = booking.status || 'UNKNOWN';

        return `
            <tr>
                <td><strong>#${booking.id}</strong></td>
                <td>${booking.customerName || 'N/A'}</td>
                <td>Phòng ${booking.room?.roomNumber || booking.room?.id || 'N/A'}</td>
                <td>${checkIn}</td>
                <td>${checkOut}</td>
                <td><span class="status ${status}">${status}</span></td>
                <td>
                    ${status === 'BOOKED' ? `
                        <a class="action-link" onclick="checkInBooking(${booking.id})">Check-in</a>
                    ` : status === 'CHECKED_IN' ? `
                        <a class="action-link" onclick="openCheckoutModal(${booking.id})">Check-out</a>
                    ` : '-'}
                </td>
            </tr>
        `;
    }).join('');
}

// Update statistics
function updateStats(bookings) {
    const today = new Date().toDateString();

    const todayBookings = bookings.filter(b => {
        const created = b.checkInDate ? new Date(b.checkInDate).toDateString() : null;
        return created === today;
    });

    const checkedIn = bookings.filter(b => b.status === 'CHECKED_IN').length;
    const checkedOut = bookings.filter(b => b.status === 'CHECKED_OUT').length;

    document.getElementById('stat-bookings').textContent = todayBookings.length;
    document.getElementById('stat-checkins').textContent = checkedIn;
    document.getElementById('stat-checkouts').textContent = checkedOut;
    // TODO: Get available rooms from rooms API
    document.getElementById('stat-available').textContent = '?';
}

// Handle create booking
async function handleCreateBooking(event) {
    event.preventDefault();

    const formData = new FormData(event.target);
    const bookingData = {
        customerName: formData.get('customerName'),
        roomId: parseInt(formData.get('roomId')),
        checkInDate: formData.get('checkInDate'),
        checkOutDate: formData.get('checkOutDate')
    };

    try {
        await callAPI('/bookings', 'POST', bookingData);
        showSuccess('Đặt phòng thành công!');
        ModalManager.close('create-booking-modal');
        event.target.reset();
        loadBookings(); // Reload table
    } catch (error) {
        showError('Lỗi: ' + error.message);
    }
}

// Check-in a booking
async function checkInBooking(bookingId) {
    if (!confirm(`Xác nhận check-in cho booking #${bookingId}?`)) return;

    try {
        await callAPI(`/checkin/${bookingId}`, 'POST');
        showSuccess('Check-in thành công!');
        loadBookings();
    } catch (error) {
        showError('Lỗi: ' + error.message);
    }
}

// Open checkout modal with booking ID pre-filled
function openCheckoutModal(bookingId) {
    document.querySelector('#checkout-form input[name="bookingId"]').value = bookingId;
    ModalManager.open('checkout-modal');
}

// Handle checkout
async function handleCheckout(event) {
    event.preventDefault();

    const formData = new FormData(event.target);
    const checkoutData = {
        bookingId: parseInt(formData.get('bookingId')),
        paymentMethod: formData.get('paymentMethod')
    };

    try {
        await callAPI('/checkout', 'POST', checkoutData);
        showSuccess('Thanh toán thành công!');
        ModalManager.close('checkout-modal');
        event.target.reset();
        loadBookings();
    } catch (error) {
        showError('Lỗi: ' + error.message);
    }
}

// Search functionality
function setupSearch() {
    const searchInput = document.getElementById('search-input');
    searchInput.addEventListener('input', function (e) {
        const query = e.target.value.toLowerCase();
        const filtered = bookingsData.filter(booking => {
            return (
                booking.customerName?.toLowerCase().includes(query) ||
                booking.id?.toString().includes(query) ||
                booking.room?.roomNumber?.toString().includes(query)
            );
        });
        renderBookingsTable(filtered);
    });
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

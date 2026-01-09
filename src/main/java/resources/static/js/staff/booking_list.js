// File: src/main/java/resources/static/js/staff/booking.js

document.addEventListener("DOMContentLoaded", function() {
    loadBookings();
});

async function loadBookings() {
    try {
        // Gọi API lấy danh sách booking (cần Backend có API GET /bookings)
        const bookings = await callAPI('/bookings'); 
        const tableBody = document.getElementById('booking-table-body');
        
        if (!bookings || bookings.length === 0) {
            tableBody.innerHTML = '<tr><td colspan="6" style="text-align:center;">Chưa có đơn đặt phòng nào.</td></tr>';
            return;
        }

        tableBody.innerHTML = '';

        bookings.forEach(booking => {
            // Format ngày giờ hiển thị
            const checkIn = formatDateTime(booking.checkInDate);
            
            // Logic hiển thị nút Check-in: Chỉ hiện khi trạng thái là BOOKED
            let actionBtn = '';
            if (booking.status === 'BOOKED') {
                actionBtn = `
                    <button onclick="doCheckIn(${booking.id})" class="btn-primary" style="background:#28a745; padding: 5px 10px; font-size: 12px;">
                        Check-in
                    </button>
                    <button onclick="cancelBooking(${booking.id})" class="btn-primary" style="background:#dc3545; padding: 5px 10px; font-size: 12px; margin-left: 5px;">
                        Hủy
                    </button>
                `;
            } else if (booking.status === 'CHECKED_IN') {
                 // Nếu đã check-in thì hiện nút thanh toán
                 actionBtn = `
                    <a href="checkout.html?bookingId=${booking.id}" class="btn-primary" style="background:#007bff; padding: 5px 10px; font-size: 12px; text-decoration: none;">
                        Thanh toán
                    </a>
                `;
            }

            const row = `
                <tr>
                    <td>#${booking.id}</td>
                    <td>${booking.customerName}</td>
                    <td>${booking.room ? booking.room.roomNumber : 'N/A'}</td> 
                    <td>${checkIn}</td>
                    <td><span class="status ${booking.status}">${booking.status}</span></td>
                    <td>${actionBtn}</td>
                </tr>
            `;
            tableBody.innerHTML += row;
        });
    } catch (error) {
        console.error(error);
        document.getElementById('booking-table-body').innerHTML = `<tr><td colspan="6" style="color:red; text-align:center;">Lỗi tải dữ liệu: ${error.message}</td></tr>`;
    }
}

// Hàm xử lý Check-in
async function doCheckIn(bookingId) {
    if(!confirm("Xác nhận khách đã đến và nhận phòng?")) return;
    try {
        await callAPI(`/checkin/${bookingId}`, 'POST'); // Gọi CheckInController
        alert("✅ Check-in thành công!");
        loadBookings(); // Tải lại danh sách
    } catch (e) {
        alert("❌ Lỗi: " + e.message);
    }
}

// Hàm hủy phòng (Optional)
async function cancelBooking(bookingId) {
    if(!confirm("Bạn có chắc muốn hủy đơn này?")) return;
    try {
        // Cần backend hỗ trợ API hủy
        await callAPI(`/bookings/${bookingId}/cancel`, 'POST'); 
        alert("Đã hủy đơn đặt phòng.");
        loadBookings();
    } catch (e) {
        alert("Lỗi: " + e.message);
    }
}
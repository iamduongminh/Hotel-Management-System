// File: src/main/java/resources/static/js/staff/booking_form.js

document.addEventListener("DOMContentLoaded", function() {
    // Gán sự kiện submit cho form
    const form = document.getElementById('bookingForm');
    if (form) {
        form.addEventListener('submit', handleCreateBooking);
    }
});

async function handleCreateBooking(e) {
    e.preventDefault();
    
    // 1. Lấy dữ liệu từ các ô input
    const customerName = document.getElementById('customerName').value;
    const roomId = document.getElementById('roomId').value;
    const checkInDate = document.getElementById('checkInDate').value;
    const checkOutDate = document.getElementById('checkOutDate').value;

    // 2. Kiểm tra dữ liệu hợp lệ (Validation)
    if (new Date(checkInDate) >= new Date(checkOutDate)) {
        alert("⚠️ Ngày Check-out phải sau ngày Check-in!");
        return;
    }

    // 3. Chuẩn bị dữ liệu gửi đi (Khớp với BookingRequest.java)
    const requestData = {
        customerName: customerName,
        roomId: parseInt(roomId),
        checkInDate: checkInDate, 
        checkOutDate: checkOutDate
    };

    try {
        // 4. Gọi API tạo booking
        const result = await callAPI('/bookings', 'POST', requestData);
        
        alert("✅ Đặt phòng thành công! Mã đơn: #" + result.id);
        
        // 5. Quay về trang danh sách
        window.location.href = "booking-list.html"; 
    } catch (error) {
        alert("❌ Lỗi đặt phòng: " + error.message);
    }
}
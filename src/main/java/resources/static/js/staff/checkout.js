document.addEventListener("DOMContentLoaded", function() {
    // Tự động điền ID nếu có trên URL (VD: checkout.html?bookingId=1)
    const params = new URLSearchParams(window.location.search);
    const bookingIdParam = params.get('bookingId');
    if (bookingIdParam) {
        document.getElementById('bookingId').value = bookingIdParam;
    }
});

async function processCheckout() {
    const bookingId = document.getElementById('bookingId').value;
    const paymentType = document.getElementById('paymentType').value;

    if (!bookingId) {
        alert("Vui lòng nhập Mã Đặt Phòng!");
        return;
    }

    const requestData = {
        bookingId: parseInt(bookingId),
        paymentType: paymentType
    };

    try {
        // Gọi API CheckOutController
        const invoice = await callAPI('/checkout', 'POST', requestData);
        
        // Hiển thị kết quả
        let message = `✅ THANH TOÁN THÀNH CÔNG!\n\n`;
        message += `- Mã hóa đơn: #${invoice.id}\n`;
        message += `- Tổng tiền: ${new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(invoice.totalAmount)}\n`;
        message += `- Phương thức: ${invoice.paymentType}`;
        
        alert(message);
        
        // Quay lại danh sách
        window.location.href = "booking_list.html";
    } catch (error) {
        console.error(error);
        alert("❌ Lỗi thanh toán: " + error.message);
    }
}
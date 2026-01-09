// Demo dữ liệu giả vì chưa có bảng ApprovalRequest trong DB để lưu pending
// Trong thực tế, bạn sẽ gọi API GET /api/admin/approvals/pending
const mockRequests = [
    { id: 1, type: "Giảm giá", detail: "Giảm 20% cho khách VIP (Booking #1)", bookingId: 1, val: 20 },
    { id: 2, type: "Hủy phòng", detail: "Khách hủy do bão (Booking #2)", bookingId: 2, val: 0 }
];

document.addEventListener("DOMContentLoaded", function() {
    const container = document.getElementById('approval-list'); // Đảm bảo trong approvals.html có div id="approval-list"
    if (!container) return;

    mockRequests.forEach(req => {
        container.innerHTML += `
            <div class="card" style="margin-bottom:10px; border-left:4px solid #007bff;">
                <h3>${req.type}</h3>
                <p>${req.detail}</p>
                <button onclick="approve(${req.bookingId}, ${req.val})" style="background:green; color:white; padding:5px 10px; border:none;">Duyệt</button>
                <button onclick="reject(${req.bookingId})" style="background:red; color:white; padding:5px 10px; border:none;">Từ chối</button>
            </div>
        `;
    });
});

async function approve(bookingId, percent) {
    try {
        const res = await callAPI('/admin/approvals/discount', 'POST', { bookingId: bookingId, percent: percent });
        alert(res); // Hiển thị thông báo từ Backend
        location.reload();
    } catch (e) { alert("Lỗi: " + e.message); }
}

async function reject(bookingId) {
    const reason = prompt("Lý do từ chối?");
    if(reason) {
        try {
            const res = await callAPI('/admin/approvals/reject', 'POST', { bookingId: bookingId, reason: reason });
            alert(res);
            location.reload();
        } catch (e) { alert("Lỗi: " + e.message); }
    }
}
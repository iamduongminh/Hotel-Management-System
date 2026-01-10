document.addEventListener("DOMContentLoaded", function() {
    loadPendingRequests();
});

async function loadPendingRequests() {
    const container = document.getElementById('approval-list');
    if (!container) return;
    
    container.innerHTML = "<p>Đang tải danh sách yêu cầu...</p>";

    try {
        // GỌI API THẬT
        const requests = await callAPI('/admin/approvals/pending', 'GET');

        if (!requests || requests.length === 0) {
            container.innerHTML = "<p>Không có yêu cầu nào đang chờ duyệt.</p>";
            return;
        }

        container.innerHTML = '';
        requests.forEach(req => {
            // Hiển thị nội dung dựa trên loại yêu cầu
            let detailText = "";
            if (req.requestType === 'DISCOUNT') {
                detailText = `Yêu cầu giảm giá <strong>${req.requestValue}%</strong> cho Booking #${req.bookingId}`;
            } else {
                detailText = `Yêu cầu <strong>${req.requestType}</strong> cho Booking #${req.bookingId}. Lý do: ${req.requestValue}`;
            }

            const card = `
                <div class="card" style="margin-bottom:15px; border-left:4px solid #007bff; padding: 15px; background: white; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                    <div style="display:flex; justify-content:space-between;">
                        <h4 style="margin:0;">Yêu cầu #${req.id}</h4>
                        <small>${formatDateTime(req.createdAt)}</small>
                    </div>
                    <p style="margin: 10px 0;">${detailText}</p>
                    
                    <div class="actions">
                        <button onclick="approve(${req.bookingId}, ${req.id})" class="btn-primary" style="background:green; padding:5px 15px;">Duyệt</button>
                        <button onclick="reject(${req.bookingId}, ${req.id})" class="btn-primary" style="background:red; padding:5px 15px;">Từ chối</button>
                    </div>
                </div>
            `;
            container.innerHTML += card;
        });

    } catch (e) {
        container.innerHTML = `<p style="color:red">Lỗi: ${e.message}</p>`;
    }
}

async function approve(bookingId, requestId) {
    if(!confirm("Xác nhận DUYỆT yêu cầu này?")) return;
    
    // Logic: Lấy thông tin request để biết % giảm giá (đơn giản hóa cho demo)
    // Thực tế có thể gửi requestId xuống backend để xử lý
    const percent = prompt("Xác nhận lại % giảm giá (nhập số):", "10");
    if(!percent) return;

    try {
        await callAPI('/admin/approvals/discount', 'POST', { 
            bookingId: bookingId, 
            percent: parseInt(percent),
            requestId: requestId // Gửi thêm ID request để Backend update trạng thái
        });
        alert("✅ Đã duyệt thành công!");
        loadPendingRequests();
    } catch (e) { alert("Lỗi: " + e.message); }
}

async function reject(bookingId, requestId) {
    const reason = prompt("Nhập lý do từ chối:");
    if(!reason) return;

    try {
        await callAPI('/admin/approvals/reject', 'POST', { 
            bookingId: bookingId, 
            reason: reason,
            requestId: requestId
        });
        alert("🚫 Đã từ chối yêu cầu.");
        loadPendingRequests();
    } catch (e) { alert("Lỗi: " + e.message); }
}
document.addEventListener("DOMContentLoaded", function() {
    loadRooms();
});

async function loadRooms() {
    const container = document.getElementById('room-list');
    container.innerHTML = "<p>Đang tải dữ liệu phòng từ hệ thống...</p>";

    try {
        // GỌI API THẬT thay vì dùng dữ liệu giả
        const rooms = await callAPI('/housekeeping/rooms', 'GET');

        if (!rooms || rooms.length === 0) {
            container.innerHTML = "<p>Không có phòng nào trong hệ thống.</p>";
            return;
        }

        container.innerHTML = '';
        rooms.forEach(room => {
            let actionBtn = '';
            
            // Logic hiển thị nút
            if (room.status === 'DIRTY') {
                actionBtn = `<button onclick="markClean(${room.id})" class="btn-primary" style="background:green; margin-top:5px;">Dọn Xong</button>`;
            } else if (room.status === 'AVAILABLE') {
                actionBtn = `<button onclick="setMaintenance(${room.id})" class="btn-primary" style="background:orange; margin-top:5px;">Bảo Trì</button>`;
            }

            // Dịch loại phòng sang tiếng Việt nếu cần
            const typeDisplay = room.type === 'SINGLE' ? 'Đơn' : (room.type === 'DOUBLE' ? 'Đôi' : 'VIP');

            const card = `
                <div class="card" style="width: 200px; display: inline-block; margin: 10px; text-align: center; vertical-align: top; border: 1px solid #ddd; padding: 10px;">
                    <h3 style="margin: 0 0 10px 0;">P.${room.roomNumber}</h3>
                    <p><strong>Loại:</strong> ${typeDisplay}</p>
                    <p><strong>Giá:</strong> ${formatCurrency(room.price)}</p>
                    <span class="status ${room.status}">${room.status}</span>
                    <div style="margin-top:10px;">${actionBtn}</div>
                </div>
            `;
            container.innerHTML += card;
        });

    } catch (error) {
        console.error(error);
        container.innerHTML = `<p style="color:red">Lỗi tải dữ liệu: ${error.message}</p>`;
    }
}

async function markClean(roomId) {
    try {
        await callAPI(`/housekeeping/rooms/${roomId}/mark-clean`, 'POST');
        alert("✅ Đã cập nhật trạng thái: SẠCH SẼ");
        loadRooms(); 
    } catch (e) {
        alert("❌ Lỗi: " + e.message);
    }
}

async function setMaintenance(roomId) {
    try {
        await callAPI(`/housekeeping/rooms/${roomId}/maintenance`, 'POST');
        alert("⚠️ Đã chuyển phòng sang: BẢO TRÌ");
        loadRooms();
    } catch (e) {
        alert("❌ Lỗi: " + e.message);
    }
}
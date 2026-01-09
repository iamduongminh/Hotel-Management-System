document.addEventListener("DOMContentLoaded", function() {
    loadRooms();
});

async function loadRooms() {
    const container = document.getElementById('room-list');
    container.innerHTML = "Đang tải dữ liệu...";

    try {
        // Tạm thời dùng dữ liệu giả vì chưa có API GET /api/rooms đầy đủ
        // Khi nào bạn viết RoomController.findAll() thì thay bằng: await callAPI('/rooms');
        const rooms = [
            { id: 1, number: "101", status: "DIRTY", type: "SINGLE" },
            { id: 2, number: "102", status: "AVAILABLE", type: "DOUBLE" },
            { id: 3, number: "201", status: "MAINTENANCE", type: "VIP" }
        ];

        container.innerHTML = '';
        rooms.forEach(room => {
            let actionBtn = '';
            
            // Logic hiển thị nút bấm dựa trên trạng thái
            if (room.status === 'DIRTY') {
                actionBtn = `<button onclick="markClean(${room.id})" class="btn-primary" style="background:green; margin-top:5px;">Dọn Xong</button>`;
            } else if (room.status === 'AVAILABLE') {
                actionBtn = `<button onclick="setMaintenance(${room.id})" class="btn-primary" style="background:orange; margin-top:5px;">Bảo Trì</button>`;
            }

            const card = `
                <div class="card" style="width: 200px; display: inline-block; margin: 10px; text-align: center; vertical-align: top;">
                    <h3>P.${room.number}</h3>
                    <p>Loại: ${room.type}</p>
                    <span class="status ${room.status}">${room.status}</span>
                    <div>${actionBtn}</div>
                </div>
            `;
            container.innerHTML += card;
        });

    } catch (error) {
        container.innerHTML = "Không tải được danh sách phòng.";
    }
}

async function markClean(roomId) {
    try {
        // Gọi API HousekeepingController
        await callAPI(`/housekeeping/rooms/${roomId}/mark-clean`, 'POST');
        alert("Đã cập nhật: Phòng SẠCH SẼ (AVAILABLE)");
        loadRooms(); // Tải lại giao diện
    } catch (e) {
        alert("Lỗi: " + e.message);
    }
}

async function setMaintenance(roomId) {
    try {
        await callAPI(`/housekeeping/rooms/${roomId}/maintenance`, 'POST');
        alert("Đã cập nhật: Phòng đang BẢO TRÌ");
        loadRooms();
    } catch (e) {
        alert("Lỗi: " + e.message);
    }
}
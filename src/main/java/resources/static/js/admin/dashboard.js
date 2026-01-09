document.addEventListener("DOMContentLoaded", function() {
    loadDashboardStats();
});

async function loadDashboardStats() {
    try {
        // Gọi API ManagerDashboardController
        const data = await callAPI('/manager/dashboard');
        
        // Xử lý dữ liệu trả về (Hiện tại backend trả về String demo)
        if (typeof data === 'string') {
             // Mockup hiển thị khi backend chưa có số liệu thực
             console.log("Dashboard Data:", data);
             document.getElementById('daily-revenue').innerText = "15.000.000 đ (Demo)";
             document.getElementById('occupied-rooms').innerText = "8/20 Phòng"; 
        } else {
             // Khi backend trả về JSON thực tế
             document.getElementById('daily-revenue').innerText = 
                new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(data.revenue);
             document.getElementById('occupied-rooms').innerText = data.occupiedRooms;
        }

    } catch (error) {
        console.error("Lỗi tải dashboard:", error);
        document.getElementById('daily-revenue').innerText = "N/A";
    }
}
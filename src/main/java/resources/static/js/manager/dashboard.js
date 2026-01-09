document.addEventListener("DOMContentLoaded", function() {
    loadDashboardStats();
});

async function loadDashboardStats() {
    try {
        // Gọi API lấy số liệu (Giả sử ManagerDashboardController có endpoint này)
        // Bạn cần viết thêm hàm getStats() trong Controller trả về JSON
        const data = await callAPI('/manager/dashboard/stats');
        
        // Hiển thị lên giao diện
        document.getElementById('daily-revenue').innerText = 
            new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(data.revenue);
            
        document.getElementById('occupied-rooms').innerText = data.occupiedRooms + " phòng";
    } catch (error) {
        console.log("Chưa lấy được dữ liệu dashboard (có thể do chưa viết API này)");
        document.getElementById('daily-revenue').innerText = "0 đ";
        document.getElementById('occupied-rooms').innerText = "0";
    }
}
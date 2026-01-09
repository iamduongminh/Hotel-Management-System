/**
 * Hàm gọi API chung cho toàn bộ hệ thống
 * @param {string} endpoint - Đường dẫn (VD: /bookings)
 * @param {string} method - GET, POST, PUT, DELETE
 * @param {object} body - Dữ liệu gửi đi (nếu có)
 */
async function callAPI(endpoint, method = 'GET', body = null) {
    const headers = {
        'Content-Type': 'application/json'
    };

    const config = {
        method: method,
        headers: headers
    };

    if (body) {
        config.body = JSON.stringify(body);
    }

    try {
        const response = await fetch(`${CONFIG.API_BASE_URL}${endpoint}`, config);
        
        // Xử lý trường hợp 401 (Chưa đăng nhập) hoặc 403 (Không có quyền)
        if (response.status === 401) {
            alert("Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.");
            window.location.href = "/pages/auth/login.html";
            return;
        }
        if (response.status === 403) {
            window.location.href = "/pages/auth/403_error.html"; // Cần tạo file html này nếu chưa có
            return;
        }

        if (!response.ok) {
            // Cố gắng đọc lỗi từ Backend trả về
            const errText = await response.text();
            throw new Error(errText || `Lỗi API (${response.status})`);
        }

        // Kiểm tra xem Backend trả về JSON hay Text
        const contentType = response.headers.get("content-type");
        if (contentType && contentType.indexOf("application/json") !== -1) {
            return await response.json();
        } else {
            return await response.text();
        }
    } catch (error) {
        console.error("System Error:", error);
        throw error; // Ném lỗi để hàm gọi bên ngoài xử lý hiển thị
    }
}

/**
 * Format tiền tệ VNĐ (VD: 1,000,000 đ)
 */
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
}

/**
 * Format ngày giờ (VD: 20/11/2025 14:30)
 */
function formatDateTime(isoString) {
    if (!isoString) return '';
    return new Date(isoString).toLocaleString('vi-VN');
}
/**
 * CONFIGURATION & COMMON UTILS
 * File này chứa cấu hình chung và hàm gọi API cho toàn bộ hệ thống.
 */

// 1. Cấu hình đường dẫn gốc API
const API_BASE_URL = "/api";

// 2. Hàm gọi API chuẩn (Đã tối ưu hóa cho Spring Boot Session)
async function callAPI(endpoint, method = 'GET', body = null) {
    // Header mặc định là JSON
    const headers = {
        'Content-Type': 'application/json'
    };

    const config = {
        method: method,
        headers: headers,
        
        // --- QUAN TRỌNG NHẤT ---
        // credentials: 'include' bắt buộc phải có để trình duyệt gửi kèm
        // Cookie 'JSESSIONID' trong mỗi request. Nếu thiếu dòng này,
        // Backend sẽ không nhận ra user đang đăng nhập (User = null).
        credentials: 'include' 
    };

    if (body) {
        config.body = JSON.stringify(body);
    }

    try {
        const response = await fetch(`${API_BASE_URL}${endpoint}`, config);

        // --- XỬ LÝ LỖI PHÂN QUYỀN (Auth) ---
        
        // Lỗi 401: Hết phiên đăng nhập hoặc chưa đăng nhập
        if (response.status === 401) {
            alert("Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại!");
            window.location.href = "/pages/auth/login.html";
            return; // Dừng hàm tại đây
        }

        // Lỗi 403: Đã đăng nhập nhưng không có quyền (VD: Staff vào trang Admin)
        if (response.status === 403) {
            // Chuyển hướng sang trang báo lỗi 403 (bạn nên tạo file này như hướng dẫn trước)
            window.location.href = "/pages/auth/403_error.html"; 
            throw new Error("Forbidden: Bạn không có quyền truy cập!");
        }

        // --- XỬ LÝ LỖI KHÁC ---
        if (!response.ok) {
            // Cố gắng đọc nội dung lỗi chi tiết từ Backend gửi về (VD: "Phòng này đã có người")
            const errorText = await response.text();
            throw new Error(errorText || `Lỗi API: ${response.statusText} (${response.status})`);
        }

        // --- XỬ LÝ DỮ LIỆU TRẢ VỀ ---
        // Tự động phát hiện Backend trả về JSON hay Text
        const contentType = response.headers.get("content-type");
        if (contentType && contentType.indexOf("application/json") !== -1) {
            return await response.json();
        } else {
            return await response.text();
        }

    } catch (error) {
        console.error("System Error calling API:", error);
        
        // Chỉ hiển thị alert nếu đó không phải là lỗi chuyển trang (như 403 ở trên)
        if (error.message.indexOf("Forbidden") === -1) {
             // Hiển thị lỗi ra màn hình để người dùng biết
             alert("❌ Có lỗi xảy ra: " + error.message);
        }
        throw error; // Ném lỗi tiếp để hàm gọi bên ngoài (nếu cần) xử lý riêng
    }
}

// 3. Hàm tiện ích định dạng tiền tệ (VND)
function formatCurrency(amount) {
    if (amount === null || amount === undefined) return '0 đ';
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
}

// 4. Hàm tiện ích định dạng ngày giờ (cho input datetime-local hoặc hiển thị)
function formatDateTime(isoString) {
    if (!isoString) return '';
    const date = new Date(isoString);
    return date.toLocaleString('vi-VN');
}
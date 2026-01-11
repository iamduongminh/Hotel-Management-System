/**
 * CONFIGURATION & COMMON UTILS
 * File này chứa cấu hình chung và hàm gọi API cho toàn bộ hệ thống.
 */

// 1. Cấu hình đường dẫn gốc API (Đóng gói trong biến CONFIG để tránh lỗi "not defined")
const CONFIG = {
    // Dùng đường dẫn đầy đủ để tránh lỗi CORS hoặc sai path khi ở trang con
    API_BASE_URL: "http://localhost:8080/api",
    STORAGE_USER_KEY: "hotel_user"
};

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
        // SỬA: Dùng CONFIG.API_BASE_URL thay vì biến rời
        const url = `${CONFIG.API_BASE_URL}${endpoint}`;
        const response = await fetch(url, config);

        // --- XỬ LÝ LỖI PHÂN QUYỀN (Auth) ---

        // Lỗi 401: Hết phiên đăng nhập hoặc sai thông tin đăng nhập
        if (response.status === 401) {
            // Đọc lỗi từ backend trước
            const errorData = await response.json().catch(() => ({ message: null }));

            // TRƯỜNG HỢP 1: Đang gọi API login -> Sai mật khẩu
            if (endpoint.includes("/auth/login")) {
                throw new Error(errorData.message || "Sai tên đăng nhập hoặc mật khẩu!");
            }

            // TRƯỜNG HỢP 2: Đang ở trang khác (không phải login) -> Phiên hết hạn
            showWarning("Phiên đăng nhập đã hết hạn. Đang chuyển về trang đăng nhập...");
            setTimeout(() => {
                window.location.href = "/pages/auth/login.html";
            }, 1500);
            throw new Error("Session expired"); // Throw để không return undefined
        }

        // Lỗi 403: Đã đăng nhập nhưng không có quyền (VD: Staff vào trang Admin)
        if (response.status === 403) {
            showError("Bạn không có quyền thực hiện thao tác này!");
            // Nếu có trang 403 thì chuyển, không thì thôi
            // window.location.href = "/pages/auth/403_error.html"; 
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

        // Chỉ log error, không hiển thị toast ở đây
        // Để các function gọi API tự xử lý hiển thị error message
        // Tránh duplicate toast notifications

        throw error; // Ném lỗi tiếp để hàm gọi bên ngoài (nếu cần) xử lý riêng
    }
}

// 3. Hàm tiện ích định dạng tiền tệ (VND)
function formatCurrency(amount) {
    if (amount === null || amount === undefined) return '0 đ';
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
}

// 4. Hàm tiện ích định dạng ngày giờ (cho hiển thị bảng)
function formatDateTime(isoString) {
    if (!isoString) return '';
    const date = new Date(isoString);
    return date.toLocaleString('vi-VN'); // Ra dạng: "12:00:00 10/01/2026"
}
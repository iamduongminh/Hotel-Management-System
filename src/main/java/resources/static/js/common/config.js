// Đường dẫn gốc của API (Backend Spring Boot)
const API_BASE_URL = "/api";

// Hàm tiện ích để gọi API (có xử lý lỗi chung)
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
        const response = await fetch(`${API_BASE_URL}${endpoint}`, config);
        if (!response.ok) {
            throw new Error(`Lỗi API: ${response.statusText}`);
        }
        // Nếu API trả về JSON
        const contentType = response.headers.get("content-type");
        if (contentType && contentType.indexOf("application/json") !== -1) {
            return await response.json();
        }
        return await response.text(); // Trường hợp trả về String thông báo
    } catch (error) {
        console.error("Lỗi hệ thống:", error);
        alert("Có lỗi xảy ra: " + error.message);
        throw error;
    }
}
document.addEventListener("DOMContentLoaded", function () {
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', handleLogin);
    }
});

async function handleLogin(e) {
    e.preventDefault();

    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;

    // Validate input
    if (!username || !password) {
        showError("Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!");
        shakeElement('#loginForm');
        return;
    }

    const loginData = { username, password };

    try {
        // Gọi API Login
        const response = await callAPI('/auth/login', 'POST', loginData);

        // Kiểm tra response có dữ liệu không
        if (!response) {
            throw new Error("Server không trả về dữ liệu");
        }

        // Kiểm tra các trường bắt buộc
        if (!response.username || !response.fullName || !response.role) {
            console.error("Invalid response:", response);
            throw new Error("Dữ liệu đăng nhập không hợp lệ");
        }

        // Lưu thông tin user vào localStorage
        localStorage.setItem(CONFIG.STORAGE_USER_KEY, JSON.stringify(response));

        showSuccess(`Xin chào, ${response.fullName}!`);

        // Điều hướng dựa trên quyền
        // Điều hướng dựa trên quyền
        switch (response.role) {
            case 'ADMIN':
                window.location.href = "/pages/admin/dashboard.html";
                break;
            case 'REGIONAL_MANAGER':
                window.location.href = "/pages/manager/regional_dashboard.html";
                break;
            case 'BRANCH_MANAGER':
                window.location.href = "/pages/manager/branch_dashboard.html";
                break;
            case 'RECEPTIONIST':
                window.location.href = "/pages/receptionist/dashboard.html";
                break;
            case 'HOUSEKEEPER':
                window.location.href = "/pages/housekeeper/dashboard.html";
                break;
            default:
                console.warn("Unknown role:", response.role);
                window.location.href = "/pages/receptionist/dashboard.html"; // Fallback
        }

    } catch (error) {
        console.error("Login error:", error);
        showError("Đăng nhập thất bại: " + (error.message || "Lỗi không xác định"));
        shakeElement('#loginForm');
    }
}
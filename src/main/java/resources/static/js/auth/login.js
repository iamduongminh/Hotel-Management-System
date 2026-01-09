document.getElementById('loginForm').addEventListener('submit', async function(e) {
    e.preventDefault();

    const usernameStr = document.getElementById('username').value;
    const passwordStr = document.getElementById('password').value;

    // Mapping với file LoginRequest.java trong Backend
    const loginData = {
        username: usernameStr,
        password: passwordStr
    };

    try {
        // Gọi API Login (Giả sử AuthController map ở /auth/login)
        const result = await callAPI('/auth/login', 'POST', loginData);
        
        // Giả sử Backend trả về Role để điều hướng
        // VD: "ADMIN" hoặc "RECEPTIONIST"
        if (result === "ADMIN" || result.role === "ADMIN") {
            window.location.href = "/pages/admin/dashboard.html";
        } else {
            window.location.href = "/pages/staff/booking-list.html";
        }
    } catch (error) {
        alert("Đăng nhập thất bại! Kiểm tra lại thông tin.");
    }
});
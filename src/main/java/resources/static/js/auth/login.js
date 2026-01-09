document.addEventListener("DOMContentLoaded", function() {
    const loginForm = document.getElementById('loginForm');
    if(loginForm) {
        loginForm.addEventListener('submit', handleLogin);
    }
});

async function handleLogin(e) {
    e.preventDefault();
    
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;

    const loginData = { username, password };

    try {
        // Gọi API Login
        const user = await callAPI('/auth/login', 'POST', loginData);
        
        // Lưu thông tin user vào localStorage
        localStorage.setItem(CONFIG.STORAGE_USER_KEY, JSON.stringify(user));
        
        alert(`Xin chào, ${user.fullName}!`);

        // Điều hướng dựa trên quyền
        if (user.role === 'ADMIN' || user.role === 'BRANCH_MANAGER') {
            window.location.href = "/pages/admin/dashboard.html";
        } else {
            window.location.href = "/pages/staff/booking_list.html";
        }

    } catch (error) {
        alert("Đăng nhập thất bại: " + error.message);
    }
}
async function handleForgotPassword(e) {
    e.preventDefault();
    const email = document.getElementById('email').value;

    try {
        // Cần bổ sung API này ở Backend
        await callAPI('/auth/forgot-password', 'POST', { email: email });
        
        alert("Link đặt lại mật khẩu đã được gửi vào email của bạn!");
        window.location.href = "/pages/auth/login.html";
    } catch (error) {
        alert("Không thể gửi yêu cầu: " + error.message);
    }
}
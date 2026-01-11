// Thường dùng khi người dùng bấm vào link trong email: /reset-password.html?token=...
document.addEventListener("DOMContentLoaded", function () {
    const urlParams = new URLSearchParams(window.location.search);
    const token = urlParams.get('token');
    if (token) {
        document.getElementById('resetToken').value = token;
    }
});

async function handleResetPassword(e) {
    e.preventDefault();
    const token = document.getElementById('resetToken').value;
    const newPass = document.getElementById('newPassword').value;

    try {
        // Cần bổ sung API này ở Backend
        await callAPI('/auth/reset-password', 'POST', { token: token, newPassword: newPass });
        showSuccess("Đặt lại mật khẩu thành công!");
        setTimeout(() => {
            window.location.href = "/pages/auth/login.html";
        }, 1500);
    } catch (error) {
        showError("Lỗi: " + error.message);
    }
}
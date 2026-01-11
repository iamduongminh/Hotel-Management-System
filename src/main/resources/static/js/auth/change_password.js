async function handleChangePassword(e) {
    e.preventDefault();

    const currentPass = document.getElementById('currentPassword').value;
    const newPass = document.getElementById('newPassword').value;
    const confirmPass = document.getElementById('confirmPassword').value;

    if (newPass !== confirmPass) {
        showError("Mật khẩu mới không khớp!");
        shakeElement('#changePasswordForm');
        return;
    }

    try {
        const user = JSON.parse(localStorage.getItem(CONFIG.STORAGE_USER_KEY));
        if (!user) throw new Error("Bạn chưa đăng nhập!");

        // Cần bổ sung API này ở Backend: AuthController.changePassword
        await callAPI('/auth/change-password', 'POST', {
            userId: user.id,
            oldPassword: currentPass,
            newPassword: newPass
        });

        showSuccess("Đổi mật khẩu thành công! Vui lòng đăng nhập lại.");
        setTimeout(() => {
            localStorage.removeItem(CONFIG.STORAGE_USER_KEY);
            window.location.href = "/pages/auth/login.html";

        }, 1500);
    } catch (error) {
        showError("Lỗi: " + error.message);
        shakeElement('#changePasswordForm');
    }
}
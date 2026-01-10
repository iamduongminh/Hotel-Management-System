async function handleChangePassword(e) {
    e.preventDefault();
    
    const currentPass = document.getElementById('currentPassword').value;
    const newPass = document.getElementById('newPassword').value;
    const confirmPass = document.getElementById('confirmPassword').value;

    if (newPass !== confirmPass) {
        alert("Mật khẩu mới không khớp!");
        return;
    }

    try {
        const user = JSON.parse(localStorage.getItem(CONFIG.STORAGE_USER_KEY));
        if(!user) throw new Error("Bạn chưa đăng nhập!");

        // Cần bổ sung API này ở Backend: AuthController.changePassword
        await callAPI('/auth/change-password', 'POST', {
            userId: user.id,
            oldPassword: currentPass,
            newPassword: newPass
        });

        alert("Đổi mật khẩu thành công! Vui lòng đăng nhập lại.");
        localStorage.removeItem(CONFIG.STORAGE_USER_KEY);
        window.location.href = "/pages/auth/login.html";

    } catch (error) {
        alert("Lỗi: " + error.message);
    }
}
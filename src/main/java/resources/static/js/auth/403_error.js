document.addEventListener("DOMContentLoaded", function() {
    // Đếm ngược tự động quay về trang chủ
    let count = 5;
    const timerElement = document.getElementById('countdown');
    
    if(timerElement) {
        const interval = setInterval(() => {
            count--;
            timerElement.innerText = count;
            if (count <= 0) {
                clearInterval(interval);
                goBack();
            }
        }, 1000);
    }
});

function goBack() {
    // Quay lại trang trước đó hoặc về trang login
    window.history.back();
}
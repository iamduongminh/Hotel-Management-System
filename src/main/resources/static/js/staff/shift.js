async function startShift() {
    const initialCash = document.getElementById('initialCash').value;
    if (initialCash === "") {
        showWarning("Vui lòng nhập tiền đầu ca!");
        shakeElement('#startShiftForm');
        return;
    }

    try {
        // Gọi API ShiftWorkController
        const msg = await callAPI(`/shift/start?initialCash=${initialCash}`, 'POST');

        document.getElementById('shift-status').innerHTML = `<span style="color:green; font-weight:bold;">${msg}</span>`;
        showSuccess("Đã bắt đầu ca làm việc!");
    } catch (error) {
        showError("Lỗi: " + error.message);
    }
}

async function endShift() {
    const finalCash = document.getElementById('finalCash').value;
    if (finalCash === "") {
        showWarning("Vui lòng nhập tiền cuối ca!");
        shakeElement('#endShiftForm');
        return;
    }

    try {
        const msg = await callAPI(`/shift/end?finalCash=${finalCash}`, 'POST');

        document.getElementById('shift-status').innerHTML = `<span style="color:blue; font-weight:bold;">${msg}</span>`;
        showSuccess("🏁 Đã kết thúc ca làm việc!");
    } catch (error) {
        showError("Lỗi: " + error.message);
    }
}
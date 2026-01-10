async function startShift() {
    const initialCash = document.getElementById('initialCash').value;
    if (initialCash === "") {
        alert("Vui lòng nhập tiền đầu ca!");
        return;
    }

    try {
        // Gọi API ShiftWorkController
        const msg = await callAPI(`/shift/start?initialCash=${initialCash}`, 'POST');
        
        document.getElementById('shift-status').innerHTML = `<span style="color:green; font-weight:bold;">${msg}</span>`;
        alert("✅ Đã bắt đầu ca làm việc!");
    } catch (error) {
        alert("Lỗi: " + error.message);
    }
}

async function endShift() {
    const finalCash = document.getElementById('finalCash').value;
    if (finalCash === "") {
        alert("Vui lòng nhập tiền cuối ca!");
        return;
    }

    try {
        const msg = await callAPI(`/shift/end?finalCash=${finalCash}`, 'POST');
        
        document.getElementById('shift-status').innerHTML = `<span style="color:blue; font-weight:bold;">${msg}</span>`;
        alert("🏁 Đã kết thúc ca làm việc!");
    } catch (error) {
        alert("Lỗi: " + error.message);
    }
}
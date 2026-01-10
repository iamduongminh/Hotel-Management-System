async function exportReport() {
    const type = document.getElementById('reportType').value;
    const startDate = document.getElementById('startDate').value;
    const endDate = document.getElementById('endDate').value;

    if (!startDate || !endDate) {
        alert("Vui lòng chọn đầy đủ ngày bắt đầu và kết thúc!");
        return;
    }

    // Body request khớp với ReportRequest.java
    const requestBody = {
        type: type, // "REVENUE" hoặc "OCCUPANCY"
        start: new Date(startDate).toISOString(), 
        end: new Date(endDate).toISOString()
    };

    try {
        // Gọi API ReportQueryController
        const result = await callAPI('/reports/export', 'POST', requestBody);
        
        // Hiển thị kết quả
        const resultDiv = document.getElementById('reportResult');
        resultDiv.style.display = 'block';
        resultDiv.innerHTML = `
            <h3>Kết Quả Báo Cáo:</h3>
            <div style="background:#f8f9fa; padding:15px; border-radius:5px; border:1px solid #ddd;">
                ${result}
            </div>
        `;
    } catch (error) {
        alert("Lỗi xuất báo cáo: " + error.message);
    }
}
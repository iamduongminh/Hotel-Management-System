async function compareBranches() {
    const inputIds = document.getElementById('branchIds').value; // VD: "1, 2"
    
    if (!inputIds) {
        alert("Vui lòng nhập ID các chi nhánh!");
        return;
    }

    try {
        // Gọi API ComparisonController (GET)
        const result = await callAPI(`/comparison/branches?branchIds=${inputIds}`, 'GET');
        
        document.getElementById('comparisonResult').innerHTML = `
            <div style="background:#e3f2fd; padding:10px; color:#0d47a1;">
                <strong>Kết quả:</strong> ${result}
            </div>
        `;
    } catch (error) {
        alert("Lỗi so sánh: " + error.message);
    }
}
// callAPI function is now defined in config.js
// This avoids duplicates and ensures consistent error handling across the application


/**
 * Format tiền tệ VNĐ (VD: 1,000,000 đ)
 */
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
}

/**
 * Format ngày giờ (VD: 20/11/2025 14:30)
 */
function formatDateTime(isoString) {
    if (!isoString) return '';
    return new Date(isoString).toLocaleString('vi-VN');
}
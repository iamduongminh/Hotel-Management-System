// Financial Report - Daily Revenue & Services List
let dailyRevenueChart = null;

// Initialize on page load
document.addEventListener('DOMContentLoaded', function () {
    // Set default date range to last 7 days
    setQuickFilter('week');
    // Load services list
    fetchServices();
});

/**
 * Set quick filter presets
 */
function setQuickFilter(period) {
    const endDate = new Date();
    const startDate = new Date();

    switch (period) {
        case 'today':
            startDate.setDate(endDate.getDate());
            break;
        case 'week':
            startDate.setDate(endDate.getDate() - 6);
            break;
        case 'month':
            startDate.setDate(endDate.getDate() - 29);
            break;
    }

    document.getElementById('startDate').value = formatDateForInput(startDate);
    document.getElementById('endDate').value = formatDateForInput(endDate);

    applyFilters();
}

/**
 * Apply date filters and fetch data
 */
async function applyFilters() {
    const startDate = document.getElementById('startDate').value;
    const endDate = document.getElementById('endDate').value;

    if (!startDate || !endDate) {
        showToast('Vui lòng chọn khoảng thời gian', 'warning');
        return;
    }

    if (new Date(startDate) > new Date(endDate)) {
        showToast('Ngày bắt đầu phải trước ngày kết thúc', 'error');
        return;
    }

    await fetchDailyRevenue(startDate, endDate);
}

/**
 * Fetch daily revenue data
 */
async function fetchDailyRevenue(startDate, endDate) {
    try {
        const response = await fetch(
            `${CONFIG.API_BASE_URL}/manager/reports/financial/daily-revenue?start=${startDate}&end=${endDate}`,
            {
                credentials: 'include'
            }
        );

        if (!response.ok) {
            throw new Error('Lỗi khi tải dữ liệu doanh thu');
        }

        const data = await response.json();
        renderDailyRevenueChart(data);
    } catch (error) {
        console.error('Error fetching daily revenue:', error);
        showToast(error.message, 'error');
    }
}

/**
 * Fetch services list
 */
async function fetchServices() {
    try {
        const response = await fetch(
            `${CONFIG.API_BASE_URL}/manager/reports/financial/services`,
            {
                credentials: 'include'
            }
        );

        if (!response.ok) {
            throw new Error('Lỗi khi tải danh sách dịch vụ');
        }

        const data = await response.json();
        renderServicesTable(data);
    } catch (error) {
        console.error('Error fetching services:', error);
        showToast(error.message, 'error');
    }
}

/**
 * Render bar chart for daily revenue
 */
function renderDailyRevenueChart(data) {
    const ctx = document.getElementById('dailyRevenueChart').getContext('2d');

    // Update total revenue
    document.getElementById('totalRevenue').textContent = formatCurrency(data.totalRevenue);

    // Destroy existing chart
    if (dailyRevenueChart) {
        dailyRevenueChart.destroy();
    }

    // Prepare data
    const labels = data.dailyRevenues.map(item => formatDate(item.date));
    const revenues = data.dailyRevenues.map(item => parseFloat(item.revenue));

    dailyRevenueChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Doanh thu (VNĐ)',
                data: revenues,
                backgroundColor: 'rgba(75, 192, 192, 0.8)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: {
                    display: false
                },
                tooltip: {
                    callbacks: {
                        label: function (context) {
                            return `Doanh thu: ${formatCurrency(context.parsed.y)}`;
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function (value) {
                            return formatCurrencyShort(value);
                        }
                    }
                }
            }
        }
    });
}

/**
 * Render services table
 */
function renderServicesTable(data) {
    const tbody = document.getElementById('servicesTableBody');

    if (!data.services || data.services.length === 0) {
        tbody.innerHTML = '<tr><td colspan="5" style="text-align: center;">Không có dịch vụ nào</td></tr>';
        return;
    }

    tbody.innerHTML = data.services.map(service => `
        <tr>
            <td>${service.id}</td>
            <td><strong>${service.name}</strong></td>
            <td>${getServiceTypeLabel(service.type)}</td>
            <td>${service.description || '-'}</td>
            <td><strong>${formatCurrency(service.price)}</strong></td>
        </tr>
    `).join('');
}

/**
 * Helper: Get service type label in Vietnamese
 */
function getServiceTypeLabel(type) {
    const labels = {
        'FOOD_BEVERAGE': 'Ăn uống',
        'LAUNDRY': 'Giặt ủi',
        'SPA_WELLNESS': 'Spa & Chăm sóc',
        'TRANSPORTATION': 'Vé & Di chuyển',
        'ENTERTAINMENT': 'Giải trí',
        'OTHER': 'Khác'
    };
    return labels[type] || type;
}

/**
 * Helper: Format currency (full)
 */
function formatCurrency(amount) {
    if (!amount) return '0 VNĐ';
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(amount);
}

/**
 * Helper: Format currency (short for chart)
 */
function formatCurrencyShort(value) {
    if (value >= 1000000) {
        return (value / 1000000).toFixed(1) + 'M';
    } else if (value >= 1000) {
        return (value / 1000).toFixed(0) + 'K';
    }
    return value.toString();
}

/**
 * Helper: Format date for display (DD/MM/YYYY)
 */
function formatDate(dateStr) {
    const date = new Date(dateStr);
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0');
    return `${day}/${month}`;
}

/**
 * Helper: Format date for input (YYYY-MM-DD)
 */
function formatDateForInput(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

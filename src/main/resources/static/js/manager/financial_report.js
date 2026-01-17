// Financial Report - Daily Revenue & Services List
let dailyRevenueChart = null;

// Initialize on page load
document.addEventListener('DOMContentLoaded', function () {
    // Set default date range to last 7 days
    // Set default date range to last 7 days (this triggers applyFilters -> fetchServices)
    setQuickFilter('week');
    // Initialize resizable panels
    initializeResizer();
});

/**
 * Set quick filter presets
 */
function setQuickFilter(period) {
    const endDate = new Date();
    const startDate = new Date();

    // Update active button state
    document.querySelectorAll('.btn-pill').forEach(btn => btn.classList.remove('active'));
    if (period === 'today') document.getElementById('btnToday')?.classList.add('active');
    if (period === 'week') document.getElementById('btnWeek')?.classList.add('active');
    if (period === 'month') document.getElementById('btnMonth')?.classList.add('active');

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

    await Promise.all([
        fetchDailyRevenue(startDate, endDate),
        fetchServices(startDate, endDate)
    ]);
}

/**
 * Fetch daily revenue data
 */
/**
 * Fetch daily revenue data
 */
async function fetchDailyRevenue(startDate, endDate) {
    try {
        // Use callAPI to handle 401/Auth errors automatically
        const data = await callAPI(`/manager/reports/financial/daily-revenue?start=${startDate}&end=${endDate}`);
        renderDailyRevenueChart(data);
    } catch (error) {
        console.error('Error fetching daily revenue:', error);
        showToast(error.message, 'error');
    }
}

/**
 * Fetch services list
 */
/**
 * Fetch services list
 */
async function fetchServices(startDate, endDate) {
    try {
        // Use callAPI to handle 401/Auth errors automatically
        // If dates are null, backend defaults to last 30 days, but we should pass them if available
        let url = '/manager/reports/financial/services';
        if (startDate && endDate) {
            url += `?start=${startDate}&end=${endDate}`;
        }
        const data = await callAPI(url);
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
            maintainAspectRatio: false, // Allow chart to fill container
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
        tbody.innerHTML = '<tr><td colspan="3" style="text-align: center; color: var(--text-muted);">Không có dịch vụ nào</td></tr>';
        return;
    }

    tbody.innerHTML = data.services.map((service, index) => `
        <tr>
            <td>
                <div style="display: flex; align-items: center; gap: 10px;">
                    <span style="background: rgba(255,255,255,0.1); width: 24px; height: 24px; display: flex; align-items: center; justify-content: center; border-radius: 50%; font-size: 12px; color: var(--text-muted);">${index + 1}</span>
                    <strong>${service.name}</strong>
                </div>
            </td>
            <td>${getServiceTypeLabel(service.type)}</td>
            <td style="text-align: center;">
                <span style="background: rgba(59, 130, 246, 0.2); color: #60a5fa; padding: 2px 8px; border-radius: 4px; font-weight: bold;">
                    ${service.usageCount || 0}
                </span>
            </td>
            <td><strong>${formatCurrency(service.totalRevenue || 0)}</strong></td>
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

/**
 * Initialize resizable panels
 */
function initializeResizer() {
    const resizer = document.getElementById('resizer');
    const leftPanel = document.getElementById('leftPanel');
    const rightPanel = document.getElementById('rightPanel');
    const container = resizer.parentElement;

    let isResizing = false;
    let startX = 0;
    let startLeftWidth = 0;

    resizer.addEventListener('mousedown', function (e) {
        isResizing = true;
        startX = e.clientX;
        startLeftWidth = leftPanel.offsetWidth;
        resizer.classList.add('resizing');
        document.body.style.cursor = 'col-resize';
        document.body.style.userSelect = 'none';
        e.preventDefault();
    });

    document.addEventListener('mousemove', function (e) {
        if (!isResizing) return;

        const deltaX = e.clientX - startX;
        const containerWidth = container.offsetWidth;
        const newLeftWidth = startLeftWidth + deltaX;
        const minWidth = 300;
        const maxWidth = containerWidth - minWidth - 8; // 8px for resizer

        if (newLeftWidth >= minWidth && newLeftWidth <= maxWidth) {
            const leftPercentage = (newLeftWidth / containerWidth) * 100;
            leftPanel.style.flex = `0 0 ${leftPercentage}%`;

            // Trigger chart resize
            if (dailyRevenueChart) dailyRevenueChart.resize();
        }
    });

    document.addEventListener('mouseup', function () {
        if (isResizing) {
            isResizing = false;
            resizer.classList.remove('resizing');
            document.body.style.cursor = '';
            document.body.style.userSelect = '';
        }
    });
}

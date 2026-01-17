// Operational Report - Room Distribution & Daily Guest Count
let roomDistributionChart = null;
let dailyGuestChart = null;

// Initialize on page load
document.addEventListener('DOMContentLoaded', function () {
    // Set default date range to last 7 days
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
        fetchRoomDistribution(startDate, endDate),
        fetchDailyGuestCount(startDate, endDate)
    ]);
}

/**
 * Fetch room type distribution data
 */
/**
 * Fetch room type distribution data
 */
async function fetchRoomDistribution(startDate, endDate) {
    try {
        // Use callAPI to handle 401/Auth errors automatically
        const data = await callAPI(`/manager/reports/operational/room-distribution?start=${startDate}&end=${endDate}`);
        renderRoomDistributionChart(data);
    } catch (error) {
        console.error('Error fetching room distribution:', error);
        showToast(error.message, 'error');
    }
}

/**
 * Fetch daily guest count data
 */
/**
 * Fetch daily guest count data
 */
async function fetchDailyGuestCount(startDate, endDate) {
    try {
        // Use callAPI to handle 401/Auth errors automatically
        const data = await callAPI(`/manager/reports/operational/daily-guests?start=${startDate}&end=${endDate}`);
        renderDailyGuestChart(data);
    } catch (error) {
        console.error('Error fetching daily guests:', error);
        showToast(error.message, 'error');
    }
}

/**
 * Render pie chart for room type distribution
 */
function renderRoomDistributionChart(data) {
    const ctx = document.getElementById('roomDistributionChart').getContext('2d');

    // Update total guests
    document.getElementById('totalGuests').textContent = data.totalGuests || 0;

    // Destroy existing chart
    if (roomDistributionChart) {
        roomDistributionChart.destroy();
    }

    // Prepare data
    const labels = data.distribution.map(item => getRoomTypeLabel(item.roomType));
    const counts = data.distribution.map(item => item.count);
    const percentages = data.distribution.map(item => item.percentage);

    // Chart colors
    const colors = [
        'rgba(54, 162, 235, 0.8)',   // STANDARD - Blue
        'rgba(255, 206, 86, 0.8)',   // DELUXE - Yellow
        'rgba(153, 102, 255, 0.8)',  // SUITE - Purple
    ];

    roomDistributionChart = new Chart(ctx, {
        type: 'pie',
        data: {
            labels: labels,
            datasets: [{
                data: counts,
                backgroundColor: colors,
                borderColor: colors.map(c => c.replace('0.8', '1')),
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false, // Allow chart to fill container height
            plugins: {
                legend: {
                    position: 'bottom', // Move legend to bottom to avoid cutting off
                    labels: {
                        font: {
                            size: 12
                        },
                        padding: 20,
                        usePointStyle: true
                    }
                },
                tooltip: {
                    callbacks: {
                        label: function (context) {
                            const label = context.label || '';
                            const value = context.parsed || 0;
                            const percentage = percentages[context.dataIndex] || 0;
                            return `${label}: ${value} khách (${percentage.toFixed(1)}%)`;
                        }
                    }
                }
            }
        }
    });
}

/**
 * Render bar chart for daily guest count
 */
function renderDailyGuestChart(data) {
    const ctx = document.getElementById('dailyGuestChart').getContext('2d');

    // Destroy existing chart
    if (dailyGuestChart) {
        dailyGuestChart.destroy();
    }

    // Prepare data
    const labels = data.dailyCounts.map(item => formatDate(item.date));
    const counts = data.dailyCounts.map(item => item.count);

    dailyGuestChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Số lượng khách',
                data: counts,
                backgroundColor: 'rgba(75, 192, 192, 0.8)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false, // Allow chart to fill container height
            plugins: {
                legend: {
                    display: false
                },
                tooltip: {
                    callbacks: {
                        label: function (context) {
                            return `Số khách: ${context.parsed.y}`;
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1
                    }
                }
            }
        }
    });
}

/**
 * Helper: Get room type label in Vietnamese
 */
function getRoomTypeLabel(roomType) {
    const labels = {
        'STANDARD': 'Phòng Tiêu Chuẩn',
        'DELUXE': 'Phòng Cao Cấp',
        'SUITE': 'Phòng Suite'
    };
    return labels[roomType] || roomType;
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
            if (roomDistributionChart) roomDistributionChart.resize();
            if (dailyGuestChart) dailyGuestChart.resize();
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

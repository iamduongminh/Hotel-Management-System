// Operational Report - Room Distribution & Daily Guest Count
let roomDistributionChart = null;
let dailyGuestChart = null;

// Initialize on page load
document.addEventListener('DOMContentLoaded', function () {
    // Set default date range to last 7 days
    setQuickFilter('week');
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

    await Promise.all([
        fetchRoomDistribution(startDate, endDate),
        fetchDailyGuestCount(startDate, endDate)
    ]);
}

/**
 * Fetch room type distribution data
 */
async function fetchRoomDistribution(startDate, endDate) {
    try {
        const response = await fetch(
            `${CONFIG.API_BASE_URL}/manager/reports/operational/room-distribution?start=${startDate}&end=${endDate}`,
            {
                credentials: 'include'
            }
        );

        if (!response.ok) {
            throw new Error('Lỗi khi tải dữ liệu phân bổ phòng');
        }

        const data = await response.json();
        renderRoomDistributionChart(data);
    } catch (error) {
        console.error('Error fetching room distribution:', error);
        showToast(error.message, 'error');
    }
}

/**
 * Fetch daily guest count data
 */
async function fetchDailyGuestCount(startDate, endDate) {
    try {
        const response = await fetch(
            `${CONFIG.API_BASE_URL}/manager/reports/operational/daily-guests?start=${startDate}&end=${endDate}`,
            {
                credentials: 'include'
            }
        );

        if (!response.ok) {
            throw new Error('Lỗi khi tải dữ liệu khách theo ngày');
        }

        const data = await response.json();
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
            maintainAspectRatio: true,
            plugins: {
                legend: {
                    position: 'right',
                    labels: {
                        font: {
                            size: 14
                        }
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
            maintainAspectRatio: true,
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

/**
 * Service Requests Management
 * Track and manage guest service requests
 */

let requestsData = [];
let autoRefreshInterval = null;

// Initialize
document.addEventListener('DOMContentLoaded', function () {
    loadRequests();
    setupSearch();
    startAutoRefresh();
});

// Load service requests (mock data for now)
async function loadRequests() {
    try {
        // Mock service requests data
        // In production, would call: await callAPI('/service-requests', 'GET');
        requestsData = generateMockRequests();

        renderRequestsTable(requestsData);
        updateStats(requestsData);
        updateLastRefreshTime();
    } catch (error) {
        console.error('Error loading requests:', error);
        document.getElementById('requests-tbody').innerHTML = `
            <tr><td colspan="7" style="text-align: center; color: var(--error); padding: 20px;">
                ❌ Lỗi: ${error.message}
            </td></tr>
        `;
    }
}

// Generate mock requests for demonstration
function generateMockRequests() {
    const types = ['F&B', 'Housekeeping', 'Laundry', 'Maintenance', 'Other'];
    const statuses = ['PENDING', 'PROCESSING', 'COMPLETED'];
    const names = ['Nguyễn Văn A', 'Trần Thị B', 'Lê Văn C', 'Phạm Thị D'];
    const contents = [
        'Yêu cầu dọn phòng',
        'Gọi 2 ly cà phê và bánh mì',
        'Giặt quần áo',
        'Sửa điều hòa không mát',
        'Thêm khăn tắm'
    ];

    const requests = [];
    for (let i = 0; i < 10; i++) {
        const date = new Date();
        date.setHours(date.getHours() - Math.floor(Math.random() * 24));

        requests.push({
            id: i + 1,
            roomNumber: 100 + Math.floor(Math.random() * 50),
            guestName: names[Math.floor(Math.random() * names.length)],
            serviceType: types[Math.floor(Math.random() * types.length)],
            content: contents[Math.floor(Math.random() * contents.length)],
            status: statuses[Math.floor(Math.random() * statuses.length)],
            createdAt: date.toISOString()
        });
    }

    // Sort by created date descending
    return requests.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
}

// Render requests table
function renderRequestsTable(requests) {
    const tbody = document.getElementById('requests-tbody');

    if (!requests || requests.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; padding: 20px; color: var(--text-muted);">Không có yêu cầu nào</td></tr>';
        return;
    }

    tbody.innerHTML = requests.map(req => {
        const time = new Date(req.createdAt).toLocaleString('vi-VN', { dateStyle: 'short', timeStyle: 'short' });
        const statusClass = req.status.toLowerCase();
        const statusText = getStatusText(req.status);
        const isPending = req.status === 'PENDING';

        return `
            <tr ${isPending ? 'style="background: rgba(245, 158, 11, 0.05);"' : ''}>
                <td>${time}</td>
                <td><strong>P.${req.roomNumber}</strong></td>
                <td>${req.guestName}</td>
                <td>
                    <span style="display: inline-block; padding: 4px 8px; background: rgba(59, 130, 246, 0.1); border-radius: 4px; font-size: 12px;">
                        ${req.serviceType}
                    </span>
                </td>
                <td>${req.content}</td>
                <td><span class="status ${statusClass}">${statusText}</span></td>
                <td>
                    ${req.status !== 'COMPLETED' && req.status !== 'CANCELLED' ? `
                        <select onchange="updateRequestStatus(${req.id}, this.value)" class="search-box" style="width: 140px; padding: 6px 8px; font-size: 12px;">
                            <option value="">-- Cập nhật --</option>
                            ${req.status !== 'PROCESSING' ? '<option value="PROCESSING">Đang xử lý</option>' : ''}
                            ${req.status !== 'COMPLETED' ? '<option value="COMPLETED">Hoàn thành</option>' : ''}
                            <option value="CANCELLED">Hủy yêu cầu</option>
                        </select>
                    ` : `
                        <span style="color: var(--text-muted); font-size: 13px;">--</span>
                    `}
                </td>
            </tr>
        `;
    }).join('');
}

// Get status text
function getStatusText(status) {
    const map = {
        'PENDING': '⏳ Chờ xử lý',
        'PROCESSING': '⚙️ Đang xử lý',
        'COMPLETED': '✅ Hoàn thành',
        'CANCELLED': '❌ Đã hủy'
    };
    return map[status] || status;
}

// Update stats
function updateStats(requests) {
    const stats = {
        pending: requests.filter(r => r.status === 'PENDING').length,
        processing: requests.filter(r => r.status === 'PROCESSING').length,
        completed: requests.filter(r => r.status === 'COMPLETED').length
    };

    document.getElementById('stat-pending').textContent = stats.pending;
    document.getElementById('stat-processing').textContent = stats.processing;
    document.getElementById('stat-completed').textContent = stats.completed;
}

// Update request status
async function updateRequestStatus(requestId, newStatus) {
    if (!newStatus) return;

    const request = requestsData.find(r => r.id === requestId);
    if (!request) return;

    try {
        // In production: await callAPI(`/service-requests/${requestId}/status`, 'PUT', { status: newStatus });

        // Mock update
        request.status = newStatus;

        showSuccess(`Đã cập nhật trạng thái yêu cầu thành "${getStatusText(newStatus)}"`);
        renderRequestsTable(requestsData);
        updateStats(requestsData);
    } catch (error) {
        showError('Lỗi: ' + error.message);
    }
}

// Handle create request
async function handleCreateRequest(event) {
    event.preventDefault();

    const formData = new FormData(event.target);
    const requestData = {
        roomNumber: parseInt(formData.get('roomNumber')),
        serviceType: formData.get('serviceType'),
        content: formData.get('content'),
        status: 'PENDING',
        createdAt: new Date().toISOString(),
        guestName: 'Khách hàng' // Would get from room/booking in production
    };

    try {
        // In production: await callAPI('/service-requests', 'POST', requestData);

        // Mock create
        requestData.id = requestsData.length + 1;
        requestsData.unshift(requestData);

        showSuccess('✅ Đã tạo yêu cầu dịch vụ thành công!');
        ModalManager.close('create-request-modal');
        event.target.reset();

        renderRequestsTable(requestsData);
        updateStats(requestsData);
    } catch (error) {
        showError('Lỗi: ' + error.message);
    }
}

// Apply filter
function applyFilter() {
    const statusFilter = document.getElementById('status-filter').value;
    const searchQuery = document.getElementById('search-input').value.toLowerCase();

    let filtered = requestsData;

    if (statusFilter) {
        filtered = filtered.filter(r => r.status === statusFilter);
    }

    if (searchQuery) {
        filtered = filtered.filter(r =>
            r.roomNumber.toString().includes(searchQuery) ||
            r.guestName.toLowerCase().includes(searchQuery) ||
            r.serviceType.toLowerCase().includes(searchQuery) ||
            r.content.toLowerCase().includes(searchQuery)
        );
    }

    renderRequestsTable(filtered);
}

// Setup search
function setupSearch() {
    document.getElementById('search-input').addEventListener('input', applyFilter);
}

// Auto refresh
function startAutoRefresh() {
    autoRefreshInterval = setInterval(() => {
        loadRequests();
    }, 30000); // Refresh every 30 seconds
}

// Update last refresh time
function updateLastRefreshTime() {
    const now = new Date();
    document.getElementById('last-update').textContent = now.toLocaleTimeString('vi-VN');
}

// Cleanup on page unload
window.addEventListener('beforeunload', () => {
    if (autoRefreshInterval) {
        clearInterval(autoRefreshInterval);
    }
});

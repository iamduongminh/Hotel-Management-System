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
        const statusClass = req.status;
        const statusText = getStatusText(req.status);
        const isPending = req.status === 'PENDING';

        const serviceTypeClass = getServiceTypeClass(req.serviceType);

        return `
            <tr ${isPending ? 'style="background: rgba(245, 158, 11, 0.05);"' : ''}>
                <td style="white-space: nowrap;">${time}</td>
                <td><strong>P.${req.roomNumber}</strong></td>
                <td>${req.guestName}</td>
                <td style="text-align: center;">
                    <span class="badge ${serviceTypeClass}">
                        ${req.serviceType}
                    </span>
                </td>
                <td>${req.content}</td>
                <td style="text-align: center;"><span class="status ${statusClass}">${statusText}</span></td>
                <td style="text-align: center;">
                    <div class="action-menu-container">
                        <button class="action-menu-btn" onclick="toggleActionMenu(event, ${req.id})">
                            ⋮
                        </button>
                        <div class="action-dropdown" id="dropdown-${req.id}">
                            <button class="action-dropdown-item" onclick="openUpdateStatusModal(${req.id})">
                                ✏️ Cập nhật
                            </button>
                            ${req.status !== 'CANCELLED' ? `
                            <button class="action-dropdown-item danger" onclick="updateRequestStatus(${req.id}, 'CANCELLED')">
                                ❌ Hủy yêu cầu
                            </button>` : ''}
                        </div>
                    </div>
                </td>
            </tr>
        `;
    }).join('');
}

// Get Service Type Class
function getServiceTypeClass(type) {
    if (!type) return 'type-other';
    const lower = type.toLowerCase();
    if (lower.includes('f&b') || lower.includes('food')) return 'type-fnb';
    if (lower.includes('housekeeping') || lower.includes('clean')) return 'type-housekeeping';
    if (lower.includes('laundry')) return 'type-laundry';
    if (lower.includes('maintenance') || lower.includes('repair')) return 'type-maintenance';
    return 'type-other';
}

// Get status text
function getStatusText(status) {
    const map = {
        'PENDING': 'Chờ xử lý',
        'PROCESSING': 'Đang xử lý',
        'COMPLETED': 'Hoàn thành',
        'CANCELLED': 'Đã hủy'
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

// Toggle action dropdown menu
let currentOpenDropdown = null;
function toggleActionMenu(event, reqId) {
    event.stopPropagation();
    const dropdown = document.getElementById(`dropdown-${reqId}`);

    // Close current dropdown if exists
    if (currentOpenDropdown && currentOpenDropdown !== dropdown) {
        currentOpenDropdown.classList.remove('show');
    }

    // Toggle the clicked dropdown
    dropdown.classList.toggle('show');
    currentOpenDropdown = dropdown.classList.contains('show') ? dropdown : null;
}

// Close dropdown when clicking outside
document.addEventListener('click', (e) => {
    if (currentOpenDropdown && !e.target.closest('.action-menu-container')) {
        currentOpenDropdown.classList.remove('show');
        currentOpenDropdown = null;
    }
});

// Open Update Status Modal
function openUpdateStatusModal(reqId) {
    const request = requestsData.find(r => r.id === reqId);
    if (!request) return;

    document.getElementById('update-request-id').value = reqId;
    document.getElementById('update-request-status').value = request.status;
    ModalManager.open('update-status-modal');
}

// Submit Update Status
function submitUpdateStatus() {
    const reqId = parseInt(document.getElementById('update-request-id').value);
    const newStatus = document.getElementById('update-request-status').value;

    if (reqId && newStatus) {
        updateRequestStatus(reqId, newStatus);
        ModalManager.close('update-status-modal');
    }
}

// Update request status (Backend logic)
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

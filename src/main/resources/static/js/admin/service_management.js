/**
 * Service Management - Admin Dashboard
 * Create, view, edit, and delete hotel services
 */

// Global variables
let allServices = [];
let currentOpenDropdown = null;
let serviceToDelete = null;

// Load services when page loads
document.addEventListener('DOMContentLoaded', () => {
    loadCurrentUser();
    updatePriceDisplay(); // Init slider
    loadServices();

    // Close dropdown when clicking outside
    document.addEventListener('click', (e) => {
        if (currentOpenDropdown && !e.target.closest('.action-menu-container')) {
            currentOpenDropdown.classList.remove('show');
            currentOpenDropdown = null;
        }
    });
});

/**
 * Load current user and update page title (optional, good for consistency)
 */
async function loadCurrentUser() {
    try {
        await callAPI('/users/current', 'GET');
    } catch (error) {
        console.error('Error loading current user:', error);
    }
}

/**
 * Update price display values and slider track
 */
function updatePriceDisplay() {
    const minInput = document.getElementById('filter-min-price');
    const maxInput = document.getElementById('filter-max-price');
    const minDisplay = document.getElementById('price-min-display');
    const maxDisplay = document.getElementById('price-max-display');
    const track = document.querySelector('.slider-track');

    let minVal = parseInt(minInput.value);
    let maxVal = parseInt(maxInput.value);

    // Prevent cross-over
    if (minVal > maxVal) {
        let temp = minVal;
        minVal = maxVal;
        maxVal = temp;
    }

    // Format for display
    minDisplay.textContent = formatCurrency(minVal);
    maxDisplay.textContent = formatCurrency(maxVal);

    // Update track color fill
    const minPercent = (minVal / minInput.max) * 100;
    const maxPercent = (maxVal / maxInput.max) * 100;

    track.style.background = `linear-gradient(to right, var(--border) ${minPercent}%, var(--primary) ${minPercent}%, var(--primary) ${maxPercent}%, var(--border) ${maxPercent}%)`;
}

/**
 * Load all services from API
 */
async function loadServices() {
    try {
        const services = await callAPI('/api/services', 'GET');
        allServices = services;
        displayServices(services);

        // Update slider max value if needed based on data? 
        // For now keep static 5M as per design

    } catch (error) {
        console.error('Error loading services:', error);
        showError('Không thể tải danh sách dịch vụ: ' + error.message);
    }
}

/**
 * Filter services via Backend API
 */
async function filterServices() {
    const searchTerm = document.getElementById('search-input').value;
    const type = document.getElementById('filter-type').value;

    const minInput = document.getElementById('filter-min-price');
    const maxInput = document.getElementById('filter-max-price');
    let minVal = parseInt(minInput.value);
    let maxVal = parseInt(maxInput.value);
    if (minVal > maxVal) [minVal, maxVal] = [maxVal, minVal];

    // Build params
    const params = new URLSearchParams();
    if (searchTerm) params.append('name', searchTerm);
    if (type) params.append('type', type);
    params.append('minPrice', minVal);
    params.append('maxPrice', maxVal);

    try {
        const queryString = params.toString();
        const services = await callAPI(`/api/services/filter?${queryString}`, 'GET');
        displayServices(services);
    } catch (error) {
        console.error('Error filtering services:', error);
        // Fallback to client side if API fails? No, show error.
        showError('Lỗi lọc dữ liệu: ' + error.message);
    }
}

/**
 * Display services in table
 */
function displayServices(services) {
    const tbody = document.getElementById('services-tbody');
    const countBadge = document.getElementById('service-count');

    if (countBadge) countBadge.textContent = `${services.length} dịch vụ`;

    if (!services || services.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" style="text-align: center;">Không tìm thấy dịch vụ nào</td></tr>';
        return;
    }

    tbody.innerHTML = services.map(service => `
        <tr>
            <td>${service.id}</td>
            <td><strong>${escapeHtml(service.name)}</strong></td>
            <td>${getServiceTypeLabel(service.type)}</td>
            <td>${service.description ? escapeHtml(service.description) : '-'}</td>
            <td>${formatCurrency(service.price)}</td>
            <td>
                <span class="status-badge ${service.active ? 'status-active' : 'status-inactive'}">
                    ${service.active ? 'Hoạt động' : 'Tạm ngưng'}
                </span>
            </td>
            <td>
                <div class="action-buttons">
                    <button class="btn-primary btn-sm" onclick="editService(${service.id})" title="Sửa">
                        ✏️
                    </button>
                    <button class="btn-secondary btn-sm" onclick="toggleServiceStatus(${service.id})" title="Đổi trạng thái">
                        🔄
                    </button>
                    <button class="btn-danger btn-sm" onclick="deleteService(${service.id}, '${escapeHtml(service.name)}')" title="Xóa">
                        🗑️
                    </button>
                </div>
            </td>
        </tr>
    `).join('');
}

/**
 * Get display label for Service Type
 */
function getServiceTypeLabel(type) {
    const map = {
        'FOOD_BEVERAGE': '<span class="badge" style="background:#e0f2fe; color:#0369a1">Ẩm thực</span>',
        'LAUNDRY': '<span class="badge" style="background:#f3e8ff; color:#7e22ce">Giặt ủi</span>',
        'SPA_WELLNESS': '<span class="badge" style="background:#fce7f3; color:#db2777">Spa & Sức khỏe</span>',
        'TRANSPORTATION': '<span class="badge" style="background:#ffedd5; color:#c2410c">Di chuyển</span>',
        'ENTERTAINMENT': '<span class="badge" style="background:#dcfce7; color:#15803d">Giải trí</span>',
        'OTHER': '<span class="badge" style="background:#f1f5f9; color:#475569">Khác</span>'
    };
    return map[type] || '<span class="badge">Khác</span>';
}

/**
 * Handle create service form submission
 */
async function handleCreateService(event) {
    event.preventDefault();

    const formData = new FormData(event.target);

    const serviceData = {
        name: formData.get('name'),
        type: formData.get('type'),
        description: formData.get('description'),
        price: parseFloat(formData.get('price')),
        active: formData.get('active') === 'on'
    };

    try {
        const response = await callAPI('/api/services', 'POST', serviceData);

        showSuccess(response.message || 'Tạo dịch vụ thành công!');

        // Close modal and reload services
        ModalManager.close('create-service-modal');
        event.target.reset();
        loadServices();

    } catch (error) {
        console.error('Error creating service:', error);
        showError(error.message || 'Không thể tạo dịch vụ!');
    }
}

/**
 * Edit service - open modal with pre-filled data
 */
async function editService(serviceId) {
    // Find service from current list (allServices might be filtered, but we need full object)
    // Actually allServices is not guaranteed to have all if we refreshed via filter.
    // Better fetch by ID or ensure we have it.
    // Since displayServices receives 'services', we can try to find in 'allServices' if we kept duplicate,
    // Or just fetch detail to be safe.

    try {
        const service = await callAPI(`/api/services/${serviceId}`, 'GET');

        // Fill form with service data
        document.getElementById('edit-service-id').value = service.id;
        document.getElementById('edit-service-name').value = service.name;
        document.getElementById('edit-service-type').value = service.type || 'OTHER';
        document.getElementById('edit-service-description').value = service.description || '';
        document.getElementById('edit-service-price').value = service.price;
        document.getElementById('edit-service-active').checked = service.active;

        // Open modal
        ModalManager.open('edit-service-modal');
    } catch (error) {
        showError('Không thể tải thông tin dịch vụ: ' + error.message);
    }
}

/**
 * Handle edit service form submission
 */
async function handleEditService(event) {
    event.preventDefault();

    const formData = new FormData(event.target);
    const serviceId = formData.get('id');

    const serviceData = {
        name: formData.get('name'),
        type: formData.get('type'),
        description: formData.get('description'),
        price: parseFloat(formData.get('price')),
        active: formData.get('active') === 'on'
    };

    try {
        const response = await callAPI(`/api/services/${serviceId}`, 'PUT', serviceData);

        showSuccess(response.message || 'Cập nhật dịch vụ thành công!');

        // Close modal and reload services
        ModalManager.close('edit-service-modal');
        event.target.reset();
        // Reload current filter state or reset? 
        // Let's call filterServices to maintain state
        filterServices();

    } catch (error) {
        console.error('Error updating service:', error);
        showError(error.message || 'Không thể cập nhật dịch vụ!');
    }
}

/**
 * Delete service - show confirm modal
 */
function deleteService(serviceId, serviceName) {
    serviceToDelete = { id: serviceId, name: serviceName };
    document.getElementById('delete-service-name').textContent = serviceName;

    const confirmBtn = document.getElementById('confirm-delete-btn');
    confirmBtn.onclick = confirmDeleteService; // re-bind specifically

    ModalManager.open('confirm-delete-modal');
}

/**
 * Confirm and execute delete
 */
async function confirmDeleteService() {
    if (!serviceToDelete) return;

    try {
        await callAPI(`/api/services/${serviceToDelete.id}`, 'DELETE');
        showSuccess('Xóa dịch vụ thành công!');
        ModalManager.close('confirm-delete-modal');
        filterServices(); // Reload list
        serviceToDelete = null;
    } catch (error) {
        console.error('Error deleting service:', error);
        showError('Không thể xóa dịch vụ: ' + error.message);
    }
}

/**
 * Toggle service active status
 */
async function toggleServiceStatus(serviceId) {
    try {
        const response = await callAPI(`/api/services/${serviceId}/toggle-status`, 'PATCH');
        showSuccess(response.message || 'Cập nhật trạng thái thành công!');
        filterServices(); // Reload list
    } catch (error) {
        console.error('Error toggling service status:', error);
        showError('Không thể cập nhật trạng thái: ' + error.message);
    }
}

/**
 * Format currency in VND
 */
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(amount);
}

/**
 * Escape HTML to prevent XSS
 */
function escapeHtml(text) {
    if (!text) return text;
    const map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
    };
    return text.toString().replace(/[&<>"']/g, m => map[m]);
}



/**
 * Load all services from API
 */
async function loadServices() {
    try {
        const services = await callAPI('/services', 'GET');
        allServices = services;
        displayServices();
    } catch (error) {
        console.error('Error loading services:', error);
        showError('Không thể tải danh sách dịch vụ: ' + error.message);
    }
}

/**
 * Display services in table
 */
function displayServices() {
    const tbody = document.getElementById('services-tbody');

    if (!allServices || allServices.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" style="text-align: center;">Chưa có dịch vụ nào</td></tr>';
        return;
    }

    tbody.innerHTML = allServices.map(service => `
        <tr>
            <td>${service.id}</td>
            <td>${service.name}</td>
            <td>${service.description || '-'}</td>
            <td>${formatCurrency(service.price)}</td>
            <td>
                <span class="status-badge ${service.active ? 'status-active' : 'status-inactive'}">
                    ${service.active ? 'Hoạt động' : 'Tạm ngưng'}
                </span>
            </td>
            <td>
                <div class="action-buttons">
                    <button class="btn-primary btn-sm" onclick="editService(${service.id})" title="Sửa">
                        ✏️
                    </button>
                    <button class="btn-secondary btn-sm" onclick="toggleServiceStatus(${service.id})" title="Đổi trạng thái">
                        🔄
                    </button>
                    <button class="btn-danger btn-sm" onclick="deleteService(${service.id}, '${escapeHtml(service.name)}')" title="Xóa">
                        🗑️
                    </button>
                </div>
            </td>
        </tr>
    `).join('');
}

/**
 * Filter services based on search input
 */
function filterServices() {
    const searchTerm = document.getElementById('search-input').value.toLowerCase();

    const filteredServices = allServices.filter(service => {
        return service.name.toLowerCase().includes(searchTerm) ||
            (service.description && service.description.toLowerCase().includes(searchTerm));
    });

    const tbody = document.getElementById('services-tbody');

    if (filteredServices.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" style="text-align: center;">Không tìm thấy dịch vụ</td></tr>';
        return;
    }

    tbody.innerHTML = filteredServices.map(service => `
        <tr>
            <td>${service.id}</td>
            <td>${service.name}</td>
            <td>${service.description || '-'}</td>
            <td>${formatCurrency(service.price)}</td>
            <td>
                <span class="status-badge ${service.active ? 'status-active' : 'status-inactive'}">
                    ${service.active ? 'Hoạt động' : 'Tạm ngưng'}
                </span>
            </td>
            <td>
                <div class="action-buttons">
                    <button class="btn-primary btn-sm" onclick="editService(${service.id})">✏️</button>
                    <button class="btn-secondary btn-sm" onclick="toggleServiceStatus(${service.id})">🔄</button>
                    <button class="btn-danger btn-sm" onclick="deleteService(${service.id}, '${escapeHtml(service.name)}')">🗑️</button>
                </div>
            </td>
        </tr>
    `).join('');
}

/**
 * Handle create service form submission
 */
async function handleCreateService(event) {
    event.preventDefault();

    const formData = new FormData(event.target);

    const serviceData = {
        name: formData.get('name'),
        description: formData.get('description'),
        price: parseFloat(formData.get('price')),
        active: formData.get('active') === 'on'
    };

    try {
        const response = await callAPI('/services', 'POST', serviceData);

        showSuccess(response.message || 'Tạo dịch vụ thành công!');

        // Close modal and reload services
        ModalManager.close('create-service-modal');
        event.target.reset();
        loadServices();

    } catch (error) {
        console.error('Error creating service:', error);
        showError(error.message || 'Không thể tạo dịch vụ!');
    }
}

/**
 * Edit service - open modal with pre-filled data
 */
async function editService(serviceId) {
    const service = allServices.find(s => s.id === serviceId);
    if (!service) {
        showError('Không tìm thấy dịch vụ!');
        return;
    }

    // Fill form with service data
    document.getElementById('edit-service-id').value = service.id;
    document.getElementById('edit-service-name').value = service.name;
    document.getElementById('edit-service-description').value = service.description || '';
    document.getElementById('edit-service-price').value = service.price;
    document.getElementById('edit-service-active').checked = service.active;

    // Open modal
    ModalManager.open('edit-service-modal');
}

/**
 * Handle edit service form submission
 */
async function handleEditService(event) {
    event.preventDefault();

    const formData = new FormData(event.target);
    const serviceId = formData.get('id');

    const serviceData = {
        name: formData.get('name'),
        description: formData.get('description'),
        price: parseFloat(formData.get('price')),
        active: formData.get('active') === 'on'
    };

    try {
        const response = await callAPI(`/services/${serviceId}`, 'PUT', serviceData);

        showSuccess(response.message || 'Cập nhật dịch vụ thành công!');

        // Close modal and reload services
        ModalManager.close('edit-service-modal');
        event.target.reset();
        loadServices();

    } catch (error) {
        console.error('Error updating service:', error);
        showError(error.message || 'Không thể cập nhật dịch vụ!');
    }
}

/**
 * Delete service - show confirm modal
 */
function deleteService(serviceId, serviceName) {
    // Store service info for deletion
    serviceToDelete = { id: serviceId, name: serviceName };

    // Update modal content
    document.getElementById('delete-service-name').textContent = serviceName;

    // Set up confirm button click handler
    const confirmBtn = document.getElementById('confirm-delete-btn');
    confirmBtn.onclick = confirmDeleteService;

    // Show confirm modal
    ModalManager.open('confirm-delete-modal');
}

/**
 * Confirm and execute delete
 */
async function confirmDeleteService() {
    if (!serviceToDelete) return;

    try {
        await callAPI(`/services/${serviceToDelete.id}`, 'DELETE');
        showSuccess('Xóa dịch vụ thành công!');
        ModalManager.close('confirm-delete-modal');
        loadServices();
        serviceToDelete = null;
    } catch (error) {
        console.error('Error deleting service:', error);
        showError('Không thể xóa dịch vụ: ' + error.message);
    }
}

/**
 * Toggle service active status
 */
async function toggleServiceStatus(serviceId) {
    try {
        const response = await callAPI(`/services/${serviceId}/toggle-status`, 'PATCH');
        showSuccess(response.message || 'Cập nhật trạng thái thành công!');
        loadServices();
    } catch (error) {
        console.error('Error toggling service status:', error);
        showError('Không thể cập nhật trạng thái: ' + error.message);
    }
}

/**
 * Format currency in VND
 */
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(amount);
}

/**
 * Escape HTML to prevent XSS
 */
function escapeHtml(text) {
    const map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
    };
    return text.replace(/[&<>"']/g, m => map[m]);
}

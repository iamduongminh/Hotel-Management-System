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
        const services = await callAPI('/services', 'GET');
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
/**
 * Filter services client-side for immediate response
 * @param {string} source - 'price' if triggered by slider
 */
function filterServices(source) {
    const searchInput = document.getElementById('search-input');
    const typeSelect = document.getElementById('filter-type');

    // If triggered by slider, we want immediate feedback but we DO want to respect other filters
    // "vẫn bị ảnh hưởng" -> Combined filtering

    const searchTerm = searchInput.value.toLowerCase();
    const type = typeSelect.value;

    const minInput = document.getElementById('filter-min-price');
    const maxInput = document.getElementById('filter-max-price');
    let minVal = parseInt(minInput.value) || 0;
    let maxVal = parseInt(maxInput.value) || 0;

    // Ensure min <= max
    if (minVal > maxVal) {
        [minVal, maxVal] = [maxVal, minVal];
    }

    // Client-side filtering
    const filtered = allServices.filter(service => {
        // Name check
        const matchesName = !searchTerm ||
            service.name.toLowerCase().includes(searchTerm) ||
            (service.description && service.description.toLowerCase().includes(searchTerm));

        // Type check
        const matchesType = !type || service.type === type;

        // Price check
        const matchesPrice = service.price >= minVal && service.price <= maxVal;

        return matchesName && matchesType && matchesPrice;
    });

    displayServices(filtered);
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
            <td style="text-align: center;">${getServiceTypeLabel(service.type)}</td>
            <td>${formatCurrency(service.price)}</td>
            <td>${service.description ? escapeHtml(service.description) : '-'}</td>
            <td style="text-align: center;">
                <span class="status-badge ${service.active ? 'status-active' : 'status-inactive'}">
                    ${service.active ? 'Hoạt động' : 'Tạm ngưng'}
                </span>
            </td>
            <td>
                <div class="action-menu-container">
                    <button class="action-menu-btn" onclick="toggleActionMenu(event, ${service.id})">
                        ⋮
                    </button>
                    <div class="action-dropdown" id="dropdown-${service.id}">
                        <button class="action-dropdown-item" onclick="editService(${service.id})">
                            ✏️ Sửa
                        </button>
                        <button class="action-dropdown-item" onclick="toggleServiceStatus(${service.id})">
                            🔄 Đổi trạng thái
                        </button>
                        <button class="action-dropdown-item danger" onclick="deleteService(${service.id}, '${escapeHtml(service.name)}')">
                            🗑️ Xóa
                        </button>
                    </div>
                </div>
            </td>
        </tr>
    `).join('');
}

/**
 * Toggle action dropdown menu
 */
function toggleActionMenu(event, serviceId) {
    event.stopPropagation();
    const dropdown = document.getElementById(`dropdown-${serviceId}`);

    // Close current dropdown if exists
    if (currentOpenDropdown && currentOpenDropdown !== dropdown) {
        currentOpenDropdown.classList.remove('show');
    }

    // Toggle the clicked dropdown
    dropdown.classList.toggle('show');
    currentOpenDropdown = dropdown.classList.contains('show') ? dropdown : null;
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
        price: parseNumberFromDots(formData.get('price')),
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
    // Find service from current list (allServices might be filtered, but we need full object)
    // Actually allServices is not guaranteed to have all if we refreshed via filter.
    // Better fetch by ID or ensure we have it.
    // Since displayServices receives 'services', we can try to find in 'allServices' if we kept duplicate,
    // Or just fetch detail to be safe.

    try {
        const service = await callAPI(`/services/${serviceId}`, 'GET');

        // Fill form with service data
        document.getElementById('edit-service-id').value = service.id;
        document.getElementById('edit-service-name').value = service.name;
        document.getElementById('edit-service-type').value = service.type || 'OTHER';
        document.getElementById('edit-service-description').value = service.description || '';
        document.getElementById('edit-service-price').value = formatNumberWithDots(service.price);
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
        price: parseNumberFromDots(formData.get('price')),
        active: formData.get('active') === 'on'
    };

    try {
        const response = await callAPI(`/services/${serviceId}`, 'PUT', serviceData);

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
        await callAPI(`/services/${serviceToDelete.id}`, 'DELETE');
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
    // 1. Find service in local state
    const service = allServices.find(s => s.id === serviceId);
    if (!service) return;

    // 2. Optimistic Update: Toggle immediately in local state
    const originalStatus = service.active;
    service.active = !service.active;

    // 3. Re-render UI immediately
    // We pass 'keep-search' or just a dummy string to ensure we don't clear filters if we were in that mode,
    // although filterServices('price') clears them. Standard filterServices() keeps them.
    // Just calling filterServices() without 'price' will keep existing search/type filters.
    filterServices();

    try {
        // 4. Call API in background
        const response = await callAPI(`/services/${serviceId}/toggle-status`, 'PATCH');
        showSuccess(response.message || 'Cập nhật trạng thái thành công!');
        // No need to reload list if successful, our local state is already correct.
    } catch (error) {
        console.error('Error toggling service status:', error);
        showError('Không thể cập nhật trạng thái: ' + error.message);

        // 5. Revert on failure
        service.active = originalStatus;
        filterServices();
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




/**
 * User Management - Admin Dashboard
 * Create, view, edit, and delete users with automatic password encryption
 */

// Global variables
// Global variables
let allUsers = []; // Store all users for filtering
let currentOpenDropdown = null;

// Pagination configuration
let currentPage = 1;
const rowsPerPage = 20;
let filteredUsers = []; // Store filtered users for pagination

// Load users when page loads
document.addEventListener('DOMContentLoaded', () => {
    loadUsers();

    // Close dropdown when clicking outside
    document.addEventListener('click', (e) => {
        if (currentOpenDropdown && !e.target.closest('.action-menu-container')) {
            currentOpenDropdown.classList.remove('show');
            currentOpenDropdown = null;
        }
    });
});

/**
 * Load all users from API
 */
async function loadUsers() {
    try {
        const users = await callAPI('/users', 'GET');
        allUsers = users; // Store globally for filtering
        filteredUsers = users; // Initialize filtered list
        currentPage = 1; // Reset page
        displayUsers(); // Display first page
    } catch (error) {
        console.error('Error loading users:', error);
        showError('Không thể tải danh sách user: ' + error.message);
    }
}

/**
 * Display users in table with 3-dot menu and pagination
 */
function displayUsers() {
    const tbody = document.getElementById('users-tbody');
    const paginationContainer = document.getElementById('pagination-container');

    if (!filteredUsers || filteredUsers.length === 0) {
        tbody.innerHTML = '<tr><td colspan="5" style="text-align: center;">Chưa có tài khoản nào</td></tr>';
        paginationContainer.style.display = 'none';
        return;
    }

    // Calculate pagination bounds
    const startIndex = (currentPage - 1) * rowsPerPage;
    const endIndex = Math.min(startIndex + rowsPerPage, filteredUsers.length);
    const usersToShow = filteredUsers.slice(startIndex, endIndex);

    // Update table content
    tbody.innerHTML = usersToShow.map(user => `
        <tr data-user-id="${user.id}">
            <td>${user.id}</td>
            <td>${user.username}</td>
            <td>${user.fullName}</td>
            <td style="text-align: center;">${getRoleDisplay(user.role)}</td>
            <td style="text-align: center;">
                <div class="action-menu-container">
                    <button class="action-menu-btn" onclick="toggleActionMenu(event, ${user.id})">
                        ⋮
                    </button>
                    <div class="action-dropdown" id="dropdown-${user.id}">
                        <button class="action-dropdown-item" onclick="editUser(${user.id})">
                            ✏️ Sửa
                        </button>
                        <button class="action-dropdown-item danger" onclick="deleteUser(${user.id}, '${user.username}')">
                            🗑️ Xóa
                        </button>
                    </div>
                </div>
            </td>
        </tr>
    `).join('');

    // Update pagination controls
    updatePaginationControls(startIndex, endIndex, filteredUsers.length);
}

/**
 * Update pagination UI
 */
function updatePaginationControls(startIndex, endIndex, totalItems) {
    const container = document.getElementById('pagination-container');
    const info = document.getElementById('pagination-info');
    const controls = document.getElementById('pagination-controls');

    container.style.display = 'flex';
    info.textContent = `Hiển thị kết quả từ ${startIndex + 1} tới ${endIndex} trong số ${totalItems} tài khoản`;

    const totalPages = Math.ceil(totalItems / rowsPerPage);

    let buttonsHtml = `
        <button class="pagination-btn" onclick="changePage(1)" ${currentPage === 1 ? 'disabled' : ''}>
            &laquo;
        </button>
        <button class="pagination-btn" onclick="changePage(${currentPage - 1})" ${currentPage === 1 ? 'disabled' : ''}>
            &lt;
        </button>
    `;

    // Smart pagination: show limited page numbers
    let startPage = Math.max(1, currentPage - 1);
    let endPage = Math.min(totalPages, currentPage + 1);

    if (startPage > 1) {
        buttonsHtml += `<button class="pagination-btn" onclick="changePage(1)">1</button>`;
        if (startPage > 2) buttonsHtml += `<span style="color: var(--text-muted)">...</span>`;
    }

    for (let i = startPage; i <= endPage; i++) {
        buttonsHtml += `
            <button class="pagination-btn ${currentPage === i ? 'active' : ''}" 
                onclick="changePage(${i})">
                ${i}
            </button>
        `;
    }

    if (endPage < totalPages) {
        if (endPage < totalPages - 1) buttonsHtml += `<span style="color: var(--text-muted)">...</span>`;
        buttonsHtml += `<button class="pagination-btn" onclick="changePage(${totalPages})">${totalPages}</button>`;
    }

    buttonsHtml += `
        <button class="pagination-btn" onclick="changePage(${currentPage + 1})" ${currentPage === totalPages ? 'disabled' : ''}>
            &gt;
        </button>
        <button class="pagination-btn" onclick="changePage(${totalPages})" ${currentPage === totalPages ? 'disabled' : ''}>
            &raquo;
        </button>
    `;

    controls.innerHTML = buttonsHtml;
}

/**
 * Change current page
 */
function changePage(newPage) {
    const totalPages = Math.ceil(filteredUsers.length / rowsPerPage);
    if (newPage >= 1 && newPage <= totalPages) {
        currentPage = newPage;
        displayUsers();
    }
}


/**
 * Get role display name in Vietnamese
 */
function getRoleDisplay(role) {
    const roleMap = {
        'MANAGER': '🏨 Quản lý khách sạn',
        'ADMIN': '💻 Admin',
        'RECEPTIONIST': '👔 Lễ tân'
    };
    return roleMap[role] || role;
}

/**
 * Handle role change to show/hide conditional fields
 */
// function handleRoleChange() removed

/**
 * Handle create user form submission
 */
async function handleCreateUser(event) {
    event.preventDefault();

    const formData = new FormData(event.target);

    const userData = {
        username: formData.get('username'),
        password: formData.get('password'),  // Will be auto-encrypted by backend
        fullName: formData.get('fullName'),
        role: formData.get('role'),
        birthday: formData.get('birthday') || null,
        phoneNumber: formData.get('phoneNumber'),
        email: formData.get('email')
    };

    try {
        const response = await callAPI('/users', 'POST', userData);

        showSuccess(response.message || 'Tạo tài khoản thành công!');

        // Close modal and reload users
        ModalManager.close('create-user-modal');
        event.target.reset();
        loadUsers();

    } catch (error) {
        console.error('Error creating user:', error);
        showError(error.message || 'Không thể tạo tài khoản!');
        shakeElement('#create-user-form');
    }
}

/**
 * Delete user - show confirm modal
 */
let userToDelete = null;

function deleteUser(userId, username) {
    // Store user info for deletion
    userToDelete = { id: userId, username: username };

    // Update modal content
    document.getElementById('delete-username').textContent = username;

    // Set up confirm button click handler
    const confirmBtn = document.getElementById('confirm-delete-btn');
    confirmBtn.onclick = confirmDeleteUser;

    // Show confirm modal
    ModalManager.open('confirm-delete-modal');
}

/**
 * Confirm and execute delete
 */
async function confirmDeleteUser() {
    if (!userToDelete) return;

    try {
        await callAPI(`/users/${userToDelete.id}`, 'DELETE');
        showSuccess('Xóa tài khoản thành công!');
        ModalManager.close('confirm-delete-modal');
        loadUsers();
        userToDelete = null;
    } catch (error) {
        console.error('Error deleting user:', error);
        showError('Không thể xóa tài khoản: ' + error.message);
    }
}

/**
 * Toggle action dropdown menu
 */
function toggleActionMenu(event, userId) {
    event.stopPropagation();
    const dropdown = document.getElementById(`dropdown-${userId}`);

    // Close current dropdown if exists
    if (currentOpenDropdown && currentOpenDropdown !== dropdown) {
        currentOpenDropdown.classList.remove('show');
    }

    // Toggle the clicked dropdown
    dropdown.classList.toggle('show');
    currentOpenDropdown = dropdown.classList.contains('show') ? dropdown : null;
}

/**
 * Filter users based on search and filter inputs
 */
function filterUsers() {
    const searchTerm = document.getElementById('search-input').value.toLowerCase();
    const roleFilter = document.getElementById('role-filter').value;

    filteredUsers = allUsers.filter(user => {
        const matchesSearch = user.fullName.toLowerCase().includes(searchTerm) ||
            user.username.toLowerCase().includes(searchTerm);
        const matchesRole = !roleFilter || user.role === roleFilter;

        return matchesSearch && matchesRole;
    });

    currentPage = 1; // Reset to first page when filtering
    displayUsers();
}

// Removed handleRoleFilterChange, handleCityFilterChange, updateBranchFilterOptions

/**
 * Edit user - open modal with pre-filled data
 */
async function editUser(userId) {
    const user = allUsers.find(u => u.id === userId);
    if (!user) {
        showError('Không tìm thấy user!');
        return;
    }

    // Fill form with user data
    document.getElementById('edit-user-id').value = user.id;
    document.getElementById('edit-username').value = user.username;
    document.getElementById('edit-fullName').value = user.fullName;
    document.getElementById('edit-role').value = user.role;
    // Removed city and branch fields population
    document.getElementById('edit-birthday').value = user.birthday || '';
    document.getElementById('edit-phoneNumber').value = user.phoneNumber || '';
    document.getElementById('edit-email').value = user.email || '';

    // No need to trigger handleEditRoleChange as logic is removed

    // Open modal
    ModalManager.open('edit-user-modal');
}

// function handleEditRoleChange() removed

/**
 * Handle edit user form submission
 */
async function handleEditUser(event) {
    event.preventDefault();

    const formData = new FormData(event.target);
    const userId = formData.get('id');

    const userData = {
        username: formData.get('username'),
        fullName: formData.get('fullName'),
        role: formData.get('role'),
        birthday: formData.get('birthday') || null,
        phoneNumber: formData.get('phoneNumber'),
        email: formData.get('email')
    };

    try {
        const response = await callAPI(`/users/${userId}`, 'PUT', userData);

        showSuccess(response.message || 'Cập nhật tài khoản thành công!');

        // Close modal and reload users
        ModalManager.close('edit-user-modal');
        event.target.reset();
        loadUsers();

    } catch (error) {
        console.error('Error updating user:', error);
        showError(error.message || 'Không thể cập nhật tài khoản!');
        shakeElement('#edit-user-form');
    }
}

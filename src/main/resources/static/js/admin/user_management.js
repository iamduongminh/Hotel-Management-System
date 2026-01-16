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
        updateBranchFilterOptions();
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
        tbody.innerHTML = '<tr><td colspan="7" style="text-align: center;">Chưa có tài khoản nào</td></tr>';
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
            <td>${getRoleDisplay(user.role)}</td>
            <td>${user.city || '-'}</td>
            <td>${user.branchName || '-'}</td>
            <td>
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
        'REGIONAL_MANAGER': '🌟 Regional Manager',
        'BRANCH_MANAGER': '🏨 Branch Manager',
        'ADMIN': '💻 IT Admin',
        'RECEPTIONIST': '👔 Lễ tân',
        'HOUSEKEEPER': '🧹 Dọn phòng'
    };
    return roleMap[role] || role;
}

/**
 * Handle role change to show/hide conditional fields
 */
function handleRoleChange() {
    const roleSelect = document.getElementById('role-select');
    const selectedRole = roleSelect.value;

    const cityGroup = document.getElementById('city-group');
    const branchGroup = document.getElementById('branch-group');

    // Show city for Regional Managers
    if (selectedRole === 'REGIONAL_MANAGER') {
        cityGroup.style.display = 'block';
        branchGroup.style.display = 'none';
        cityGroup.querySelector('select').required = true;
        branchGroup.querySelector('input').required = false;
    }
    // Show branch for Branch Managers, Admins, and Staff
    else if (selectedRole === 'BRANCH_MANAGER' || selectedRole === 'ADMIN' ||
        selectedRole === 'RECEPTIONIST' || selectedRole === 'HOUSEKEEPER') {
        cityGroup.style.display = 'block';
        branchGroup.style.display = 'block';
        if (selectedRole === 'BRANCH_MANAGER' || selectedRole === 'ADMIN') {
            branchGroup.querySelector('input').required = true;
        } else {
            branchGroup.querySelector('input').required = false;
        }
    }
    else {
        cityGroup.style.display = 'none';
        branchGroup.style.display = 'none';
        cityGroup.querySelector('select').required = false;
        branchGroup.querySelector('input').required = false;
    }
}

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
        city: formData.get('city'),
        branchName: formData.get('branchName'),
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
    const cityFilter = document.getElementById('city-filter').value;
    const branchFilter = document.getElementById('branch-filter').value;

    filteredUsers = allUsers.filter(user => {
        const matchesSearch = user.fullName.toLowerCase().includes(searchTerm) ||
            user.username.toLowerCase().includes(searchTerm);
        const matchesRole = !roleFilter || user.role === roleFilter;
        const matchesCity = !cityFilter || user.city === cityFilter;
        const matchesBranch = !branchFilter || user.branchName === branchFilter;

        return matchesSearch && matchesRole && matchesCity && matchesBranch;
    });

    currentPage = 1; // Reset to first page when filtering
    displayUsers();
}

/**
 * Handle role filter change
 * Hides branch filter if Regional Manager is selected
 */
function handleRoleFilterChange() {
    const roleFilter = document.getElementById('role-filter');
    const branchFilter = document.getElementById('branch-filter');

    if (roleFilter.value === 'REGIONAL_MANAGER') {
        branchFilter.style.display = 'none';
        branchFilter.value = ''; // Reset value so it doesn't affect filtering
    } else {
        branchFilter.style.display = 'block';
    }

    filterUsers();
}

/**
 * Handle city filter change
 * Updates branch options and triggers filtering
 */
function handleCityFilterChange() {
    updateBranchFilterOptions();
    filterUsers();
}

/**
 * Update branch filter options based on selected city
 */
function updateBranchFilterOptions() {
    const cityFilter = document.getElementById('city-filter').value;
    const branchSelect = document.getElementById('branch-filter');
    const currentBranch = branchSelect.value; // Store current selection

    // Filter branches based on city
    let availableBranches = [];
    if (cityFilter) {
        // If city is selected, only show branches in that city
        availableBranches = [...new Set(allUsers
            .filter(u => u.city === cityFilter && u.branchName)
            .map(u => u.branchName))];
    } else {
        // If no city selected, show all unique branches
        availableBranches = [...new Set(allUsers
            .filter(u => u.branchName)
            .map(u => u.branchName))];
    }

    availableBranches.sort(); // Sort branches alphabetically

    // Update dropdown
    branchSelect.innerHTML = '<option value="">Chi nhánh</option>' +
        availableBranches.map(branch => `<option value="${branch}">${branch}</option>`).join('');

    // Restore selection if still valid (e.g. user selected a branch then selected its city)
    if (currentBranch && availableBranches.includes(currentBranch)) {
        branchSelect.value = currentBranch;
    } else {
        branchSelect.value = ""; // Reset if current branch doesn't belong to new city
    }
}

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
    document.getElementById('edit-city').value = user.city || '';
    document.getElementById('edit-branchName').value = user.branchName || '';
    document.getElementById('edit-birthday').value = user.birthday || '';
    document.getElementById('edit-phoneNumber').value = user.phoneNumber || '';
    document.getElementById('edit-email').value = user.email || '';

    // Trigger role change to show/hide conditional fields
    handleEditRoleChange();

    // Open modal
    ModalManager.open('edit-user-modal');
}

/**
 * Handle role change in edit modal
 */
function handleEditRoleChange() {
    const roleSelect = document.getElementById('edit-role');
    const selectedRole = roleSelect.value;

    const cityGroup = document.getElementById('edit-city-group');
    const branchGroup = document.getElementById('edit-branch-group');

    // Show city for Regional Managers
    if (selectedRole === 'REGIONAL_MANAGER') {
        cityGroup.style.display = 'block';
        branchGroup.style.display = 'none';
        cityGroup.querySelector('select').required = true;
        branchGroup.querySelector('input').required = false;
    }
    // Show branch for Branch Managers, Admins, and Staff
    else if (selectedRole === 'BRANCH_MANAGER' || selectedRole === 'ADMIN' ||
        selectedRole === 'RECEPTIONIST' || selectedRole === 'HOUSEKEEPER') {
        cityGroup.style.display = 'block';
        branchGroup.style.display = 'block';
        if (selectedRole === 'BRANCH_MANAGER' || selectedRole === 'ADMIN') {
            branchGroup.querySelector('input').required = true;
        } else {
            branchGroup.querySelector('input').required = false;
        }
    }
    else {
        cityGroup.style.display = 'none';
        branchGroup.style.display = 'none';
        cityGroup.querySelector('select').required = false;
        branchGroup.querySelector('input').required = false;
    }
}

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
        city: formData.get('city'),
        branchName: formData.get('branchName'),
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

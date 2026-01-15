/**
 * User Management - Admin Dashboard
 * Create, view, edit, and delete users with automatic password encryption
 */

// Global variables
let allUsers = []; // Store all users for filtering
let currentOpenDropdown = null;

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
        displayUsers(users);
        populateBranchFilter(users);
    } catch (error) {
        console.error('Error loading users:', error);
        showError('Không thể tải danh sách user: ' + error.message);
    }
}

/**
 * Display users in table with 3-dot menu
 */
function displayUsers(users) {
    const tbody = document.getElementById('users-tbody');

    if (!users || users.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" style="text-align: center;">Chưa có tài khoản nào</td></tr>';
        return;
    }

    tbody.innerHTML = users.map(user => `
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

    const filteredUsers = allUsers.filter(user => {
        const matchesSearch = user.fullName.toLowerCase().includes(searchTerm) ||
            user.username.toLowerCase().includes(searchTerm);
        const matchesRole = !roleFilter || user.role === roleFilter;
        const matchesCity = !cityFilter || user.city === cityFilter;
        const matchesBranch = !branchFilter || user.branchName === branchFilter;

        return matchesSearch && matchesRole && matchesCity && matchesBranch;
    });

    displayUsers(filteredUsers);
}

/**
 * Populate branch filter dropdown with unique branches
 */
function populateBranchFilter(users) {
    const branchSelect = document.getElementById('branch-filter');
    const uniqueBranches = [...new Set(users.map(u => u.branchName).filter(b => b))];

    // Keep the default option and add unique branches
    branchSelect.innerHTML = '<option value="">Tất cả chi nhánh</option>' +
        uniqueBranches.map(branch => `<option value="${branch}">${branch}</option>`).join('');
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

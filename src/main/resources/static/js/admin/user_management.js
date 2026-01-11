/**
 * User Management - Admin Dashboard
 * Create, view, and delete users with automatic password encryption
 */

// Load users when page loads
document.addEventListener('DOMContentLoaded', () => {
    loadUsers();
});

/**
 * Load all users from API
 */
async function loadUsers() {
    try {
        const users = await callAPI('/users', 'GET');
        displayUsers(users);
    } catch (error) {
        console.error('Error loading users:', error);
        showError('Không thể tải danh sách user: ' + error.message);
    }
}

/**
 * Display users in table
 */
function displayUsers(users) {
    const tbody = document.getElementById('users-tbody');

    if (!users || users.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" style="text-align: center;">Chưa có tài khoản nào</td></tr>';
        return;
    }

    tbody.innerHTML = users.map(user => `
        <tr>
            <td>${user.id}</td>
            <td>${user.username}</td>
            <td>${user.fullName}</td>
            <td>${getRoleDisplay(user.role)}</td>
            <td>${user.city || '-'}</td>
            <td>${user.branchName || '-'}</td>
            <td>
                <button class="btn btn-danger btn-sm" onclick="deleteUser(${user.id}, '${user.username}')">
                    Xóa
                </button>
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
 * Delete user
 */
async function deleteUser(userId, username) {
    if (!confirm(`Bạn có chắc muốn xóa tài khoản "${username}"?`)) {
        return;
    }

    try {
        await callAPI(`/users/${userId}`, 'DELETE');
        showSuccess('Xóa tài khoản thành công!');
        loadUsers();
    } catch (error) {
        console.error('Error deleting user:', error);
        showError('Không thể xóa tài khoản: ' + error.message);
    }
}

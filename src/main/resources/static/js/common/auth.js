/**
 * Authentication Utilities
 * Centralized logout function
 */

/**
 * Logout user - clears both client and server session
 */
async function logout() {
    if (!confirm('Bạn có chắc muốn đăng xuất?')) {
        return;
    }

    try {
        // Call backend to invalidate server session
        await callAPI('/auth/logout', 'POST');
    } catch (error) {
        console.warn('Server logout failed:', error);
        // Continue anyway - still clear client side
    }

    // Clear client-side storage
    localStorage.clear();
    sessionStorage.clear();

    // Redirect to login
    window.location.href = '/pages/auth/login.html';
}

// Make it globally available
window.logout = logout;

// Alias for backward compatibility
window.handleLogout = logout;

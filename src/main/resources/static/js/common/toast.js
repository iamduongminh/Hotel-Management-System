/**
 * Toast Notification System
 * Modern replacement for alert() dialogs
 */

// Create toast container on page load
document.addEventListener('DOMContentLoaded', () => {
    if (!document.getElementById('toast-container')) {
        const container = document.createElement('div');
        container.id = 'toast-container';
        document.body.appendChild(container);
    }
});

/**
 * Show a toast notification
 * @param {string} message - The message to display
 * @param {string} type - Toast type: 'success', 'error', 'warning', 'info'
 * @param {number} duration - Duration in milliseconds (default: 4000)
 */
function showToast(message, type = 'info', duration = 4000) {
    // Create toast container if it doesn't exist
    let container = document.getElementById('toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toast-container';
        document.body.appendChild(container);
    }

    // Create toast element
    const toast = document.createElement('div');
    toast.className = `toast ${type}`;

    // Get icon based on type
    const icons = {
        success: '✅',
        error: '❌',
        warning: '⚠️',
        info: 'ℹ️'
    };

    const icon = icons[type] || icons.info;

    // Build toast HTML
    toast.innerHTML = `
        <span class="toast-icon">${icon}</span>
        <span class="toast-message">${message}</span>
        <span class="toast-close">×</span>
        <div class="toast-progress" style="animation-duration: ${duration}ms"></div>
    `;

    // Add to container
    container.appendChild(toast);

    // Click to dismiss
    const closeBtn = toast.querySelector('.toast-close');
    closeBtn.addEventListener('click', (e) => {
        e.stopPropagation();
        dismissToast(toast);
    });

    // Toast body click to dismiss
    toast.addEventListener('click', () => {
        dismissToast(toast);
    });

    // Auto dismiss after duration
    setTimeout(() => {
        dismissToast(toast);
    }, duration);
}

/**
 * Dismiss a toast notification
 * @param {HTMLElement} toast - Toast element to dismiss
 */
function dismissToast(toast) {
    if (!toast || toast.classList.contains('fade-out')) return;

    toast.classList.add('fade-out');

    // Remove from DOM after animation
    setTimeout(() => {
        if (toast.parentElement) {
            toast.parentElement.removeChild(toast);
        }
    }, 400);
}

/**
 * Show success toast
 * @param {string} message - Success message
 * @param {number} duration - Duration in milliseconds
 */
function showSuccess(message, duration = 4000) {
    showToast(message, 'success', duration);
}

/**
 * Show error toast
 * @param {string} message - Error message
 * @param {number} duration - Duration in milliseconds
 */
function showError(message, duration = 5000) {
    showToast(message, 'error', duration);
}

/**
 * Show warning toast
 * @param {string} message - Warning message
 * @param {number} duration - Duration in milliseconds
 */
function showWarning(message, duration = 4000) {
    showToast(message, 'warning', duration);
}

/**
 * Show info toast
 * @param {string} message - Info message
 * @param {number} duration - Duration in milliseconds
 */
function showInfo(message, duration = 4000) {
    showToast(message, 'info', duration);
}

/**
 * Add shake animation to an element
 * @param {string|HTMLElement} element - CSS selector or element to shake
 */
function shakeElement(element) {
    const el = typeof element === 'string' ? document.querySelector(element) : element;

    if (!el) return;

    // Remove existing shake class
    el.classList.remove('shake');

    // Force reflow to restart animation
    void el.offsetWidth;

    // Add shake class
    el.classList.add('shake');

    // Remove class after animation
    setTimeout(() => {
        el.classList.remove('shake');
    }, 600);
}

// Make functions globally available
window.showToast = showToast;
window.showSuccess = showSuccess;
window.showError = showError;
window.showWarning = showWarning;
window.showInfo = showInfo;
window.shakeElement = shakeElement;

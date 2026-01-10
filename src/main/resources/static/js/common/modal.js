/**
 * Modal Component System
 * Reusable modal functionality for SPA
 */

const ModalManager = {
    /**
     * Open a modal by ID
     */
    open: function (modalId) {
        const backdrop = document.getElementById(`${modalId}-backdrop`);
        const modal = document.getElementById(modalId);

        if (backdrop && modal) {
            backdrop.classList.add('active');
            modal.classList.add('active');
            document.body.style.overflow = 'hidden'; // Prevent scroll
        }
    },

    /**
     * Close a modal by ID
     */
    close: function (modalId) {
        const backdrop = document.getElementById(`${modalId}-backdrop`);
        const modal = document.getElementById(modalId);

        if (backdrop && modal) {
            backdrop.classList.remove('active');
            modal.classList.remove('active');
            document.body.style.overflow = ''; // Restore scroll
        }
    },

    /**
     * Close all modals
     */
    closeAll: function () {
        document.querySelectorAll('.modal-backdrop').forEach(backdrop => {
            backdrop.classList.remove('active');
        });
        document.querySelectorAll('.modal').forEach(modal => {
            modal.classList.remove('active');
        });
        document.body.style.overflow = '';
    },

    /**
     * Create a modal dynamically
     */
    create: function (config) {
        const {
            id,
            title,
            content,
            size = 'medium', // small, medium, large
            buttons = []
        } = config;

        // Create backdrop
        const backdrop = document.createElement('div');
        backdrop.id = `${id}-backdrop`;
        backdrop.className = 'modal-backdrop';
        backdrop.onclick = (e) => {
            if (e.target === backdrop) {
                ModalManager.close(id);
            }
        };

        // Create modal
        const modal = document.createElement('div');
        modal.id = id;
        modal.className = `modal ${size}`;

        // Build modal HTML
        let buttonsHtml = '';
        buttons.forEach(btn => {
            buttonsHtml += `<button class="btn ${btn.class || 'btn-secondary'}" onclick="${btn.onclick}">${btn.text}</button>`;
        });

        modal.innerHTML = `
            <div class="modal-header">
                <h2>${title}</h2>
                <button class="modal-close" onclick="ModalManager.close('${id}')">&times;</button>
            </div>
            <div class="modal-body">
                ${content}
            </div>
            ${buttons.length > 0 ? `
            <div class="modal-footer">
                ${buttonsHtml}
            </div>
            ` : ''}
        `;

        backdrop.appendChild(modal);
        document.body.appendChild(backdrop);

        return id;
    }
};

// Global keyboard event - ESC to close modals
document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        ModalManager.closeAll();
    }
});

// Initialize close buttons when DOM is ready
document.addEventListener('DOMContentLoaded', function () {
    // Backdrop click to close
    document.querySelectorAll('.modal-backdrop').forEach(backdrop => {
        backdrop.addEventListener('click', function (e) {
            if (e.target === backdrop) {
                const modal = backdrop.querySelector('.modal');
                if (modal) {
                    ModalManager.close(modal.id);
                }
            }
        });
    });

    // Close button click
    document.querySelectorAll('.modal-close').forEach(btn => {
        btn.addEventListener('click', function () {
            const modal = this.closest('.modal');
            if (modal) {
                ModalManager.close(modal.id);
            }
        });
    });
});

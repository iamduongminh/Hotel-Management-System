document.addEventListener("DOMContentLoaded", function() {
    loadBookings();
});

async function loadBookings() {
    try {
        // Gọi BookingController (Method GET /api/bookings)
        const bookings = await callAPI('/bookings'); 
        
        const tableBody = document.getElementById('booking-table-body');
        tableBody.innerHTML = '';

        bookings.forEach(booking => {
            const row = `
                <tr>
                    <td>#${booking.id}</td>
                    <td>${booking.customerName || 'Khách vãng lai'}</td>
                    <td>${booking.roomNumber || 'Chưa gán'}</td>
                    <td>${booking.checkInDate}</td>
                    <td><span class="status ${booking.status}">${booking.status}</span></td>
                </tr>
            `;
            tableBody.innerHTML += row;
        });
    } catch (error) {
        console.error(error);
    }
}
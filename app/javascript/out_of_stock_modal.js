
// app/assets/javascripts/out_of_stock_modal.js
document.addEventListener('DOMContentLoaded', () => {
    const closeModalButton = document.getElementById('closeOutOfStockModal');
    if (closeModalButton) {
        closeModalButton.addEventListener('click', () => {
            document.getElementById('outOfStockModal').classList.add('hidden');
        });
    }
});

function showOutOfStockModal(message) {
    const modal = document.getElementById('outOfStockModal');
    if (modal) {
        const modalMessage = modal.querySelector('p');
        if (modalMessage) {
            modalMessage.textContent = message;
        }
        modal.classList.remove('hidden');
    }
}

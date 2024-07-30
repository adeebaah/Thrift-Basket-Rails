document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.alert [role="button"]').forEach(button => {
        button.addEventListener('click', () => {
            button.parentElement.parentElement.style.display = 'none';
        });
    });
});

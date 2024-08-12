// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "chartkick"
import "Chart.bundle"

document.addEventListener('DOMContentLoaded', function () {
    let currentOffset = 5;

    document.getElementById('load-more').addEventListener('click', function () {
        fetch(`/load_more_products?offset=${currentOffset}`)
            .then(response => response.json())
            .then(data => {
                const productContainer = document.getElementById('product-container');
                data.products.forEach(product => {
                    const productElement = document.createElement('div');
                    productElement.classList.add('max-w-xs', 'bg-gray-100', 'shadow-lg', 'rounded-lg', 'p-4');
                    productElement.innerHTML = `
            <h2 class="text-gray-800 font-medium text-lg text-center mb-4">${product.name}</h2>
            <div class="h-64 w-64 flex items-center justify-center bg-white rounded-lg overflow-hidden mx-auto">
              <img src="${product.image_url}" class="max-h-full max-w-full">
            </div>
            <p class="text-center mt-4">BDT ${product.price}</p>
            <div class="text-center mt-4 flex justify-center items-center space-x-2">
              <a href="/products/${product.id}" class="bg-gray-500 hover:bg-gray-600 text-white font-bold py-2 px-4 rounded" data-turbo="false">View Details</a>
              ${product.in_stock ? `
                <form action="/wishlist/add_item" method="post" class="inline">
                  <input type="hidden" name="product_id" value="${product.id}">
                  <button type="submit" class="bg-pink-400 hover:bg-pink-600 text-white font-bold py-2 px-4 rounded">
                    <i class="fa-solid fa-heart"></i>
                  </button>
                </form>
              ` : `
                <button class="bg-gray-500 text-white font-bold py-2 px-4 rounded" disabled>Out of Stock</button>
              `}
            </div>
          `;
                    productContainer.appendChild(productElement);
                });
                currentOffset += 5;
                if (!data.hasMoreProducts) {
                    document.getElementById('load-more').style.display = 'none';
                }
            });
    });
});

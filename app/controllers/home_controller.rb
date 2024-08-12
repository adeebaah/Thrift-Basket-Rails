class HomeController < ApplicationController
  def index
   @main_categories = Category.all
    @slides = Slide.all
    @products = Product.where(visible: true)
  end

  def about

  end



  def wishlist

  end


  def load_more_products
    offset = params[:offset].to_i
    products = Product.where(visible: true).offset(offset).limit(5)

    render json: {
      products: products.map do |product|
        {
          id: product.id,
          name: product.name,
          price: product.price,
          image_url: product.images.first.present? ? url_for(product.images.first) : 'https://via.placeholder.com/512',
          in_stock: product.stocks.sum(:amount) > 0
        }
      end,
      hasMoreProducts: products.size == 4
    }
  end
end

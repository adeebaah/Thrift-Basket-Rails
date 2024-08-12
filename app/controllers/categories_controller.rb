class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])

    # Apply filtering based on the params[:filter]
    @products = @category.products.where(visible: true)

    case params[:filter]
    when "price_asc"
      @products = @products.order(price: :asc)
    when "price_desc"
      @products = @products.order(price: :desc)
    when "newness"
      @products = @products.order(created_at: :desc)
    else
      @products = @products.page(params[:page])
    end

    @products = @products.page(params[:page]).per(8) # Change 8 to the number of products you want per page
  end
end

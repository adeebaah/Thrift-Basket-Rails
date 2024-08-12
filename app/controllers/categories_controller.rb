class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @products = @category.products.where(visible: true).page(params[:page]).per(8) # Change 10 to the number of products you want per page
  end
end

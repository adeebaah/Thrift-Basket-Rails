# app/controllers/reviews_controller.rb
class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def new
    @product = Product.find(params[:product_id])
    @review = @product.reviews.build
  end

  def create
    @product = Product.find(params[:product_id])
    @review = @product.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @product, notice: 'Review added successfully.'
    else
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end

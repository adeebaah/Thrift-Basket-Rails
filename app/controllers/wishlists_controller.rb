# app/controllers/wishlists_controller.rb
class WishlistsController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def show
    @wishlist = current_user.wishlist || current_user.initialize_wishlist
  end

  def add_item

    @product = Product.find(params[:product_id])
    @wishlist = current_user.wishlist || current_user.initialize_wishlist
    product = Product.find(params[:product_id])
    @wishlist.wishlist_items.create(product: product)
    flash[:notice] = "Item added to your wishlist"
    redirect_to wishlist_path
  end

  def remove_item
    @wishlist = current_user.wishlist
    wishlist_item = @wishlist.wishlist_items.find(params[:id])
    wishlist_item.destroy
    flash[:notice] = "Item has been removed from your wishlist"
    redirect_to wishlist_path
  end

  def guest

  end
  def authenticate_user!
    unless user_signed_in?
      redirect_to wishlist_guest_path
    end
  end


end

class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:user_orders]

  def user_orders
    @user = User.find(params[:id])
    @orders = @user.orders.order(created_at: :desc).limit(15)
  end

  def reorder_items
    order_products = OrderProduct.where(id: params[:reorder_items])
    cart = current_user.cart

    order_products.each do |order_product|
      cart_item = cart.cart_items.find_or_initialize_by(product_id: order_product.product_id, size: order_product.size)
      cart_item.quantity = (cart_item.quantity || 0) + order_product.quantity
      cart_item.save
    end

    redirect_to cart_path, notice: 'Selected items have been added to your cart.'
  end

end

class CartsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :add_item, :remove_item, :increase_quantity, :decrease_quantity]

  def show
    @cart = current_user.cart || current_user.create_cart
    @cart_items = @cart.cart_items.includes(:product)
    respond_to do |format|
      format.html
      format.json { render json: { cart_items: @cart_items.as_json(include: :product) } }
    end
  end
  def add_item
    @cart = current_user.cart || current_user.create_cart
    @product = Product.find(params[:product_id])
    @cart_item = @cart.cart_items.find_by(product_id: @product.id, size: params[:size])

    if @cart_item
      @cart_item.quantity += 1
    else
      @cart_item = @cart.cart_items.build(product: @product, size: params[:size], quantity: 1)
    end

    if @cart_item.save
      render json: { success: true, cart_items: @cart.cart_items.as_json(include: :product) }
    else
      render json: { success: false }, status: :unprocessable_entity
    end
  end

  def increase_quantity
    cart_item = current_user.cart.cart_items.find(params[:id])
    cart_item.update(quantity: cart_item.quantity + 1)
    redirect_to cart_path
  end

  def decrease_quantity
    cart_item = current_user.cart.cart_items.find(params[:id])
    if cart_item.quantity > 1
      cart_item.update(quantity: cart_item.quantity - 1)
    else
      cart_item.destroy
    end
    redirect_to cart_path
  end

  def remove_item
    cart_item = current_user.cart.cart_items.find(params[:id])
    cart_item.destroy
    redirect_to cart_path
  end

  def clear
    current_user.cart.cart_items.destroy_all
    redirect_to cart_path
  end

  def checkout
    # Add your checkout logic here
  end
end

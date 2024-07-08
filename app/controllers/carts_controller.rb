class CartsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :add_item, :remove_item, :increase_quantity, :decrease_quantity]

  def show
    @cart = current_user.cart || current_user.create_cart
    @cart_items = @cart.cart_items.includes(:product).order("created_at DESC")
    respond_to do |format|
      format.html
      format.json { render json: { cart_items: @cart_items.as_json(include: :product) } }
    end
  end

  def add_item
    @cart = current_user.cart || current_user.create_cart
    @product = Product.find(params[:product_id])
    @cart_item = @cart.cart_items.find_by(product_id: @product.id, size: params[:size])

    if Stock.available?(@product.id, params[:size]) # Check if the stock is available
      if @cart_item
        @cart_item.quantity += 1
      else
        @cart_item = @cart.cart_items.build(product: @product, size: params[:size], quantity: 1)
      end

      if @cart_item.save
        Stock.reduce!(@product.id, params[:size], 1) # Reduce the stock
        render json: { success: true, cart_items: @cart.cart_items.as_json(include: :product) }
      else
        render json: { success: false, message: 'Error adding item to cart' }, status: :unprocessable_entity
      end
    else
      render json: { success: false, message: 'Stock not available' }, status: :unprocessable_entity
    end
  end

  def increase_quantity
    cart_item = current_user.cart.cart_items.find(params[:id])
    if Stock.available?(cart_item.product_id, cart_item.size)
      cart_item.update(quantity: cart_item.quantity + 1)
      Stock.reduce!(cart_item.product_id, cart_item.size, 1)
    end
    redirect_to cart_path
  end

  def decrease_quantity
    cart_item = current_user.cart.cart_items.find(params[:id])
    if cart_item.quantity > 1
      cart_item.update(quantity: cart_item.quantity - 1)
      Stock.increase!(cart_item.product_id, cart_item.size, 1)
    else
      Stock.increase!(cart_item.product_id, cart_item.size, cart_item.quantity)
      cart_item.destroy
    end
    redirect_to cart_path
  end

  def remove_item
    cart_item = current_user.cart.cart_items.find(params[:id])
    Stock.increase!(cart_item.product_id, cart_item.size, cart_item.quantity)
    cart_item.destroy
    redirect_to cart_path
  end

  def clear
    current_user.cart.cart_items.each do |cart_item|
      Stock.increase!(cart_item.product_id, cart_item.size, cart_item.quantity)
    end
    current_user.cart.cart_items.destroy_all
    redirect_to cart_path
  end

  def checkout
    # Add your checkout logic here
  end
end

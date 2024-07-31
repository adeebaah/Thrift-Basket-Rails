class CartsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :add_item, :remove_item, :increase_quantity, :decrease_quantity, :checkout]

  def checkout_details
    @user = current_user
  end

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

    if Stock.available?(@product.id, params[:size])
      if @cart_item
        @cart_item.quantity += 1
      else
        @cart_item = @cart.cart_items.build(product: @product, size: params[:size], quantity: 1)
      end

      if @cart_item.save

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
      desired_quantity = cart_item.quantity + 1

      if Stock.available_quantity(cart_item.product_id, cart_item.size) >= desired_quantity
        cart_item.update(quantity: desired_quantity)
      else
        flash[:alert] = 'Not enough stock available'
      end
    else
      flash[:alert] = 'Stock not available'
    end
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
    @cart = current_user.cart || current_user.create_cart
    if @cart.cart_items.empty?
      respond_to do |format|
        format.html { redirect_to cart_path, flash: { error: "Your cart is empty" } }
        format.json { render json: { success: false, message: "Your cart is empty" }, status: :unprocessable_entity }
      end
    else
      redirect_to details_cart_path
    end
  end

  def details
    @user = current_user
    @cart_items = current_user.cart.cart_items.includes(:product).order(created_at: :desc)
  end

  def confirm_checkout
    @order = current_user.orders.create(
      customer_email: current_user.email,
      total: calculate_total_price,
      address: params[:address],
      phone: params[:phone],
      status: 'Pending',
      delivery_mode: params[:delivery_mode] # Ensure delivery_mode is included here
    )

    current_user.cart.cart_items.includes(:product).each do |item|
      @order.order_products.create(
        product: item.product,
        size: item.size,
        quantity: item.quantity,
        )

    end

    current_user.cart.cart_items.destroy_all
    flash[:notice] = 'Order has been confirmed!'
    redirect_to root_path
  end

  def cart_data
    @cart = current_user.cart || current_user.create_cart
    @cart_items = @cart.cart_items.includes(:product).order("created_at DESC")
    render json: { cart_items: @cart_items.as_json(include: :product) }
  end


  private

  def calculate_total_price
    current_user.cart.cart_items.sum { |item| item.product.price * item.quantity }
  end
end




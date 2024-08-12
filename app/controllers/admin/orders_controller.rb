class Admin::OrdersController < AdminController
  before_action :set_admin_order, only: %i[show edit update destroy]

  def index
    @recent_orders = Order.order(created_at: :desc).page(params[:recent_page]).per(10)
    @not_fulfilled_orders = Order.where(status: 'Pending').order(created_at: :asc).page(params[:not_fulfilled_page]).per(10)
    @fulfilled_orders = Order.where(status: 'Fulfilled').order(created_at: :asc).page(params[:fulfilled_page]).per(10)
    @progress_orders = Order.where(status: 'Progress').order(created_at: :asc).page(params[:progress_page]).per(10)
    @delivered_orders = Order.where(status: 'Delivered').order(created_at: :asc).page(params[:delivered_page]).per(10)
  end

  def show
    @order_products = @admin_order.order_products.includes(:product)
  end

  def new
    @admin_order = Order.new
  end

  def edit
  end

  def create
    @admin_order = Order.new(admin_order_params)

    respond_to do |format|
      if @admin_order.save
        format.html { redirect_to admin_order_url(@admin_order), notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @admin_order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    old_status = @admin_order.status
    respond_to do |format|
      if @admin_order.update(admin_order_params)
        if old_status != 'Fulfilled' && @admin_order.status == 'Fulfilled'
          adjust_and_reduce_stock(@admin_order)
        end
        format.html { redirect_to admin_order_url(@admin_order), notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @admin_order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @admin_order.destroy!

    respond_to do |format|
      format.html { redirect_to admin_orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_admin_order
    @admin_order = Order.find(params[:id])
  end

  def admin_order_params
    params.require(:order).permit(:customer_email, :total, :address, :status, :user_id, :delivery_mode, :phone)
  end

  def adjust_and_reduce_stock(order)
    total = 0
    order.order_products.each do |order_product|
      stock = Stock.find_by(product_id: order_product.product_id, size: order_product.size)
      if stock && stock.amount < order_product.quantity
        order_product.update(quantity: stock.amount)
      end
      total += order_product.product.price * order_product.quantity if stock
      Stock.reduce!(order_product.product_id, order_product.size, order_product.quantity) if stock
    end
    order.update(total: total)
  end
end

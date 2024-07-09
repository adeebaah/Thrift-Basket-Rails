class Admin::ProductsController < AdminController
  before_action :set_admin_product, only: %i[ show edit update destroy ]

  # GET /admin/admin or /admin/admin.json
  def index
    @admin_products = Product.all
  end

  # GET /admin/admin/1 or /admin/admin/1.json
  def show
  end

  # GET /admin/admin/new
  def new
    @admin_product = Product.new
  end

  # GET /admin/admin/1/edit
  def edit
  end

  # POST /admin/admin or /admin/admin.json
  def create
    @admin_product = Product.new(admin_product_params)

    respond_to do |format|
      if @admin_product.save
        format.html { redirect_to admin_product_url(@admin_product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @admin_product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/admin/1 or /admin/admin/1.json
  def update
    @admin_product = Product. find(params[:id])
    if @admin_product.update(admin_product_params.reject { |k| k["images"]})
      if admin_product_params[:images]
        admin_product_params[:images].each do |image|
          @admin_product.images.attach(image)
        end
      end
      redirect_to admin_products_path, notice: "Product was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/admin/1 or /admin/admin/1.json
  def destroy
    @admin_product.destroy!

    respond_to do |format|
      format.html { redirect_to admin_products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def search
    query = params[:query]
    query_tokens = query.split.map { |token| "%#{token}%" }

    @products = Product.where(
      query_tokens.map { "name ILaIKE ?" }.join(" OR "),
      *query_tokens.flat_map { |token| [token] }
    )

    render :index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_product
      @admin_product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_product_params
      params.require(:product).permit(:name, :description, :price, :category_id, :active, images: [])
    end
end

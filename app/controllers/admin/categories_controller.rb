class Admin::CategoriesController < AdminController
  before_action :set_admin_category, only: %i[ show edit update destroy ]


  def index
    @admin_categories = Category.all
  end


  def show
  end

  def new
    @admin_category = Category.new
  end


  def edit
  end

  def create
    @admin_category = Category.new(admin_category_params)

    respond_to do |format|
      if @admin_category.save
        format.html { redirect_to admin_category_url(@admin_category), notice: "Category was successfully created." }
        format.json { render :show, status: :created, location: @admin_category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_category.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @admin_category.update(admin_category_params)
        format.html { redirect_to admin_category_url(@admin_category), notice: "Category was successfully updated." }
        format.json { render :show, status: :ok, location: @admin_category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/categories/1 or /admin/categories/1.json
  def destroy
    @admin_category.destroy!

    respond_to do |format|
      format.html { redirect_to admin_categories_url, notice: "Category was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_admin_category
      @admin_category =Category.find(params[:id])
    end


    def admin_category_params
      params.require(:category).permit(:name, :description, :image)
    end
end

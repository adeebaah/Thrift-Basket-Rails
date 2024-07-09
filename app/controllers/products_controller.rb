class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id])
  end

  def index
    @products = Product.all
  end

  def search
    query = params[:query]
    query_tokens = query.split.map { |token| "%#{token}%" }

    @products = Product.where(
      query_tokens.map { "name ILIKE ?" }.join(" OR "),
      *query_tokens.flat_map { |token| [token] }
    )

    render :index
  end
end

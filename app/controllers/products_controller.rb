class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  def index
    @products = Product.all
    if params[:query].present?
      sql_query = "name ILIKE :query OR description ILIKE :query"
      @products = @products.where(sql_query, query: "%#{params[:query]}%")
    end
  end

  def show
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end

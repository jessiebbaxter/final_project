class ProductsController < ApplicationController
  before_action :set_product, only: [:show]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @products = Product.all
    if params[:query].present?
      sql_query = "name ILIKE :query OR description ILIKE :query"
      @products = @products.where(sql_query, query: "%#{params[:query]}%")
    end
  end

  def show
    @varient_options = @product.varients.all.map{ |u| [ u.name, u.id ] }
    if params[:varient_id].present?
      @varient_id = params[:varient_id]
    else
      @varient_id = @product.varients.first.id
    end
    @current_varient = @product.varients.find(@varient_id)
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end

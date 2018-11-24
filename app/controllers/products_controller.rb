class ProductsController < ApplicationController
  before_action :set_product, only: [:show]
  before_action :set_price_array, only: [:index, :show]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    if params[:query].present?
      sql_query = " \
        products.name @@ :query \
        OR products.brand @@ :query \
        OR products.category @@ :query \
      "
      @products = Product.global_search(params[:query])
    else
      @products = Product.all
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

  def set_price_array
    @price_array = []
  end
end

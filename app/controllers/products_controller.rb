class ProductsController < ApplicationController
  before_action :set_product, only: [:show]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    if params[:query].present?
      sql_query = " \
        products.name @@ :query \
        OR products.brand @@ :query \
        OR products.category @@ :query \
      "
      @products = Product.where(sql_query, query: "%#{params[:query]}%")
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
end


class ProductsController < ApplicationController
  before_action :set_product, only: [:show]
  before_action :set_price_array, only: [:index, :show]

  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    if params[:query].present?
      @products = Product.global_search(params[:query]).page params[:page]
      @result_count = Product.global_search(params[:query]).count
      products_per_page = Product.page.limit_value 
      if (params[:page].nil?) || (params[:page] == 1.to_s)
        @start_count = 1
        if @result_count <= products_per_page
          @end_count = @result_count
        else
          @end_count = products_per_page
        end
      else
        @start_count = ((params[:page].to_i - 1) * products_per_page) + 1
        if (@result_count - @start_count) <= products_per_page
          @end_count = @start_count + (@result_count - @start_count)
        else
          @end_count = @start_count + products_per_page
        end
      end
    else
      @products = Product.all.page params[:page]
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

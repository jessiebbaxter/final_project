class OrdersController < ApplicationController
	before_action :set_product, only: [:show]

  def show
  end

  private

  def set_product
    @order = Order.find(params[:id])
  end
end
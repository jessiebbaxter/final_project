class OrdersController < ApplicationController
	before_action :set_product, only: [:show]
  # helper_method :finalise_total

  def show
    # @order = current_user.orders.where(state: 'paid').find(params[:id])
  end

  def complete
    @order = Order.find(params[:id])
  end

  private

  def set_product
    @order = Order.find(params[:id])
  end
end


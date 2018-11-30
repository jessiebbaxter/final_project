class OrdersController < ApplicationController
	before_action :set_product, only: [:show]

  def show
    # @order = current_user.orders.where(state: 'paid').find(params[:id])
    if @order.order_items.count > 0
      set_shipping_price
    end
  end

  def complete
    @order = Order.find(params[:id])
    set_shipping_price
  end

  private

  def set_product
    @order = Order.find(params[:id])
  end

  def set_shipping_price
    @shipping_array = []
    @shipping_list = Shipping.where(seller_id: @order.inventories.first.seller_id)
    @shipping_list.order(cost_cents: :asc).each do |ship|
      if ship.minimum_spend.to_i < @order.inventories.first.price.to_i
        @shipping_array << ship
      end
    end
    @ship = @shipping_array.first
  end
end

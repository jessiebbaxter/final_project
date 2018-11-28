class OrdersController < ApplicationController
	before_action :set_product, only: [:show]
  helper_method :finalise_total

  def show
    # @order = current_user.orders.where(state: 'paid').find(params[:id])
    set_shipping_price
  end

  def complete
    @order = Order.find(params[:id])
    set_shipping_price
  end

  private

  def set_product
    @order = Order.find(params[:id])
  end

  def finalise_total
    @order.amount = 0
    @order.order_items.each do |item|
      @order.amount += (item.inventory.price * item.qty) + @ship.cost
    end
    @order.save
  end

  def set_shipping_price
    if @order.inventories
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
end

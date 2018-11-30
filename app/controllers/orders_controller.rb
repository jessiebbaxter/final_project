class OrdersController < ApplicationController

before_action :set_product, only: [:show, :complete]
helper_method :finalise_total

  def show
    # @order = current_user.orders.where(state: 'paid').find(params[:id])
    if @order.order_items.count > 0
      set_shipping_price
    end
  end

  def complete
    set_shipping_price
    generate_quick_buy_list
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

  def generate_quick_buy_list
    @order.inventories.each do |inventory|
      already_saved = QuickBuyItem.where("user_id = ? and product_id = ? and inventory_id = ?", current_user.id, inventory.varient.product.id, inventory.id).present?
      if already_saved == false
        QuickBuyItem.create(
          user_id: current_user.id,
          product_id: inventory.varient.product.id,
          inventory_id: inventory.id
        )
      end
    end
  end
end

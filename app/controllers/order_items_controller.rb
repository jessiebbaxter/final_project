class OrderItemsController < ApplicationController
  before_action :set_order, only: [:create, :update, :destroy]

  #every time we change the dropdown for a new varient, we need to create a new inventory item? or we need to create an order_item with a varient id.

  def create
    if !@order
      @order = Order.create(user_id: current_user, state: "pending")
    end
    if @order.order_items.find_by(inventory_id: params[:inventory_id]).present?
      set_order_item
      check_order_limit
      @order_item.save
    else
      if params[:qty].nil?
        @order_item = OrderItem.create!(inventory_id: params[:inventory_id], order_id: @order.id, qty: 1)
      else
        @order_item = OrderItem.create!(inventory_id: params[:inventory_id], order_id: @order.id, qty: params[:qty])
      end
      flash[:notice] = "This item has been saved to your cart"
    end
    @order.save
    redirect_to request.referrer
  end

  def update
    @order_item = OrderItem.find(params[:id])
    @order_item.update(order_item_params)
    redirect_to order_path(@order)
  end

  def destroy
    @order_item = OrderItem.find(params[:id])
    order = @order_item.order
    @order_item.destroy
    redirect_to order_path(order)
  end

  private

  def set_order
    @order = current_user.orders.find_by(state: "pending")
  end

  def set_order_item
    @order_item = @order.order_items.find_by(inventory_id: params[:inventory_id])
  end

  def order_item_params
    params.require(:order_item).permit(:inventory_id, :order_id, :qty)
  end

  def check_order_limit
    if @order_item.qty + params[:qty].to_i > 5
      flash[:alert] = "You already have #{@order_item.qty} in your cart. The order limit per item is 5."
    else
      @order_item.qty += params[:qty].to_i
      flash[:notice] = "This item has been saved to your cart"
    end
  end
end

class OrderItemsController < ApplicationController
  before_action :set_order, only: [:create, :update, :destroy]

  def create
    if !@order
      @order = Order.create(user_id: current_user, state: "pending")
    end
    if @order.order_items.find_by(inventory_id: params[:inventory_id])
      set_order_item
      @order_item.qty += 1
      @order_item.save
    else
      @order_item = OrderItem.create!(inventory_id: params[:inventory_id], order_id: @order.id)
    end
    @order.save
    flash[:notice] = "This item has been saved to your cart"
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
end

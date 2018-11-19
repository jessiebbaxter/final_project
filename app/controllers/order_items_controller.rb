class OrderItemsController < ApplicationController
  before_action :set_order, only: [:create, :update]

  def create
  
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
    @order_item = @order.order_items.find_by(product_id: params[:product_id])
  end

  def order_item_params
    params.require(:order_item).permit(:product_id, :id, :qty)
  end
end

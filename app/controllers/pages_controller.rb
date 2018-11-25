class PagesController < ApplicationController
	skip_before_action :authenticate_user!, only: :home

  def home
  end

  def dashboard
  	quick_buy_list
  end

  def quick_buy_list
  	orders = Order.where(["user_id = ? and state = ?", current_user.id, "paid"])
 		@quick_buy_list = []
 		orders.each do |order|
 			order.inventories.each do |inventory|
 				@quick_buy_list << QuickBuyItem.create(
 					user_id: current_user.id, 
 					product_id: inventory.varient.product.id,
 					inventory_id: inventory.id
 				)
 			end
 		end
 	end

 	def add_quick_buy
    # quick_buy_item = QuickBuyItem.where(user_id: current_user)
    # @products = []
    # favorites.each do |fav|
    #   @products << Product.find(fav.product_id)
    # end
    # @products.uniq!
  end
end
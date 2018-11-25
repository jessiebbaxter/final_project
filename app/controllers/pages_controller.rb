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
 				@quick_buy_list << {
 					product: inventory.varient.product,
 					inventory: inventory
 				}
 			end
 		end
 	end
end
class PagesController < ApplicationController
	skip_before_action :authenticate_user!, only: :home

  def home
  end

  def dashboard
  	generate_quick_buy_list
  end
  
  def pricedrop  
    generate_quick_buy_list
  end

  # Need to add some of this logic to purchase - find for now
  def generate_quick_buy_list
  	orders = Order.where(["user_id = ? and state = ?", current_user.id, "paid"])
 		orders.each do |order|
 			order.inventories.each do |inventory|
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
 		@quick_buy_list = QuickBuyItem.where(user_id: current_user.id)
 	end
end
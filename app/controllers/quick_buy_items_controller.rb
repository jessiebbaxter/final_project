class QuickBuyItemsController < ApplicationController
	def create
		already_saved = QuickBuyItem.where("user_id = ? and product_id = ? and inventory_id = ?", current_user.id, params[:product_id], params[:inventory_id]).present?
 		if already_saved == false
			@quick_buy = QuickBuyItem.create(inventory_id: params[:inventory_id], product_id: params[:product_id], user_id: current_user.id)
			flash[:notice] = "This item has been saved to your quick buys"
		end

		redirect_to product_path(params[:product_id])
	end
end

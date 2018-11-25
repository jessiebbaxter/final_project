class AddInventoryToQuickBuyItems < ActiveRecord::Migration[5.2]
  def change
  	 add_reference :quick_buy_items, :inventory, index: true
  end
end

class AddInventoryToOrderItems < ActiveRecord::Migration[5.2]
  def change
  	add_reference :order_items, :inventory, index: true
  end
end

class ChangeColumnToOrderItems < ActiveRecord::Migration[5.2]
  def change
    change_column_default :order_items, :qty, 1
  end
end

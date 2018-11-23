class RemoveImageUrlFromInventory < ActiveRecord::Migration[5.2]
  def change
  	remove_column :inventories, :image_url, :string
  end
end

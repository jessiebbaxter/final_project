class AddPhotoToInventories < ActiveRecord::Migration[5.2]
  def change
  	add_column :inventories, :photo, :string
  end
end

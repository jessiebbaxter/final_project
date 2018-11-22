class RemoveDescriptionFromProducts < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :description, :string
  end
end

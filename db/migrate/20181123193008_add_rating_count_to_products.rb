class AddRatingCountToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :rating, :integer
    add_column :products, :review_count, :integer
  end
end

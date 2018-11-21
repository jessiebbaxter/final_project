class CreateInventories < ActiveRecord::Migration[5.2]
  def change
    create_table :inventories do |t|
      t.string :source_url
      t.string :image_url
      t.monetize :price, currency: { present: false }
      t.references :varient, foreign_key: true
      t.references :seller, foreign_key: true

      t.timestamps
    end
  end
end

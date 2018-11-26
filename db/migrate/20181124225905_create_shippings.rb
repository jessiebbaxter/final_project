class CreateShippings < ActiveRecord::Migration[5.2]
  def change
    create_table :shippings do |t|
      t.integer :minimum_spend
      t.integer :shipping_speed
      t.string :rule
      t.monetize :cost, currency: { present: false }
      t.references :seller, foreign_key: true

      t.timestamps
    end
  end
end

class CreateVarients < ActiveRecord::Migration[5.2]
  def change
    create_table :varients do |t|
      t.string :name
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end

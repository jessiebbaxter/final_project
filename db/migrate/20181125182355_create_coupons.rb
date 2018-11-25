class CreateCoupons < ActiveRecord::Migration[5.2]
  def change
    create_table :coupons do |t|
      t.references :seller, foreign_key: true
      t.float :discount

      t.timestamps
    end
  end
end

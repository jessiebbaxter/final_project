class AddColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :street_address, :string
    add_column :users, :suburb, :string
    add_column :users, :state, :string
    add_column :users, :post_code, :string
  end
end

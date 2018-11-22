class AddPhotoToVarients < ActiveRecord::Migration[5.2]
  def change
  	add_column :varients, :photo, :string
  end
end

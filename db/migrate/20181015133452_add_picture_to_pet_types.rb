class AddPictureToPetTypes < ActiveRecord::Migration[5.1]
  def change
    add_column :pet_types, :picture, :string
  end
end

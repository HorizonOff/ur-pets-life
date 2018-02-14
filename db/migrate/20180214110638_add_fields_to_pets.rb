class AddFieldsToPets < ActiveRecord::Migration[5.1]
  def change
    add_column :pets, :microchip, :string
    add_column :pets, :municipality_tag, :string
  end
end

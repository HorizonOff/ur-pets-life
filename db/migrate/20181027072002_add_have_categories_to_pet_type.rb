class AddHaveCategoriesToPetType < ActiveRecord::Migration[5.1]
  def change
    add_column :pet_types, :IsHaveCategories, :boolean
  end
end

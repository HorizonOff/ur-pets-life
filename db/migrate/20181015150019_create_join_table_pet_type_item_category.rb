class CreateJoinTablePetTypeItemCategory < ActiveRecord::Migration[5.1]
  def change
    create_join_table :pet_types, :item_categories do |t|
      # t.index [:pet_type_id, :item_category_id]
      # t.index [:item_category_id, :pet_type_id]
    end
  end
end

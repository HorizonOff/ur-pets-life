class AddReferencesToItem < ActiveRecord::Migration[5.1]
  def change
    add_reference :items, :item_categories, foreign_key: true
    add_reference :items, :pet_type, foreign_key: true
  end
end

class AddJoinTablesToItems < ActiveRecord::Migration[5.1]
  def up
    create_join_table :items, :item_categories do |t|
      t.index [:item_id, :item_category_id]
    end
    create_join_table :items, :pet_types do |t|
      t.index [:item_id, :pet_type_id]
    end
    Item.class_eval do
      belongs_to :single_item_category, class_name: "ItemCategory", foreign_key: "item_categories_id"
      belongs_to :single_pet_type, class_name: "PetType", foreign_key: "pet_type_id"
    end
    Item.find_each do |item|
      unless item.single_item_category.nil?
        item.item_categories << item.single_item_category
        item.save
      end
      unless item.single_pet_type.nil?
        item.pet_types << item.single_pet_type
        item.save
      end
    end
  end

  def down
    drop_join_table :items, :item_categories
    drop_join_table :items, :pet_types
  end
end

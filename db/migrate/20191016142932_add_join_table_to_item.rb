class AddJoinTableToItem < ActiveRecord::Migration[5.1]
  def up
    create_join_table :items, :item_brands do |t|
      t.index [:item_id, :item_brand_id]
    end

    Item.class_eval do
      belongs_to :single_item_brand, class_name: "ItemBrand", foreign_key: "item_brand_id"
    end

    Item.find_each do |item|
      unless item.single_item_brand.nil?
        item.item_brand << item.single_item_brand
        item.save
      end
    end
  end

  def down
    drop_join_table :items, :item_brands
  end
end

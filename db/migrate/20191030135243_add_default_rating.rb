class AddDefaultRating < ActiveRecord::Migration[5.2]
  def up
    change_column :items, :avg_rating, :integer, default: 0

    Item.where(price: nil).each do |item|
      price = item.unit_price
      item.update_columns(price: price)
    end

    Item.where(avg_rating: nil).update_all(avg_rating: 0)

  end

  def down
    change_column :items, :avg_rating, :integer
  end
end

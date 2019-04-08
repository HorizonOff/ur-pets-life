class AddColumnToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :avg_rating, :integer
  end
end

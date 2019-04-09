class AddReviewCountToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :review_count, :integer
  end
end

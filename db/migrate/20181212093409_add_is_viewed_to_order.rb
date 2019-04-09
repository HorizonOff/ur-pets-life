class AddIsViewedToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :is_viewed, :boolean
  end
end

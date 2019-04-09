class AddColumnToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :earned_points, :integer
  end
end

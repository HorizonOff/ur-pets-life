class AddColumnsToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :RedeemPoints, :integer
    add_column :orders, :TransactionId, :string
    add_column :orders, :TransactionDate, :datetime
  end
end

class AddTransactionColumnToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :last_transaction_ref, :string
    add_column :users, :last_transaction_date, :datetime
  end
end

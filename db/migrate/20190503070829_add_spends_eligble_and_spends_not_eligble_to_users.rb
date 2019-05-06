class AddSpendsEligbleAndSpendsNotEligbleToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :spends_eligble, :float, null: false, default: 0
    add_column :users, :spends_not_eligble, :float, null: false, default: 0
  end
end

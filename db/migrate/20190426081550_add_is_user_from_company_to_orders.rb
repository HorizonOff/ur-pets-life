class AddIsUserFromCompanyToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :is_user_from_company, :boolean, default: false
  end
end

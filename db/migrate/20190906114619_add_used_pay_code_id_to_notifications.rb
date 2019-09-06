class AddUsedPayCodeIdToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :used_pay_code_id, :integer
    add_index :notifications, :used_pay_code_id
  end
end

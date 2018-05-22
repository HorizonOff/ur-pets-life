class AddFieldsToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :is_for_vaccine, :boolean, default: false
  end
end

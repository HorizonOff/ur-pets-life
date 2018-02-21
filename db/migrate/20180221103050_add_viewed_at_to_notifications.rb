class AddViewedAtToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :viewed_at, :datetime

    add_index :notifications, :viewed_at
  end
end

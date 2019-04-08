class AddOrderRefToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_reference :notifications, :order, foreign_key: true
  end
end

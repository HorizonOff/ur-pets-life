class AddCountersToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :unread_comments_count_by_user, :integer, null: false, default: 0
    add_column :orders, :unread_comments_count_by_admin, :integer, null: false, default: 0
    add_column :orders, :comments_count, :integer, null: false, default: 0
  end
end

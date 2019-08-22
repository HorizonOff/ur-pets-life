class AddUnreadMessageCountToSupportChats < ActiveRecord::Migration[5.2]
  def change
    add_column :support_chats, :unread_message_count_by_user, :integer, default: 0
    add_column :support_chats, :unread_message_count_by_admin, :integer, default: 0
  end
end

class AddSystemTypeToChatMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :chat_messages, :system_type, :integer
  end
end

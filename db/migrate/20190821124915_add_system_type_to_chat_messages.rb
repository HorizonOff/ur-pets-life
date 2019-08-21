class AddSystemTypeToChatMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :chat_message, :system_type, :integer
  end
end

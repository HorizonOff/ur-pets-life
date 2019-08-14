class CreateChatMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :chat_messages do |t|
      t.references :user
      t.references :support_chat
      t.integer :m_type
      t.string :text
      t.string :photo
      t.string :video
      t.float :video_duration
      t.string :mobile_photo_url
      t.string :mobile_video_url
      t.integer :status, default: 1
      t.string :error_message

      t.timestamps
    end
  end
end

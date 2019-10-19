class CreateSupportChats < ActiveRecord::Migration[5.1]
  def change
    create_table :support_chats do |t|
      t.references :user
      t.string :path
      t.integer :status, default: 0

      t.timestamps
    end
  end
end

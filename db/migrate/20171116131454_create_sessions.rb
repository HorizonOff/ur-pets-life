class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.string :token
      t.string :device_type
      t.string :device_id
      t.string :push_token
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :sessions, :token, unique: true
  end
end

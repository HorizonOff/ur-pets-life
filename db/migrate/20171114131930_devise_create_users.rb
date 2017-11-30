class DeviseCreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      ## Database authenticatable
      t.string :email
      t.string :mobile_number
      t.string :encrypted_password, null: false, default: ''

      t.string :facebook_id
      t.string :google_id
      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.integer  :sign_in_count, default: 0, null: false
      # t.string   :unconfirmed_email # Only if using reconfirmable

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :facebook_id,          unique: true
    add_index :users, :google_id,            unique: true
  end
end

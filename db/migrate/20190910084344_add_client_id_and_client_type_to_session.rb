class AddClientIdAndClientTypeToSession < ActiveRecord::Migration[5.1]
  def up
    add_column :sessions, :client_id, :integer
    add_column :sessions, :client_type, :string

    add_index :sessions, :client_id
    add_index :sessions, :client_type

    Session.find_each do |session|
      session.update_column(:client_id, session.user_id)
      session.update_column(:client_type, 'User')
    end

    remove_column :sessions, :user_id
  end

  def down
    add_column :sessions, :user_id, :integer

    Session.find_each do |session|
      session.update_column(:user_id, session.client_id)
    end

    remove_column :sessions, :client_id
    remove_column :sessions, :client_type
  end
end

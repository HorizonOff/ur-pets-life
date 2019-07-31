class AddLastActionAtToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :last_action_at, :datetime
  end
end

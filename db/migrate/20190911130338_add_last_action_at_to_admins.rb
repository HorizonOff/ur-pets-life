class AddLastActionAtToAdmins < ActiveRecord::Migration[5.1]
  def change
    add_column :admins, :last_action_at, :datetime
  end
end

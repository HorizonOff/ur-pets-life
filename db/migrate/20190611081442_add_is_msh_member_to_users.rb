class AddIsMshMemberToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_msh_member, :boolean, default: false
  end
end

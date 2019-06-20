class AddMemberTypeToUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :is_msh_member
    add_column :users, :member_type, :integer, default: 0
  end
end

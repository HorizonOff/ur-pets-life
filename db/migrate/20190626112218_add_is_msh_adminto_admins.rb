class AddIsMshAdmintoAdmins < ActiveRecord::Migration[5.1]
  def change
    add_column :admins, :is_msh_admin, :boolean, default: false
  end
end

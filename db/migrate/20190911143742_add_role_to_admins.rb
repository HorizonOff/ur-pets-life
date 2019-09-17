class AddRoleToAdmins < ActiveRecord::Migration[5.1]
  def up
    add_column :admins, :role, :integer
    Admin.find_each do |admin|
      if admin.is_super_admin?
        admin.update_column(:role, 1)
      elsif admin.is_employee?
        admin.update_column(:role, 2)
      elsif admin.is_cataloger?
        admin.update_column(:role, 3)
      elsif admin.is_msh_admin?
        admin.update_column(:role, 4)
      else
        admin.update_column(:role, 0)
      end
    end
  end

  def down
    remove_column :admins, :role
  end
end

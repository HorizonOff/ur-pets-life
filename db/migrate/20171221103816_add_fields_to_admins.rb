class AddFieldsToAdmins < ActiveRecord::Migration[5.1]
  def change
    add_column :admins, :is_super_admin, :boolean, default: false
    add_column :admins, :avatar, :string
    add_column :admins, :name, :string
  end
end

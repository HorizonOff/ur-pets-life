class AddIsCatalogerToAdmins < ActiveRecord::Migration[5.1]
  def change
    add_column :admins, :is_cataloger, :boolean, default: false
  end
end

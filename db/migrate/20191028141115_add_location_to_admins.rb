class AddLocationToAdmins < ActiveRecord::Migration[5.2]
  def up
    add_column :admins, :lng, :float
    add_column :admins, :lat, :float
  end

  def down
    remove_column :admins, :lng
    remove_column :admins, :lat
  end
end

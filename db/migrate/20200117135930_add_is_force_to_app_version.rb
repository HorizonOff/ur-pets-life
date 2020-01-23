class AddIsForceToAppVersion < ActiveRecord::Migration[5.2]
  def change
    add_column :app_versions, :force_update, :boolean, null: false, default: false
  end
end

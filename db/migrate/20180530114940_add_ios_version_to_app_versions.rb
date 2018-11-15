class AddIosVersionToAppVersions < ActiveRecord::Migration[5.1]
  def change
    add_column :app_versions, :ios_version, :string
  end
end

class CreateAppVersions < ActiveRecord::Migration[5.1]
  def change
    create_table :app_versions do |t|
      t.string :android_version

      t.timestamps
    end

    AppVersion.create
  end
end

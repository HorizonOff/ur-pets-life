class AddParanoiaToModels < ActiveRecord::Migration[5.1]
  def change
    add_column :users,            :deleted_at, :datetime
    add_column :admins,           :deleted_at, :datetime
    add_column :pets,             :deleted_at, :datetime
    add_column :clinics,          :deleted_at, :datetime
    add_column :day_care_centres, :deleted_at, :datetime
    add_column :grooming_centres, :deleted_at, :datetime
    add_column :trainers,         :deleted_at, :datetime
    add_column :vets,             :deleted_at, :datetime
    add_column :appointments,     :deleted_at, :datetime
    add_column :posts,            :deleted_at, :datetime
    add_column :comments,         :deleted_at, :datetime
    add_column :service_types,    :deleted_at, :datetime
    add_column :service_details,  :deleted_at, :datetime
    add_column :locations,        :deleted_at, :datetime
    add_column :schedules,        :deleted_at, :datetime

    add_index :users,            :deleted_at
    add_index :admins,           :deleted_at
    add_index :pets,             :deleted_at
    add_index :clinics,          :deleted_at
    add_index :day_care_centres, :deleted_at
    add_index :grooming_centres, :deleted_at
    add_index :trainers,         :deleted_at
    add_index :vets,             :deleted_at
    add_index :appointments,     :deleted_at
    add_index :posts,            :deleted_at
    add_index :comments,         :deleted_at
    add_index :service_types,    :deleted_at
    add_index :service_details,  :deleted_at
    add_index :locations,        :deleted_at
    add_index :schedules,        :deleted_at
  end
end

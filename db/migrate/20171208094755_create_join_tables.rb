class CreateJoinTables < ActiveRecord::Migration[5.1]
  def change
  	create_join_table :pet_types, :vaccine_types
    create_join_table :pet_types, :vets

    create_join_table :clinics, :pet_types
    create_join_table :clinics, :specializations

    create_join_table :specializations, :vets

    create_join_table :day_care_centres, :pet_types
    create_join_table :day_care_centres, :service_options

    create_join_table :grooming_centres, :pet_types
    create_join_table :grooming_centres, :service_options
  end
end

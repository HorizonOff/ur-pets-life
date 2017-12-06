class CreateJoinTables < ActiveRecord::Migration[5.1]
  def change
    create_join_table :clinics, :pet_types
    create_join_table :clinics, :specializations
  end
end

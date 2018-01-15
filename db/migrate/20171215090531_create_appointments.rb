class CreateAppointments < ActiveRecord::Migration[5.1]
  def change
    create_table :appointments do |t|
      t.references :user, foreign_key: true
      t.references :bookable, polymorphic: true
      t.references :pet, foreign_key: true
      t.references :vet, foreign_key: true
      t.references :calendar, foreign_key: true
      t.string :comment
      t.datetime :start_at
      t.datetime :end_at
      t.integer :status
      t.integer :total_price

      t.timestamps
    end

    create_join_table :appointments, :service_details
  end
end

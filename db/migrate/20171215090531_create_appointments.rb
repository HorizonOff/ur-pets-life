class CreateAppointments < ActiveRecord::Migration[5.1]
  def change
    create_table :appointments do |t|
      t.references :user, foreign_key: true
      t.references :bookable, polymorphic: true
      t.references :pet, foreign_key: true
      t.references :vet, foreign_key: true
      t.string :comment
      t.datetime :booked_at
      t.integer :status

      t.timestamps
    end
  end
end

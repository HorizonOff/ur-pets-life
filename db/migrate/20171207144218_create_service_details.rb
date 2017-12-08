class CreateServiceDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :service_details do |t|
      t.references :service_type, foreign_key: true
      t.references :pet_type, foreign_key: true
      t.integer :price

      t.timestamps
    end
  end
end

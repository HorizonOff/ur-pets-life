class CreateServiceTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :service_types do |t|
      t.string :name
      t.text :description
      t.references :grooming_centre, foreign_key: true

      t.timestamps
    end
  end
end

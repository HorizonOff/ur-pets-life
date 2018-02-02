class CreateServiceTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :service_types do |t|
      t.string :name
      t.text :description
      t.references :serviceable, polymorphic: true
      t.boolean :is_active, default: true

      t.timestamps

      t.index :is_active
    end
  end
end

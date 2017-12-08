class CreateDayCareCentres < ActiveRecord::Migration[5.1]
  def change
    create_table :day_care_centres do |t|
      t.string :name
      t.string :email
      t.string :picture
      t.string :mobile_number
      t.string :website
      t.text :description
      t.boolean :is_active

      t.timestamps
    end
  end
end

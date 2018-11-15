class CreateQualifications < ActiveRecord::Migration[5.1]
  def change
    create_table :qualifications do |t|
      t.references :skill, polymorphic: true
      t.string :diploma
      t.string :university

      t.timestamps
    end
  end
end

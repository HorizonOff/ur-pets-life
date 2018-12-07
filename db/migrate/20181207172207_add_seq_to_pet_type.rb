class AddSeqToPetType < ActiveRecord::Migration[5.1]
  def change
    add_column :pet_types, :seq, :integer
  end
end

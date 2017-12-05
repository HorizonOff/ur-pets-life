class AddBooleansToPets < ActiveRecord::Migration[5.1]
  def change
    add_column :pets, :is_lost, :boolean, default: false
    add_column :pets, :is_for_adoption, :boolean, default: false
  end
end

class AddColumnToAdmin < ActiveRecord::Migration[5.1]
  def change
    add_column :admins, :is_employee, :boolean, :default => false
  end
end

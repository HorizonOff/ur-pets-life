class AddColumnToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :short_description, :string
  end
end

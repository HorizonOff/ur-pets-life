class AddExpiryAtToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :expiry_at, :datetime
  end
end

class AddAppleIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :apple_id, :string
  end
end

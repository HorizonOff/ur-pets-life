class AddAppleIdToUser < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :apple_id, :string
  end

  def down
    remove_column :users, :apple_id
  end
end

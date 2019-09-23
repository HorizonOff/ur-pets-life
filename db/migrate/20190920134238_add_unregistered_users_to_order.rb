class AddUnregisteredUsersToOrder < ActiveRecord::Migration[5.1]
  def up
    add_column :orders, :unregistered_user_id, :integer
    o = Order.where.not(client_name: nil)
    o.each do |order|
      UnregisteredUser.create(name: order.client_name, number: order.client_number)
      user = UnregisteredUser.last
      order.update(unregistered_user_id: user.id)
    end
    remove_column :orders, :client_name
    remove_column :orders, :client_number
  end

  def down
    add_column :orders, :client_name, :string
    add_column :orders, :client_number, :string
    o = Order.where.not(unregistered_user_id: nil)
    o.each do |order|
      user = UnregisteredUser.find(order.unregistered_user_id)
      order.update(client_name: user.name, client_number: user.number)
    end
    remove_column :orders, :unregistered_user_id
  end
end

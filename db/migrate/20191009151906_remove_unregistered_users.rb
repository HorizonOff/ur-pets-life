class RemoveUnregisteredUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :registered_user, :boolean, default: true

    orders = Order.joins(:unregistered_user)

    orders.find_each do |order|
      unreg_user = order.unregistered_user
      user = User.find_by(mobile_number: unreg_user.number)

      next if user.blank? == false

      user = User.new(registered_user: false, first_name: unreg_user.name, mobile_number: unreg_user.number)
      user.skip_user_validation = true
      user.save!
      order.update_columns(user_id: user.id)
    end

    remove_column :orders, :unregistered_user_id
    drop_table :unregistered_users
  end

  def down
    create_table :unregistered_users do |t|
      t.string :name
      t.string :number

      t.timestamps
    end

    add_column :orders, :unregistered_user_id, :integer

    orders = Order.joins(:user).where(users: { registered_user: false })
    orders.each do |order|
      user = order.user
      unreg_user = UnregisteredUser.find_or_create_by(name: user.first_name, number: user.mobile_number)

      order.update_columns(unregistered_user_id: unreg_user.id)
    end

    remove_column :users, :registered_user
  end
end

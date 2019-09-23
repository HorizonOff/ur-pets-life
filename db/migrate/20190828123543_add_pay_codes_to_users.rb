class AddPayCodesToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :pay_code, :string
    User.joins(:orders)
        .where(orders: { order_status_flag: ['delivered', 'delivered_by_card', 'delivered_by_cash'] })
        .distinct.each do |user|
      user.generate_pay_code
    end
  end

  def down
    remove_column :users, :pay_code
  end
end

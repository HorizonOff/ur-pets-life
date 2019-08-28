class AddPayCodesToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :pay_code, :string
    User.joins(:redeem_point).where('redeem_points.net_worth > 0').each do |user|
      user.pay_code = "%04d" % [user.id]
    end
  end

  def down
    remove_column :users, :pay_code
  end
end

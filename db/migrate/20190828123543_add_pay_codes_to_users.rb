class AddPayCodesToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :pay_code, :string
    User.joins(:redeem_point).each do |user|
      user.update_column(:pay_code, "%04d" % [user.id+9])
    end
  end

  def down
    remove_column :users, :pay_code
  end
end

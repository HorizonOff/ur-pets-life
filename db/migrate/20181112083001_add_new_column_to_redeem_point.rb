class AddNewColumnToRedeemPoint < ActiveRecord::Migration[5.1]
  def change
    add_column :redeem_points, :totalearnedpoints, :integer
    add_column :redeem_points, :totalavailedpoints, :integer
  end
end

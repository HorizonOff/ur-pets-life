class AddShipmentTimeToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :shipmenttime, :string
  end
end

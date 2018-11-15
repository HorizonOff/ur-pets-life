class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.references :location, foreign_key: true
      t.datetime :Delivery_Date
      t.string :Order_Notes
      t.integer :Subtotal       
      t.integer :Delivery_Charges
      t.integer :Vat_Charges
      t.integer :Total
      t.boolean :IsCash
      t.integer :Order_Status
      t.integer :Payment_Status

      t.timestamps
    end
  end
end

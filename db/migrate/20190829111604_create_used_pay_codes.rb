class CreateUsedPayCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :used_pay_codes do |t|
      t.references :user, foreign_key: true
      t.references :order, foreign_key: true
      t.integer :code_user_id

      t.index :code_user_id
      t.timestamps
    end
  end
end

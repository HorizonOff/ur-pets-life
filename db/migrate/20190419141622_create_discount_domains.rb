class CreateDiscountDomains < ActiveRecord::Migration[5.1]
  def change
    create_table :discount_domains do |t|
      t.string :domain
      t.integer :discount

      t.timestamps
    end
  end
end

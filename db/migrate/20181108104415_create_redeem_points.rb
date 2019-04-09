class CreateRedeemPoints < ActiveRecord::Migration[5.1]
  def change
    create_table :redeem_points do |t|
      t.integer :net_worth
      t.integer :last_net_worth
      t.string :last_reward_type
      t.integer :last_reward_worth
      t.datetime :last_reward_update
      t.datetime :last_net_update
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

class RedeemPointSerializer < ActiveModel::Serializer
  attributes :id, :net_worth, :last_net_worth, :last_reward_type, :last_reward_worth, :last_reward_update, :last_net_update
  has_one :user
end

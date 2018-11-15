FactoryBot.define do
  factory :redeem_point do
    net_worth { 1 }
    last_net_worth { 1 }
    last_reward_type { "MyString" }
    last_reward_worth { 1 }
    last_reward_update { "2018-11-08 10:44:54" }
    last_net_update { "2018-11-08 10:44:54" }
    user { nil }
  end
end

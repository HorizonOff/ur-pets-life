require 'rails_helper'

RSpec.describe "redeem_points/index", type: :view do
  before(:each) do
    assign(:redeem_points, [
      RedeemPoint.create!(
        :net_worth => 2,
        :last_net_worth => 3,
        :last_reward_type => "Last Reward Type",
        :last_reward_worth => 4,
        :user => nil
      ),
      RedeemPoint.create!(
        :net_worth => 2,
        :last_net_worth => 3,
        :last_reward_type => "Last Reward Type",
        :last_reward_worth => 4,
        :user => nil
      )
    ])
  end

  it "renders a list of redeem_points" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Last Reward Type".to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end

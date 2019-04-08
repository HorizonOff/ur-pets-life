require 'rails_helper'

RSpec.describe "redeem_points/show", type: :view do
  before(:each) do
    @redeem_point = assign(:redeem_point, RedeemPoint.create!(
      :net_worth => 2,
      :last_net_worth => 3,
      :last_reward_type => "Last Reward Type",
      :last_reward_worth => 4,
      :user => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Last Reward Type/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(//)
  end
end

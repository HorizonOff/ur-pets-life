require 'rails_helper'

RSpec.describe "redeem_points/new", type: :view do
  before(:each) do
    assign(:redeem_point, RedeemPoint.new(
      :net_worth => 1,
      :last_net_worth => 1,
      :last_reward_type => "MyString",
      :last_reward_worth => 1,
      :user => nil
    ))
  end

  it "renders new redeem_point form" do
    render

    assert_select "form[action=?][method=?]", redeem_points_path, "post" do

      assert_select "input[name=?]", "redeem_point[net_worth]"

      assert_select "input[name=?]", "redeem_point[last_net_worth]"

      assert_select "input[name=?]", "redeem_point[last_reward_type]"

      assert_select "input[name=?]", "redeem_point[last_reward_worth]"

      assert_select "input[name=?]", "redeem_point[user_id]"
    end
  end
end

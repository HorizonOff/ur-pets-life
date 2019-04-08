require 'rails_helper'

RSpec.describe "recurssion_intervals/index", type: :view do
  before(:each) do
    assign(:recurssion_intervals, [
      RecurssionInterval.create!(
        :weeks => 2,
        :days => 3
      ),
      RecurssionInterval.create!(
        :weeks => 2,
        :days => 3
      )
    ])
  end

  it "renders a list of recurssion_intervals" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end

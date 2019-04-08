require 'rails_helper'

RSpec.describe "recurssion_intervals/new", type: :view do
  before(:each) do
    assign(:recurssion_interval, RecurssionInterval.new(
      :weeks => 1,
      :days => 1
    ))
  end

  it "renders new recurssion_interval form" do
    render

    assert_select "form[action=?][method=?]", recurssion_intervals_path, "post" do

      assert_select "input[name=?]", "recurssion_interval[weeks]"

      assert_select "input[name=?]", "recurssion_interval[days]"
    end
  end
end

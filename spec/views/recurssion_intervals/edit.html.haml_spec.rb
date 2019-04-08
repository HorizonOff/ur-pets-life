require 'rails_helper'

RSpec.describe "recurssion_intervals/edit", type: :view do
  before(:each) do
    @recurssion_interval = assign(:recurssion_interval, RecurssionInterval.create!(
      :weeks => 1,
      :days => 1
    ))
  end

  it "renders the edit recurssion_interval form" do
    render

    assert_select "form[action=?][method=?]", recurssion_interval_path(@recurssion_interval), "post" do

      assert_select "input[name=?]", "recurssion_interval[weeks]"

      assert_select "input[name=?]", "recurssion_interval[days]"
    end
  end
end

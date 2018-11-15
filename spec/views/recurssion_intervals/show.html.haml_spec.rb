require 'rails_helper'

RSpec.describe "recurssion_intervals/show", type: :view do
  before(:each) do
    @recurssion_interval = assign(:recurssion_interval, RecurssionInterval.create!(
      :weeks => 2,
      :days => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end

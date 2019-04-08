require 'rails_helper'

RSpec.describe "order_items/index", type: :view do
  before(:each) do
    assign(:order_items, [
      OrderItem.create!(
        :order => nil,
        :item => nil,
        :Quantity => 2,
        :Unit_Price => 3,
        :Total_Price => 4
      ),
      OrderItem.create!(
        :order => nil,
        :item => nil,
        :Quantity => 2,
        :Unit_Price => 3,
        :Total_Price => 4
      )
    ])
  end

  it "renders a list of order_items" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end

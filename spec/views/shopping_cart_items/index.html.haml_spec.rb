require 'rails_helper'

RSpec.describe "shopping_cart_items/index", type: :view do
  before(:each) do
    assign(:shopping_cart_items, [
      ShoppingCartItem.create!(
        :IsRecurring => false,
        :Interval => 2,
        :quantity => 3,
        :item => nil,
        :user => nil
      ),
      ShoppingCartItem.create!(
        :IsRecurring => false,
        :Interval => 2,
        :quantity => 3,
        :item => nil,
        :user => nil
      )
    ])
  end

  it "renders a list of shopping_cart_items" do
    render
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end

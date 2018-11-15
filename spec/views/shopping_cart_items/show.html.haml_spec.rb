require 'rails_helper'

RSpec.describe "shopping_cart_items/show", type: :view do
  before(:each) do
    @shopping_cart_item = assign(:shopping_cart_item, ShoppingCartItem.create!(
      :IsRecurring => false,
      :Interval => 2,
      :quantity => 3,
      :item => nil,
      :user => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/false/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end

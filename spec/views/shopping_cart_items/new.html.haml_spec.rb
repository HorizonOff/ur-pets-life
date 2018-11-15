require 'rails_helper'

RSpec.describe "shopping_cart_items/new", type: :view do
  before(:each) do
    assign(:shopping_cart_item, ShoppingCartItem.new(
      :IsRecurring => false,
      :Interval => 1,
      :quantity => 1,
      :item => nil,
      :user => nil
    ))
  end

  it "renders new shopping_cart_item form" do
    render

    assert_select "form[action=?][method=?]", shopping_cart_items_path, "post" do

      assert_select "input[name=?]", "shopping_cart_item[IsRecurring]"

      assert_select "input[name=?]", "shopping_cart_item[Interval]"

      assert_select "input[name=?]", "shopping_cart_item[quantity]"

      assert_select "input[name=?]", "shopping_cart_item[item_id]"

      assert_select "input[name=?]", "shopping_cart_item[user_id]"
    end
  end
end

require 'rails_helper'

RSpec.describe "order_items/new", type: :view do
  before(:each) do
    assign(:order_item, OrderItem.new(
      :order => nil,
      :item => nil,
      :Quantity => 1,
      :Unit_Price => 1,
      :Total_Price => 1
    ))
  end

  it "renders new order_item form" do
    render

    assert_select "form[action=?][method=?]", order_items_path, "post" do

      assert_select "input[name=?]", "order_item[order_id]"

      assert_select "input[name=?]", "order_item[item_id]"

      assert_select "input[name=?]", "order_item[Quantity]"

      assert_select "input[name=?]", "order_item[Unit_Price]"

      assert_select "input[name=?]", "order_item[Total_Price]"
    end
  end
end

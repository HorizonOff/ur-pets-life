require 'rails_helper'

RSpec.describe "items/new", type: :view do
  before(:each) do
    assign(:item, Item.new(
      :name => "MyString",
      :price => 1,
      :discount => 1,
      :weight => 1,
      :unit => ""
    ))
  end

  it "renders new item form" do
    render

    assert_select "form[action=?][method=?]", items_path, "post" do

      assert_select "input[name=?]", "item[name]"

      assert_select "input[name=?]", "item[price]"

      assert_select "input[name=?]", "item[discount]"

      assert_select "input[name=?]", "item[weight]"

      assert_select "input[name=?]", "item[unit]"
    end
  end
end

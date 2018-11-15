require 'rails_helper'

RSpec.describe "items/edit", type: :view do
  before(:each) do
    @item = assign(:item, Item.create!(
      :name => "MyString",
      :price => 1,
      :discount => 1,
      :weight => 1,
      :unit => ""
    ))
  end

  it "renders the edit item form" do
    render

    assert_select "form[action=?][method=?]", item_path(@item), "post" do

      assert_select "input[name=?]", "item[name]"

      assert_select "input[name=?]", "item[price]"

      assert_select "input[name=?]", "item[discount]"

      assert_select "input[name=?]", "item[weight]"

      assert_select "input[name=?]", "item[unit]"
    end
  end
end

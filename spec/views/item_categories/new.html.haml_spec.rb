require 'rails_helper'

RSpec.describe "item_categories/new", type: :view do
  before(:each) do
    assign(:item_category, ItemCategory.new(
      :name => "MyString",
      :picture => "MyString"
    ))
  end

  it "renders new item_category form" do
    render

    assert_select "form[action=?][method=?]", item_categories_path, "post" do

      assert_select "input[name=?]", "item_category[name]"

      assert_select "input[name=?]", "item_category[picture]"
    end
  end
end

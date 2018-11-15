require 'rails_helper'

RSpec.describe "item_categories/edit", type: :view do
  before(:each) do
    @item_category = assign(:item_category, ItemCategory.create!(
      :name => "MyString",
      :picture => "MyString"
    ))
  end

  it "renders the edit item_category form" do
    render

    assert_select "form[action=?][method=?]", item_category_path(@item_category), "post" do

      assert_select "input[name=?]", "item_category[name]"

      assert_select "input[name=?]", "item_category[picture]"
    end
  end
end

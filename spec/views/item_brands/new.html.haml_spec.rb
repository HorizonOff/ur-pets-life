require 'rails_helper'

RSpec.describe "item_brands/new", type: :view do
  before(:each) do
    assign(:item_brand, ItemBrand.new(
      :name => "MyString"
    ))
  end

  it "renders new item_brand form" do
    render

    assert_select "form[action=?][method=?]", item_brands_path, "post" do

      assert_select "input[name=?]", "item_brand[name]"
    end
  end
end

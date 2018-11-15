require 'rails_helper'

RSpec.describe "item_brands/edit", type: :view do
  before(:each) do
    @item_brand = assign(:item_brand, ItemBrand.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit item_brand form" do
    render

    assert_select "form[action=?][method=?]", item_brand_path(@item_brand), "post" do

      assert_select "input[name=?]", "item_brand[name]"
    end
  end
end

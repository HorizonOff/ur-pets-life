require 'rails_helper'

RSpec.describe "item_brands/show", type: :view do
  before(:each) do
    @item_brand = assign(:item_brand, ItemBrand.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end

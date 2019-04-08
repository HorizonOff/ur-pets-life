require 'rails_helper'

RSpec.describe "item_brands/index", type: :view do
  before(:each) do
    assign(:item_brands, [
      ItemBrand.create!(
        :name => "Name"
      ),
      ItemBrand.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of item_brands" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end

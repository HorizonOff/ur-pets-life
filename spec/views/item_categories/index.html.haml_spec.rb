require 'rails_helper'

RSpec.describe "item_categories/index", type: :view do
  before(:each) do
    assign(:item_categories, [
      ItemCategory.create!(
        :name => "Name",
        :picture => "Picture"
      ),
      ItemCategory.create!(
        :name => "Name",
        :picture => "Picture"
      )
    ])
  end

  it "renders a list of item_categories" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Picture".to_s, :count => 2
  end
end

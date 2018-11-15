require 'rails_helper'

RSpec.describe "wishlists/show", type: :view do
  before(:each) do
    @wishlist = assign(:wishlist, Wishlist.create!(
      :user => nil,
      :item => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end

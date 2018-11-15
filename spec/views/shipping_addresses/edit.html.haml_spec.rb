require 'rails_helper'

RSpec.describe "shipping_addresses/edit", type: :view do
  before(:each) do
    @shipping_address = assign(:shipping_address, ShippingAddress.create!())
  end

  it "renders the edit shipping_address form" do
    render

    assert_select "form[action=?][method=?]", shipping_address_path(@shipping_address), "post" do
    end
  end
end

require 'rails_helper'

RSpec.describe "shipping_addresses/new", type: :view do
  before(:each) do
    assign(:shipping_address, ShippingAddress.new())
  end

  it "renders new shipping_address form" do
    render

    assert_select "form[action=?][method=?]", shipping_addresses_path, "post" do
    end
  end
end

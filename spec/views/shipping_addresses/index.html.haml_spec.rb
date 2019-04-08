require 'rails_helper'

RSpec.describe "shipping_addresses/index", type: :view do
  before(:each) do
    assign(:shipping_addresses, [
      ShippingAddress.create!(),
      ShippingAddress.create!()
    ])
  end

  it "renders a list of shipping_addresses" do
    render
  end
end

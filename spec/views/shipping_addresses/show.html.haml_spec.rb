require 'rails_helper'

RSpec.describe "shipping_addresses/show", type: :view do
  before(:each) do
    @shipping_address = assign(:shipping_address, ShippingAddress.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end

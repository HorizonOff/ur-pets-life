require 'rails_helper'

RSpec.describe "orders/show", type: :view do
  before(:each) do
    @order = assign(:order, Order.create!(
      :references => "",
      :references => "",
      :Order_Notes => "",
      :Delivery_Charges => 2,
      :Vat_Charges => 3,
      :Total => 4,
      :IsCash => false,
      :Order_Status => 5,
      :Payment_Status => 6
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
  end
end

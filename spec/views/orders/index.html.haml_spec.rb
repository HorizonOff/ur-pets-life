require 'rails_helper'

RSpec.describe "orders/index", type: :view do
  before(:each) do
    assign(:orders, [
      Order.create!(
        :references => "",
        :references => "",
        :Order_Notes => "",
        :Delivery_Charges => 2,
        :Vat_Charges => 3,
        :Total => 4,
        :IsCash => false,
        :Order_Status => 5,
        :Payment_Status => 6
      ),
      Order.create!(
        :references => "",
        :references => "",
        :Order_Notes => "",
        :Delivery_Charges => 2,
        :Vat_Charges => 3,
        :Total => 4,
        :IsCash => false,
        :Order_Status => 5,
        :Payment_Status => 6
      )
    ])
  end

  it "renders a list of orders" do
    render
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
  end
end

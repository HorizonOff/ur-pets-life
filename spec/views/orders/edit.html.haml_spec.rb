require 'rails_helper'

RSpec.describe "orders/edit", type: :view do
  before(:each) do
    @order = assign(:order, Order.create!(
      :references => "",
      :references => "",
      :Order_Notes => "",
      :Delivery_Charges => 1,
      :Vat_Charges => 1,
      :Total => 1,
      :IsCash => false,
      :Order_Status => 1,
      :Payment_Status => 1
    ))
  end

  it "renders the edit order form" do
    render

    assert_select "form[action=?][method=?]", order_path(@order), "post" do

      assert_select "input[name=?]", "order[references]"

      assert_select "input[name=?]", "order[references]"

      assert_select "input[name=?]", "order[Order_Notes]"

      assert_select "input[name=?]", "order[Delivery_Charges]"

      assert_select "input[name=?]", "order[Vat_Charges]"

      assert_select "input[name=?]", "order[Total]"

      assert_select "input[name=?]", "order[IsCash]"

      assert_select "input[name=?]", "order[Order_Status]"

      assert_select "input[name=?]", "order[Payment_Status]"
    end
  end
end

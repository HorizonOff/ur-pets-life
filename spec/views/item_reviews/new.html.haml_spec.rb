require 'rails_helper'

RSpec.describe "item_reviews/new", type: :view do
  before(:each) do
    assign(:item_review, ItemReview.new(
      :user => nil,
      :item => nil,
      :rating => 1,
      :comment => "MyString"
    ))
  end

  it "renders new item_review form" do
    render

    assert_select "form[action=?][method=?]", item_reviews_path, "post" do

      assert_select "input[name=?]", "item_review[user_id]"

      assert_select "input[name=?]", "item_review[item_id]"

      assert_select "input[name=?]", "item_review[rating]"

      assert_select "input[name=?]", "item_review[comment]"
    end
  end
end

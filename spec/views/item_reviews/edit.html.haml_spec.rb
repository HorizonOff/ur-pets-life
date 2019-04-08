require 'rails_helper'

RSpec.describe "item_reviews/edit", type: :view do
  before(:each) do
    @item_review = assign(:item_review, ItemReview.create!(
      :user => nil,
      :item => nil,
      :rating => 1,
      :comment => "MyString"
    ))
  end

  it "renders the edit item_review form" do
    render

    assert_select "form[action=?][method=?]", item_review_path(@item_review), "post" do

      assert_select "input[name=?]", "item_review[user_id]"

      assert_select "input[name=?]", "item_review[item_id]"

      assert_select "input[name=?]", "item_review[rating]"

      assert_select "input[name=?]", "item_review[comment]"
    end
  end
end

require 'rails_helper'

RSpec.describe "item_reviews/index", type: :view do
  before(:each) do
    assign(:item_reviews, [
      ItemReview.create!(
        :user => nil,
        :item => nil,
        :rating => 2,
        :comment => "Comment"
      ),
      ItemReview.create!(
        :user => nil,
        :item => nil,
        :rating => 2,
        :comment => "Comment"
      )
    ])
  end

  it "renders a list of item_reviews" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Comment".to_s, :count => 2
  end
end

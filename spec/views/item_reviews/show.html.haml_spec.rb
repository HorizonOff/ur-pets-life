require 'rails_helper'

RSpec.describe "item_reviews/show", type: :view do
  before(:each) do
    @item_review = assign(:item_review, ItemReview.create!(
      :user => nil,
      :item => nil,
      :rating => 2,
      :comment => "Comment"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Comment/)
  end
end

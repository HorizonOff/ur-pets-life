require 'rails_helper'

RSpec.describe "ItemReviews", type: :request do
  describe "GET /item_reviews" do
    it "works! (now write some real specs)" do
      get item_reviews_path
      expect(response).to have_http_status(200)
    end
  end
end

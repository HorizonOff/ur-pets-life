require 'rails_helper'

RSpec.describe "ItemBrands", type: :request do
  describe "GET /item_brands" do
    it "works! (now write some real specs)" do
      get item_brands_path
      expect(response).to have_http_status(200)
    end
  end
end

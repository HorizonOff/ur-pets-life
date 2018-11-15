require 'rails_helper'

RSpec.describe "RedeemPoints", type: :request do
  describe "GET /redeem_points" do
    it "works! (now write some real specs)" do
      get redeem_points_path
      expect(response).to have_http_status(200)
    end
  end
end

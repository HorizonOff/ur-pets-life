require 'rails_helper'

RSpec.describe "RecurssionIntervals", type: :request do
  describe "GET /recurssion_intervals" do
    it "works! (now write some real specs)" do
      get recurssion_intervals_path
      expect(response).to have_http_status(200)
    end
  end
end

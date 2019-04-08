require "rails_helper"

RSpec.describe RedeemPointsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/redeem_points").to route_to("redeem_points#index")
    end

    it "routes to #new" do
      expect(:get => "/redeem_points/new").to route_to("redeem_points#new")
    end

    it "routes to #show" do
      expect(:get => "/redeem_points/1").to route_to("redeem_points#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/redeem_points/1/edit").to route_to("redeem_points#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/redeem_points").to route_to("redeem_points#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/redeem_points/1").to route_to("redeem_points#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/redeem_points/1").to route_to("redeem_points#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/redeem_points/1").to route_to("redeem_points#destroy", :id => "1")
    end
  end
end

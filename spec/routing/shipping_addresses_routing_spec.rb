require "rails_helper"

RSpec.describe ShippingAddressesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/shipping_addresses").to route_to("shipping_addresses#index")
    end

    it "routes to #new" do
      expect(:get => "/shipping_addresses/new").to route_to("shipping_addresses#new")
    end

    it "routes to #show" do
      expect(:get => "/shipping_addresses/1").to route_to("shipping_addresses#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/shipping_addresses/1/edit").to route_to("shipping_addresses#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/shipping_addresses").to route_to("shipping_addresses#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/shipping_addresses/1").to route_to("shipping_addresses#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/shipping_addresses/1").to route_to("shipping_addresses#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/shipping_addresses/1").to route_to("shipping_addresses#destroy", :id => "1")
    end
  end
end

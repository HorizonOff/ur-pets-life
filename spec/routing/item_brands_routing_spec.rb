require "rails_helper"

RSpec.describe ItemBrandsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/item_brands").to route_to("item_brands#index")
    end

    it "routes to #new" do
      expect(:get => "/item_brands/new").to route_to("item_brands#new")
    end

    it "routes to #show" do
      expect(:get => "/item_brands/1").to route_to("item_brands#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/item_brands/1/edit").to route_to("item_brands#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/item_brands").to route_to("item_brands#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/item_brands/1").to route_to("item_brands#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/item_brands/1").to route_to("item_brands#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/item_brands/1").to route_to("item_brands#destroy", :id => "1")
    end
  end
end

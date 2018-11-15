require "rails_helper"

RSpec.describe ItemReviewsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/item_reviews").to route_to("item_reviews#index")
    end

    it "routes to #new" do
      expect(:get => "/item_reviews/new").to route_to("item_reviews#new")
    end

    it "routes to #show" do
      expect(:get => "/item_reviews/1").to route_to("item_reviews#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/item_reviews/1/edit").to route_to("item_reviews#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/item_reviews").to route_to("item_reviews#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/item_reviews/1").to route_to("item_reviews#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/item_reviews/1").to route_to("item_reviews#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/item_reviews/1").to route_to("item_reviews#destroy", :id => "1")
    end
  end
end

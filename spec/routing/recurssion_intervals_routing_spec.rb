require "rails_helper"

RSpec.describe RecurssionIntervalsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/recurssion_intervals").to route_to("recurssion_intervals#index")
    end

    it "routes to #new" do
      expect(:get => "/recurssion_intervals/new").to route_to("recurssion_intervals#new")
    end

    it "routes to #show" do
      expect(:get => "/recurssion_intervals/1").to route_to("recurssion_intervals#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/recurssion_intervals/1/edit").to route_to("recurssion_intervals#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/recurssion_intervals").to route_to("recurssion_intervals#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/recurssion_intervals/1").to route_to("recurssion_intervals#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/recurssion_intervals/1").to route_to("recurssion_intervals#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/recurssion_intervals/1").to route_to("recurssion_intervals#destroy", :id => "1")
    end
  end
end

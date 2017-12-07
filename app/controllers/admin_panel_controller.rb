class AdminPanelController < ApplicationController
  before_action :authenticate_admin!
end

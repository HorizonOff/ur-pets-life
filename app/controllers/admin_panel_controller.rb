class AdminPanelController < ApplicationController
  layout 'admin_panel'

  before_action :authenticate_admin!
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :set_layout

  def index
    @facebook_token = params['facebook_token'] if params['facebook_token']
    @google_token = params['google_token'] if params['google_token']
  end

  private

  def set_layout
    if devise_controller?
      'admin_panel'
    else
      'application'
    end
  end
end

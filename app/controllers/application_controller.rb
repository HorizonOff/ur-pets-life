class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def login
    @facebook_token = params['facebook_token'] if params['facebook_token']
    @google_token = params['google_token'] if params['google_token']
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:accept_invitation, keys: %i[name avatar])
    devise_parameter_sanitizer.permit(:invite, keys: %i[role])
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    @facebook_token = params['facebook_token'] if params['facebook_token']
    @google_token = params['google_token'] if params['google_token']
  end
end

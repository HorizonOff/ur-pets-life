class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    facebook_request = request.env['omniauth.auth']
    redirect_to root_path(facebook_token: facebook_request['credentials']['token'])
  end

  def google_oauth2
    google_request = request.env['omniauth.auth']
    redirect_to root_path(google_token: google_request['credentials']['token'])
  end

  def failure
    redirect_to root_path
  end
end

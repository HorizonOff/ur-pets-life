module Api
  class BaseController < ApplicationController
    # attr_reader :current_user
    protect_from_forgery with: :null_session
    before_action :authenticate_user

    private

    def authenticate_user
      authenticate_token || render_401
    end

    def authenticate_token
    end

    def render_422(error = 'Unprocessable Entity')
      render json: { error: error }, status: 422
    end

    def render_404(error = 'Not Found')
      render json: { error: error }, status: 404
    end

    def render_401(error = 'Not Authorized')
      render json: { error: error }, status: 401
    end
  end
end

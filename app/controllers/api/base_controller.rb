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

    def sign_in_user
      if @user.confirmed?
        Session.where(device_id: params[:device_id]).destroy_all if Session.exists?(device_id: params[:device_id])
        session = @user.sessions.new(session_params)
        if session.save
          render json: { user: @user.name, session_token: session.token }, status: :ok
        else
          render json: { errors: session.errors.full_messages }, status: 422
        end
      else
        render json: { error: 'Account not confirmed' }, status: 461
      end
    end

    def session_params
      params.permit(:device_id, :device_type, :push_token)
    end
  end
end

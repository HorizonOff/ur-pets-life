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
      @current_session = Session.find_by_token(request.headers['Authorization'])
      @user = @current_session.user if @current_session
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
      if @user.email.blank?
        render json: { set_email_link: set_email_api_v1_user_url(@user.facebook_id) }, status: 461
      elsif @user.confirmed?
        Session.where(device_id: params[:device_id]).destroy_all if Session.exists?(device_id: params[:device_id])
        session = @user.sessions.new(session_params)
        if session.save
          @user.update_attribute(:sign_in_count, @user.sign_in_count + 1)
          is_first_login = @user.sign_in_count == 1
          render json: { user: @user.name, session_token: session.token, first_login: is_first_login }, status: :ok
        else
          render_422(session.errors.full_messages)
        end
      else
        render json: { error: 'Account not confirmed' }, status: 461
      end
    end

    def sign_out
      @current_session.destroy
    end

    def session_params
      params.permit(:device_id, :device_type, :push_token)
    end
  end
end

module Api
  class BaseController < ApplicationController
    # attr_reader :current_user
    protect_from_forgery with: :null_session
    before_action :authenticate_token
    before_action :authenticate_user

    private

    def current_user
      @user
    end

    def serializable_params
      { latitude: params[:latitude], longitude: params[:longitude], time_zone: params[:time_zone] }
    end

    def authenticate_user
      render_401 unless @user
    end

    def authenticate_user_for_chat
      if !@user
        false
      else
        true
      end
    end

    def authenticate_token
      @current_session = Session.find_by_token(request.headers['Authorization'])
      @user = @current_session.client if @current_session
      @user.update_column(:last_action_at, Time.current) if @user
    end

    def render_422(errors)
      render json: { errors: errors }, status: 422
    end

    def render_404(error = 'Not Found')
      render json: { errors: { error: error } }, status: 404
    end

    def render_401(error = 'Not Authorized')
      render json: { errors: { error: error } }, status: 401
    end

    def sign_in_user
      if @user.confirmed?
        Session.where(device_id: params[:device_id]).destroy_all if Session.exists?(device_id: params[:device_id])
        session = @user.sessions.new(session_params)
        if session.save
          @user.update_attribute(:sign_in_count, @user.sign_in_count + 1)
          is_first_login = @user.sign_in_count == 1
          render json: { user: @user.name, session_token: session.token, first_login: is_first_login,
                         role: @user.try(:role)  }, status: :ok
        else
          render_422(parse_errors_messages(session))
        end
      else
        render json: { error: 'Account not confirmed. Please visit your email and confirm account.' }, status: 461
      end
    end

    def sign_out
      @current_session.destroy
    end

    def session_params
      params.permit(:device_id, :device_type, :push_token)
    end

    def parse_errors_messages(object)
      object.errors.messages.keys.each_with_object({}) do |key, errors|
        errors[key] = object.errors.messages[key].first
      end
    end
  end
end

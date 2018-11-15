module Api
  module V1
    class UsersController < Api::BaseController
      include ParamsCleanerHelper
      skip_before_action :authenticate_user, only: :create
      before_action :clear_user_params, only: %i[create update]

      def profile
        render json: @user
      end

      def create
        @user = User.new(user_params)
        @user.confirmed_at = Time.now
        if @user.save
          sign_in_user
        else
          render_422(parse_errors_messages(@user))
        end
      end

      def update
        @user.assign_attributes(user_params.except(:password, :password_confirmation))
        @user.skip_password_validation = true
        if @user.save
          render json: { message: 'User updated successfully' }
        else
          render_422(parse_errors_messages(@user))
        end
      end

      def set_push_token
        if @current_session.update_column(:push_token, params[:push_token])
          render json: { message: 'Session updated successfully' }
        else
          render_422(parse_errors_messages(@current_session))
        end
      end

      private

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :mobile_number, :password, :password_confirmation,
                                     :google_id, :facebook_id, :birthday, :gender,
                                     location_attributes: %i[latitude longitude city area street building_type
                                                             building_name unit_number villa_number comment])
      end
    end
  end
end

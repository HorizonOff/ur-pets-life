module Api
  module V1
    class UsersController < Api::BaseController
      skip_before_action :authenticate_user, only: [:create, :set_email]

      def profile
        render json: @user, adapter: :json
      end

      def create
        @user = User.new(user_params)
        if @user.save
          render json: { message: 'Registration successful. Please check you\'re email to confirm your account.' }
        else
          render_422(parse_errors_messages(@user))
        end
      end

      def update
        if @user.update(user_params.except(:password, :password_confirmation))
          render json: { message: 'User updated successfully' }
        else
          render_422(parse_errors_messages(@user))
        end
      end

      private

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :password, :password_confirmation,
                                     :google_id, :facebook_id,
                                     location_attributes: [:latitude, :longitude, :city, :area, :street,
                                                           :building_type, :building_name, :unit_number, :villa_number])
      end
    end
  end
end

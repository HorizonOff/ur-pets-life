module Api
  module V1
    class UsersController < Api::BaseController
      skip_before_action :authenticate_user, only: :create

      def create
        @user = User.new(user_params)
        if @user.save
          render json: { message: 'Registration successful. Please check you\'re email to confirm your account.' }
        else
          render json: { errors: @user.errors.full_messages }, status: 422
        end
      end

      private

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation,
                                     location_attributes: [:latitude, :longitude, :country, :city, :street,
                                                           :building_type, :building_name, :unit_number, :villa_number])
      end
    end
  end
end

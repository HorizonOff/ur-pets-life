module Api
  module V1
    class UsersController < Api::BaseController
      skip_before_action :authenticate_user, except: :update

      def create
        @user = User.new(user_params)
        if @user.save
          render json: { message: 'Registration successful. Please check you\'re email to confirm your account.' }
        else
          render_422(@user.errors.full_messages)
        end
      end

      def update
        if @user.update(user_params.except(:email, :password, :password_confirmation))
          render json: { message: 'User updated successfully' }
        else
          render_422(@user.errors.full_messages)
        end
      end

      def set_email
        @user = User.find_by_facebook_id(params[:id])
        if @user.nil?
          render_401
        elsif @user.update(email: params[:email])
          sign_in_user
        else
          render_422(@user.errors.full_messages)
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

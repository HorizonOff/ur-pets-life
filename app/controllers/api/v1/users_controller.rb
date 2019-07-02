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
        @user.confirmed_at = Time.now unless ::Api::V1::DiscountDomainService.new(@user.email.dup).domain_with_discount?
        if MySecondHouseMemberInvitation.find_by(email: @user.email).present?
          @user.member_type = MySecondHouseMemberInvitation.find_by(email: @user.email).member_type
        end
        if @user.save
          sign_in_user
        else
          render_422(parse_errors_messages(@user))
        end
      end

      def update
        @user.assign_attributes(user_params.except(:password, :password_confirmation))
        @user.skip_password_validation = true
        if user_params[:email].present?
          is_domain_discount = ::Api::V1::DiscountDomainService.new(user_params[:email]).domain_with_discount?
          @user.skip_reconfirmation! unless is_domain_discount
        end
        if @user.save
          render json: { message: 'User updated successfully',
                         is_domain_discount: is_domain_discount }
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

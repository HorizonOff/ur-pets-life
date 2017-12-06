require 'google/apis/plus_v1'

module Api
  module V1
    class SessionsController < Api::BaseController
      skip_before_action :authenticate_user, except: [:destroy]

      def create
        @user = User.find_by_email(params[:email])
        if @user&.valid_password?(params[:password])
          sign_in_user
        else
          render_422(message: 'Incorrect email or Password. Please try again.')
        end
      end

      def facebook
        social_user = social_auth_service.facebook_auth

        return render_422(message: social_auth_service.error.message) if social_auth_service.error.present?

        if social_user.is_a?(User)
          @user = social_user
          sign_in_user
        else
          render json: { errors: {},
                         user: { email: social_user.email, first_name: social_user.name.split.first,
                                 last_name: social_user.name.split.last, facebook_id: social_user.id } }, status: 426
        end
      end

      def google
        social_user = social_auth_service.google_auth

        return render_422(message: social_auth_service.error.message) if social_auth_service.error.present?

        if social_user.is_a?(User)
          @user = social_user
          sign_in_user
        else
          render json: { errors: {},
                         user: { email: social_user['email'], first_name: social_user['given_name'],
                                 last_name: social_user['family_name'], google_id: social_user['sub'] } }, status: 426
        end
      end

      def destroy
        sign_out
        render json: { nothing: true }, status: 204
      end

      private

      def social_auth_service
        @social_auth_service ||= ::Api::V1::UserServices::SocialAuthService.new(params[:access_token])
      end
    end
  end
end

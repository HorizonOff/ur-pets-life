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
        begin
          fb_user = FbGraph2::User.me(params[:access_token]).fetch(fields: %i[name email])
        rescue Exception => e
          return render_422(message: e.message)
        end
        if @user = User.find_by_facebook_id(fb_user.id)
          sign_in_user
        elsif @user = User.find_by_email(fb_user.email)
          @user.facebook_id = fb_user.id
          @user.save
          sign_in_user
        else
          render json: { errors: {},
                         user: { email: fb_user.email, first_name: fb_user.name.split.first,
                                 last_name: fb_user.name.split.last, facebook_id: fb_user.id } }, status: 426
        end
      end

      def google
        begin
          url = "https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{params[:access_token]}"
          client = RestClient.get(url)
        rescue RestClient::Exception => e
          return render_422(message: e.message)
        end
        response = JSON.parse(client.body)
        if response['error_description'].present?
          render_422(message: 'Token is invalid')
        elsif @user = User.find_by_google_id(response['sub'])
          sign_in_user
        elsif @user = User.find_by_email(response['email'])
          @user.google_id = response['sub']
          @user.save
          sign_in_user
        else
          render json: { errors: {},
                         user: { email: response['email'], first_name: response['given_name'],
                                 last_name: response['family_name'], google_id: response['sub'] } }, status: 426
        end
      end

      def destroy
        sign_out
        render json: { nothing: true }, status: 204
      end
    end
  end
end

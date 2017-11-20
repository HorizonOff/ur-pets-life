require 'google/apis/plus_v1'

module Api
  module V1
    class SessionsController < Api::BaseController
      skip_before_action :authenticate_user, except: [:destroy]

      def create
        @user = User.find_by_email login_params[:email]
        if @user && @user.authenticate(login_params[:password])
          if @user.confirmation_required?
            render_response :not_confirmed_account
          else
            sign_in user: @user, device_type: params[:device_type], push_token: params[:push_token]
          end
        else
          render json: { errors: ['Wrong login/password combination.'] }, status: 422
        end
      end

      def facebook
        # a = RestClient.get("https://graph.facebook.com/v2.5/me?access_token=#{params[:access_token]}&fields=email,first_name,last_name,name,picture"){|response, request, result| }
        begin
          fb_user = FbGraph2::User.me(params[:access_token]).fetch(fields: [:name, :email])
        rescue Exception => e
          render json: { errors: [e.message] }, status: 422
        end
        if fb_user.email && @user = User.find_by_email(fb_user.email)
          @user.facebook_id = fb_user.id
          @user.save
          sign_in_user
        else
          @user = User.find_by_facebook_id(fb_user.id)
          if @user
            sign_in_user
          else
            confirmed_at = Time.now if fb_user.email.present?
            @user = User.new(email: fb_user.email,
                             first_name: fb_user.name.split.first,
                             last_name: fb_user.name.split.last,
                             facebook_id: fb_user.id,
                             is_social: true,
                             confirmed_at: confirmed_at)
            if @user.save
              sign_in_user
            else
              render json: { errors: @user.errors.full_messages }, status: 422
            end
          end
        end
      end

      def google
        client = Signet::OAuth2::Client.new(access_token: params['token'], token_credential_uri: 'https://accounts.google.com/o/oauth2/token', expires_in: (Time.now + 1.hour).utc.to_i)
        service = Google::Apis::PlusV1::PlusService.new

        service.authorization = client
        profile = service.get_person('me', fields: 'displayName,emails/value,image,gender,id')
      end

      def destroy
        sign_out
        render nothing: true, status: 204
      end

      private

      def login_params
        params.permit(:email, :password)
      end
    end
  end
end

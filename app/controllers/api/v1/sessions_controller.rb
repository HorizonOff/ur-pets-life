require 'google/apis/plus_v1'

module Api
  module V1
    class SessionsController < Api::BaseController
      skip_before_action :authenticate_user, except: [:destroy]

      def create
        @user = User.find_by_email(params[:email])
        if @user && @user.valid_password?(params[:password])
          sign_in_user
        else
          render json: { errors: ['Wrong login/password combination.'] }, status: 422
        end
      end

      def facebook
        begin
          fb_user = FbGraph2::User.me(params[:access_token]).fetch(fields: %i[name email])
        rescue Exception => e
          return render json: { errors: [e.message] }, status: 422
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
            @user = User.new(email: fb_user.email,
                             first_name: fb_user.name.split.first,
                             last_name: fb_user.name.split.last,
                             facebook_id: fb_user.id,
                             provider: 'facebook',
                             is_social: true,
                             confirmed_at: Time.now)
            if @user.save
              sign_in_user
            else
              render json: { errors: @user.errors.full_messages }, status: 422
            end
          end
        end
      end

      def google
        client = Signet::OAuth2::Client.new(access_token: params[:access_token],
                                            token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
                                            expires_in: (Time.now + 1.hour).utc.to_i)
        service = Google::Apis::PlusV1::PlusService.new

        service.authorization = client
        profile = service.get_person('me', fields: 'displayName,emails/value,image,gender,id')

        email = profile.emails.first.value

        if @user = User.find_by_email(email)
          @user.google_id = profile.id
          @user.save
          sign_in_user
        else
          @user = User.new(email: email,
                           first_name: profile.display_name.split.first,
                           last_name: profile.display_name.split.last,
                           google_id: profile.id,
                           provider: 'google',
                           is_social: true,
                           confirmed_at: Time.now)
          if @user.save
            sign_in_user
          else
            render json: { errors: @user.errors.full_messages }, status: 422
          end
        end
      end

      def destroy
        sign_out
        render json: { nothing: true }, status: 204
      end
    end
  end
end

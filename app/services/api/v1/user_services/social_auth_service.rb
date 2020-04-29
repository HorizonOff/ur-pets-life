module Api
  module V1
    module UserServices
      class SocialAuthService
        attr_reader :error

        def initialize(access_token)
          @access_token = access_token
        end

        def facebook_auth
          begin
            fb_user = FbGraph2::User.me(access_token).fetch(fields: %i[name email])
          rescue StandardError => e
            add_error(e.message)
            return
          end

          user = User.find_by_facebook_id(fb_user.id)

          return user if user.present?

          user = User.find_by_email(fb_user.email) if fb_user.email.present?
          if user.present?
            user.update_attributes(facebook_id: fb_user.id)
            return user
          end

          fb_user unless user.present?
        end

        def google_auth
          begin
            url = "https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{access_token}"
            client = RestClient.get(url)
            response = JSON.parse(client.body)
          rescue RestClient::Exception => e
            add_error(e.message)
            return
          end

          if response['error_description'].present?
            add_error('Access token is invalid')
            return @error
          end

          user = User.find_by_google_id(response['sub'])
          return user if user.present?

          user = User.find_by_email(response['email'])
          if user.present?
            user.update_attributes(google_id: response['sub'])
            return user
          end

          response unless user.present?
        end

        def apple_auth
          begin
            jwks = HTTParty.get ENV['APPLE_PUBLIC_KEY_URL']
            alg = jwks['keys'].first['alg']
            apple_info = JWT.decode(access_token, nil, true,
                                    { algorithms: [alg], jwks: jwks.deep_symbolize_keys })[0]
          rescue StandardError => e
            add_error(e.message)
            return
          end

          apple_id = apple_info['sub']
          if apple_id.blank?
            add_error('Invalid apple_token')
            return @error
          end

          user = User.find_by_apple_id(apple_id)
          return user if user.present?

          user = User.find_by_email(apple_info['email'])
          if user.present?
            user.update_attributes(apple_id: apple_info['sub'])
            return user
          end

          apple_info unless user.present?
        end

        private

        attr_reader :access_token

        def add_error(msg)
          @error = { message: msg }
        end
      end
    end
  end
end

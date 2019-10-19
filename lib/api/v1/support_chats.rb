module Api
  module V1
    class SupportChats < ActionController::Base
      include Swagger::Blocks

      swagger_path '/current_user_support_chat' do
        operation :get do
          key :description, 'return user support chat'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %w[SupportChat]

          security do
            key :api_key, []
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end
    end
  end
end

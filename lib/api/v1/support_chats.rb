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

      swagger_schema :SupportChatInput do
        property :support_chat do
          property :path do
            key :type, :string
            key :example, 'test'
          end
        end
      end

      swagger_path '/support_chats' do
        operation :post do
          key :description, 'create support chat'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %w[SupportChat]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :support_chat
            key :in, :body
            key :required, true

            schema do
              key :'$ref', :SupportChatInput
            end
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end
    end
  end
end

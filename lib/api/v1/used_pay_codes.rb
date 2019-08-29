module Api
  module V1
    class UsedPayCodes < ActionController::Base
      include Swagger::Blocks

      swagger_path '/pay_code' do
        operation :get do
          key :description, 'Get pay code'
          key :consumes, %w[application/json]
          key :consumes, %w[application/json]
          key :tags, %w[Pay\ codes]

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

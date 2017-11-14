module Api
  module V1
    class Pages < ActionController::Base
      include Swagger::Blocks
      swagger_path '/pages' do
        operation :get do
          key :description, 'Returns welcome'
          key :produces, %w[application/json]
          key :tags, %w[Pages]

          response 200 do
            key :description, 'Success response'
          end
        end
      end
    end
  end
end
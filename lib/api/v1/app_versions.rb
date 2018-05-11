module Api
  module V1
    class AppVersions < ActionController::Base
      include Swagger::Blocks

      swagger_schema :AppVersionResponse do
        property :android_version do
          key :type, :string
          key :example, '1.1.1'
        end
      end

      swagger_path '/app_version' do
        operation :get do
          key :description, 'Get last app version'
          key :consumes, %w[application/json]
          key :consumes, %w[application/json]
          key :tags, %w[App\ Version]

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :AppVersionResponse
            end
          end
        end
      end
    end
  end
end

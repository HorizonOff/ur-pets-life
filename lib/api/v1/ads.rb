module Api
  module V1
    class Ads < ActionController::Base
      include Swagger::Blocks

      swagger_schema :AdResponse do
        property :image_url do
          key :type, :string
          key :example, 'https://s3.eu-central-1.amazonaws.com/urpets-dev/urpets/uploads/good/image/4/image.jpeg'
        end
      end

      swagger_path '/get_current_ad' do
        operation :get do
          key :description, 'Get current ad'
          key :consumes, %w[application/json]
          key :consumes, %w[application/json]
          key :tags, %w[Ad]

          security do
            key :api_key, []
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :AdResponse
            end
          end
        end
      end
    end
  end
end

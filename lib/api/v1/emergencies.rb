module Api
  module V1
    class Emergencies < ActionController::Base
      include Swagger::Blocks

      swagger_path '/emergencies' do
        operation :get do
          key :description, 'Get emergencies centres'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Emergency]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :longitude
            key :in, :query
            key :type, :number
            key :example, 22.287883
          end

          parameter do
            key :name, :latitude
            key :in, :query
            key :type, :number
            key :example, 48.6208
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end

    end
  end
end

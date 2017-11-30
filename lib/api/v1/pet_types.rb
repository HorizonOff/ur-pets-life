module Api
  module V1
    class PetTypes < ActionController::Base
      include Swagger::Blocks

      swagger_path '/pet_types' do
        operation :get do
          key :description, 'Get available types of pet'
          key :consumes, %w[application/json]
          key :consumes, %w[application/json]
          key :tags, %W[Pet\ types]

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

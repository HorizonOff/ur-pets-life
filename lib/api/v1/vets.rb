module Api
  module V1
    class Vets < ActionController::Base
      include Swagger::Blocks

      swagger_path '/vets/{id}' do
        operation :get do
          key :description, 'Get vet'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %w[Vets]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :example, 1
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end
    end
  end
end

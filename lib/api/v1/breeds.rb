module Api
  module V1
    class Breeds < ActionController::Base
      include Swagger::Blocks

      swagger_schema :BreedsResponse do
        property :breeds do
          items do
            property :id do
              key :type, :integer
              key :example, 1
            end
            property :name do
              key :type, :string
              key :example, 'American Bobtail'
            end
          end
        end
      end

      swagger_path '/breeds' do
        operation :get do
          key :description, 'Get available pet breeds'
          key :consumes, %w[application/json]
          key :consumes, %w[application/json]
          key :tags, %w[Breeds]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :pet_type_id
            key :in, :query
            key :required, true
            key :description, "Available pet_types look pet_types documantation.\n" +
                               'cat = 1 dog = 2'
            key :type, :integer
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :BreedsResponse
            end
          end
        end
      end
    end
  end
end

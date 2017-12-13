module Api
  module V1
    class VaccineTypes < ActionController::Base
      include Swagger::Blocks

      swagger_schema :Vaccination do
        property :id do
          key :type, :integer
          key :example, 1
        end
        property :vaccine_type_id do
          key :type, :integer
          key :example, 1
        end
        property :done_at do
          key :type, :string
          key :example, '2017-12-12T11:13:40Z'
        end
        property :picture_url do
          key :type, :string
        end
        property :remove_picture do
          key :type, :boolean
          key :example, false
        end
      end

      swagger_schema :VaccineType do
        property :id do
          key :type, :integer
          key :example, 1
        end
        property :name do
          key :type, :string
          key :example, 'Leukemia'
        end
        property :vaccinations do
          items do
            key :'$ref', :Vaccination
          end
        end
      end

      swagger_schema :VaccineTypesResponse do
        property :vaccine_types do
          items do
            property :id do
              key :type, :integer
              key :example, 1
            end
            property :name do
              key :type, :string
              key :example, 'Leukemia'
            end
          end
        end
      end

      swagger_path '/vaccine_types' do
        operation :get do
          key :description, 'Get available types of vaccine for pet'
          key :consumes, %w[application/json]
          key :consumes, %w[application/json]
          key :tags, %W[Vaccine\ types]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :pet_type_id
            key :in, :query
            key :required, true
            key :description, "Available pet_types look pet_types documantation.\n" +
                               'cat = 1 dog = 2 other= 3'
            key :type, :integer
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :VaccineTypesResponse
            end
          end
        end
      end
    end
  end
end

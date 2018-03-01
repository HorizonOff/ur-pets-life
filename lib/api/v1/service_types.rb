module Api
  module V1
    class ServiceTypes < ActionController::Base
      include Swagger::Blocks

      swagger_schema :PetServicesResponse do
        property :pets do
          items do
            property :pet_id do
              key :type, :integer
              key :example, 1
            end
            property :name do
              key :type, :string
              key :example, 'Tom'
            end
            property :service_types do
              items do
                key :'$ref', :ServiceType
              end
            end
          end
        end
      end

      swagger_schema :VetsForPets do
        property :vets do
          items do
            key :'$ref', :Vet
          end
        end
      end

      swagger_path '/clinics/{id}/vets' do
        operation :get do
          key :description, 'Get clinics vets for pets'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Clinics Vets Services]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :example, 1
          end

          parameter do
            key :name, 'pet_ids[]'
            key :in, :query
            key :example, 1
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :VetsForPets
            end
          end
        end
      end

      swagger_path '/day_care_centres/{id}/services' do
        operation :get do
          key :description, 'Get day care centre services'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Day\ Care\ Centres Services]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :example, 1
          end

          parameter do
            key :name, 'pet_ids[]'
            key :in, :query
            key :example, 1
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :PetServicesResponse
            end
          end
        end
      end

      swagger_path '/grooming_centres/{id}/services' do
        operation :get do
          key :description, 'Get grooming centre services'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Grooming\ Centres Services]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :example, 1
          end

          parameter do
            key :name, 'pet_ids[]'
            key :in, :query
            key :example, 1
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :PetServicesResponse
            end
          end
        end
      end

      swagger_path '/boardings/{id}/services' do
        operation :get do
          key :description, 'Get boarding services'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Boardings Services]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :example, 1
          end

          parameter do
            key :name, 'pet_ids[]'
            key :in, :query
            key :example, 1
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :PetServicesResponse
            end
          end
        end
      end
    end
  end
end

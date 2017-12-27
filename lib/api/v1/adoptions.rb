module Api
  module V1
    class Adoptions < ActionController::Base
      include Swagger::Blocks
      swagger_schema :AdoptionResponse do
        property :pet do
          property :id do
            key :type, :integer
            key :example, 10
          end
          property :avatar_url do
            key :type, :string
          end
          property :name do
            key :type, :string
            key :example, 'Pluto'
          end
          property :birthday do
            key :type, :string
            key :example, '2017-12-12T11:13:40Z'
          end
          property :sex do
            key :type, :integer
            key :example, 0
          end
          property :weight do
            key :type, :number
            key :example, 2.0
          end
          property :comment do
            key :type, :string
          end
          property :pet_type_id do
            key :type, :integer
            key :example, 2
          end
          property :additional_type do
            key :type, :string
            key :description, 'If pet_type_id - 3 - other'
          end
          property :breed do
            property :id do
              key :type, :integer
              key :example, 1
            end
            property :name do
              key :type, :string
              key :example, 'Doberman'
            end
          end
          property :mobile_number do
            key :type, :string
            key :example, '+34053452392300'
          end
          property :address do
            key :type, :string
            key :example, 'Uzhgorod'
          end
          property :distance do
            key :type, :number
            key :example, 34
          end
          property :vaccine_types do
            items do
              key :'$ref', :VaccineType
            end
          end
          property :pictures do
            items do
              key :'$ref', :Picture
            end
          end
        end
      end

      swagger_schema :AdoptionsResponse do
        property :pets do
          items do
            property :id do
              key :type, :integer
              key :example, 10
            end
            property :avatar_url do
              key :type, :string
            end
            property :name do
              key :type, :string
              key :example, 'Pluto'
            end
            property :birthday do
              key :type, :string
              key :example, '2017-12-12T11:13:40Z'
            end
            property :pet_type_id do
              key :type, :integer
              key :example, 2
            end
            property :address do
              key :type, :string
              key :example, 'Dubai'
            end
            property :distance do
              key :type, :number
              key :example, 34
            end
          end
        end
      end


      swagger_path '/adoptions' do
        operation :get do
          key :description, 'Get all pets for adoption'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %w[Adoptions]

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

          parameter do
            key :name, :page
            key :in, :query
            key :type, :integer
            key :example, 1
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :AdoptionsResponse
            end
          end
        end
      end


      swagger_path '/adoptions/{id}' do
        operation :get do
          key :description, 'Show pet for adoption'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %w[Adoptions]

          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :required, true
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
            schema do
              key :'$ref', :AdoptionResponse
            end
          end
        end
      end

      swagger_path '/pets/can_be_adopted' do
        operation :get do
          key :description, 'Get list of users pets that can be given for adoption'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %w[Pets Adoptions]

          security do
            key :api_key, []
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :PetsResponse
            end
          end
        end
      end
    end
  end
end

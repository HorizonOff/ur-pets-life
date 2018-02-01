module Api
  module V1
    class Pets < ActionController::Base
      include Swagger::Blocks
      swagger_schema :Picture do
        property :id do
          key :type, :integer
          key :example, 10
        end
        property :picture_url do
          key :type, :string
        end
      end

      swagger_schema :PetResponse do
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
            key :type, :integer
            key :example, 1516217199
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
          property :lost_at do
            key :type, :integer
            key :example, 1516217199
          end
          property :is_for_adoption do
            key :type, :boolean
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

      swagger_schema :PetsResponse do
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
              key :type, :integer
              key :example, 1516217199
            end
            property :pet_type_id do
              key :type, :integer
              key :example, 2
            end
            property :mobile_numbner do
              key :type, :string
              key :example, '+38050505050'
            end
          end
        end
      end


      swagger_path '/pets' do
        operation :get do
          key :description, 'Get all pets'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %w[Pets]

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

        operation :post do
          key :description, 'Create pet'
          key :consumes, %w[multipart/form-data]
          key :produces, %w[application/json]
          key :tags, %w[Pets]

          security do
            key :api_key, []
          end

          parameter do
            key :name, 'pet[name]'
            key :in, :formData
            key :required, true
            key :type, :string
            key :example, 'Cat name'
          end
          parameter do
            key :name, 'pet[birthday]'
            key :in, :formData
            key :required, true
            key :type, :integer
            key :example, 1516217199
          end
          parameter do
            key :name, 'pet[pet_type_id]'
            key :in, :formData
            key :required, true
            key :type, :integer
            key :example, 1
          end
          parameter do
            key :name, 'pet[additional_type]'
            key :in, :formData
            key :type, :string
            key :description, 'Required if pet_type_id - 3 - Other'
          end
          parameter do
            key :name, 'pet[breed_id]'
            key :in, :formData
            key :type, :integer
            key :example, 205
            key :description, 'Required unless pet_type_id - 3 - Other'
          end
          parameter do
            key :name, 'pet[sex]'
            key :in, :formData
            key :type, :string
            key :example, '0'
            key :description, "male = 0/female = 1"
          end
          parameter do
            key :name, 'pet[weight]'
            key :in, :formData
            key :type, :number
            key :required, true
            key :example, 2.0
          end
          parameter do
            key :name, 'pet[comment]'
            key :in, :formData
            key :type, :string
            key :example, 'Comment'
          end
          parameter do
            key :name, 'pet[avatar]'
            key :in, :formData
            key :type, :file
          end


          parameter do
            key :name, 'pet[vaccinations_attributes][0][vaccine_type_id]'
            key :in, :formData
            key :type, :integer
            key :example, 1
          end
          parameter do
            key :name, 'pet[vaccinations_attributes][0][done_at]'
            key :in, :formData
            key :type, :integer
            key :example, 1516217199
          end
          parameter do
            key :name, 'pet[vaccinations_attributes][0][picture]'
            key :in, :formData
            key :type, :file
          end
          parameter do
            key :name, 'pet[vaccinations_attributes][1][vaccine_type_id]'
            key :in, :formData
            key :type, :integer
            key :example, 8
          end
          parameter do
            key :name, 'pet[vaccinations_attributes][1][done_at]'
            key :in, :formData
            key :type, :integer
            key :example, 1516217199
          end
          parameter do
            key :name, 'pet[vaccinations_attributes][1][picture]'
            key :in, :formData
            key :type, :file
          end


          parameter do
            key :name, 'pet[pictures_attributes][0][attachment]'
            key :in, :formData
            key :type, :file
          end
          parameter do
            key :name, 'pet[pictures_attributes][1][attachment]'
            key :in, :formData
            key :type, :file
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :PetResponse
            end
          end
        end
      end

      swagger_path '/pets/{id}' do
        operation :get do
          key :description, 'Show pet'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %w[Pets]

          security do
            key :api_key, []
          end
          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :required, true
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :PetResponse
            end
          end
        end

        operation :put do
          key :description, 'Update pet'
          key :consumes, %w[multipart/form-data]
          key :produces, %w[application/json]
          key :tags, %w[Pets]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :required, true
          end

          parameter do
            key :name, 'pet[name]'
            key :in, :formData
            key :required, true
            key :type, :string
            key :example, 'Cat name'
          end
          parameter do
            key :name, 'pet[birthday]'
            key :in, :formData
            key :required, true
            key :type, :integer
            key :example, 1516217199
          end
          parameter do
            key :name, 'pet[additional_type]'
            key :in, :formData
            key :type, :string
            key :description, 'Only if pet_type_id - 3 - Other'
          end
          parameter do
            key :name, 'pet[breed_id]'
            key :in, :formData
            key :type, :integer
            key :example, 205
            key :description, 'Required unless pet_type_id - 3 - Other'
          end
          parameter do
            key :name, 'pet[sex]'
            key :in, :formData
            key :type, :string
            key :example, '0'
            key :description, "male = 0/female = 1"
          end
          parameter do
            key :name, 'pet[weight]'
            key :in, :formData
            key :type, :number
            key :required, true
            key :example, 2.0
          end
          parameter do
            key :name, 'pet[comment]'
            key :in, :formData
            key :type, :string
            key :example, 'Comment'
          end
          parameter do
            key :name, 'pet[avatar]'
            key :in, :formData
            key :type, :file
          end


          parameter do
            key :name, 'pet[vaccinations_attributes][0][id]'
            key :in, :formData
            key :type, :integer
            key :example, 1
            key :description, 'Required if you want update vaccination. If its - empty - you will create new vaccination'
          end
          parameter do
            key :name, 'pet[vaccinations_attributes][0][vaccine_type_id]'
            key :in, :formData
            key :type, :integer
            key :example, 1
          end
          parameter do
            key :name, 'pet[vaccinations_attributes][0][done_at]'
            key :in, :formData
            key :type, :integer
            key :example, 1516217199
          end
          parameter do
            key :name, 'pet[vaccinations_attributes][0][picture]'
            key :in, :formData
            key :type, :file
            key :description, 'Send file only if you need to update it'
          end
          parameter do
            key :name, 'pet[vaccinations_attributes][0][remove_picture]'
            key :in, :formData
            key :type, :boolean
            key :example, false
            key :description, 'TRUE if you want remove picture'
          end

          parameter do
            key :name, 'pet[vaccinations_attributes][1][vaccine_type_id]'
            key :in, :formData
            key :type, :integer
            key :example, 8
            key :description, 'Adding new vaccination'
          end
          parameter do
            key :name, 'pet[vaccinations_attributes][1][done_at]'
            key :in, :formData
            key :type, :integer
            key :example, 1516217199
          end
          parameter do
            key :name, 'pet[vaccinations_attributes][1][picture]'
            key :in, :formData
            key :type, :file
          end


          parameter do
            key :name, 'pet[pictures_attributes][0][id]'
            key :in, :formData
            key :type, :integer
            key :description, 'Required if you want leave picture'
          end

          parameter do
            key :name, 'pet[pictures_attributes][1][attachment]'
            key :in, :formData
            key :type, :file
            key :description, 'Adding new picture'
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :PetResponse
            end
          end
        end

        operation :delete do
          key :description, 'Delete pet'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %w[Pets]

          security do
            key :api_key, []
          end
          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :required, true
          end
          response 204 do
            key :description, 'Success response'
          end
        end
      end

      swagger_path '/found_pets' do
        operation :get do
          key :description, 'Get my found pets'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %w[Pets]

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
            schema do
              key :'$ref', :LostAndFoundsResponse
            end
          end
        end
      end
    end
  end
end

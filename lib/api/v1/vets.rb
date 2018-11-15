module Api
  module V1
    class Vets < ActionController::Base
      include Swagger::Blocks

      swagger_schema :Vet do
        property :id do
          key :type, :integer
          key :example, 1
        end
        property :name do
          key :type, :string
          key :example, 'Dr Muhamed'
        end
        property :avatar_url do
          key :type, :string
        end
        property :experience do
          key :type, :integer
          key :example, 4
        end
        property :consultation_fee do
          key :type, :integer
          key :example, 345
        end
        property :pet_type_ids do
          key :type, :array
          key :example, [1, 2]
        end
      end

      swagger_schema :VetResponse do
        property :id do
          key :type, :integer
          key :example, 1
        end
        property :name do
          key :type, :string
          key :example, 'Dr Muhamed'
        end
        property :avatar_url do
          key :type, :string
        end
        property :clinic_picture_url do
          key :type, :string
        end
        property :mobile_number do
          key :type, :string
          key :example, '+3805050505050'
        end
        property :experience do
          key :type, :integer
          key :example, 4
        end
        property :consultation_fee do
          key :type, :integer
          key :example, 345
        end
        property :favorite_id do
          key :type, :integer
          key :example, 1
        end
        property :pet_type_ids do
          key :type, :array
          key :example, [1, 2]
        end
        property :specializations do
          key :type, :array
          key :example, ['Microbiology']
        end
        property :qualifications do
          items do
            key :'$ref', :Qualification
          end
        end
      end

      swagger_schema :Qualification do
        property :diploma do
          key :type, :string
          key :example, 'Cardiolog Diploma'
        end
        property :university do
          key :type, :string
          key :example, 'Mumbai Universuty'
        end
      end

      swagger_path '/vets/{id}' do
        operation :get do
          key :description, 'Get vet'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %w[Vets]

          parameter do
            key :type, :string
            key :name, 'Authorization'
            key :in, :header
          end

          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :example, 1
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :VetResponse
            end
          end
        end
      end
    end
  end
end

module Api
  module V1
    class Trainers < ActionController::Base
      include Swagger::Blocks

      swagger_schema :TrainersResponse do
        property :trainers do
          items do
            property :id do
              key :type, :integer
              key :example, 1
            end
            property :name do
              key :type, :string
              key :example, 'Trainer 1'
            end
            property :picture_url do
              key :type, :string
            end
            property :address do
              key :type, :string
              key :example, 'Uzhgorod'
            end
            property :distance do
              key :type, :number
              key :example, 34
            end
          end
        end
      end

      swagger_schema :TrainerResponse do
        property :trainer do
          property :id do
            key :type, :integer
            key :example, 1
          end
          property :name do
            key :type, :string
            key :example, 'Trainer 1'
          end
          property :picture_url do
            key :type, :string
          end
          property :mobile_number do
            key :type, :string
            key :example, '+3805050505050'
          end
          property :pet_type_ids do
            key :type, :array
            key :example, [1, 2]
          end
          property :experience do
            key :type, :integer
            key :example, 4
          end
          property :favorite_id do
            key :type, :integer
            key :example, 1
          end
          property :specializations do
            key :type, :array
            key :example, ['Dog Trainer']
          end
          property :qualifications do
            items do
              key :'$ref', :Qualification
            end
          end
          property :service_types do
            items do
              key :'$ref', :ServiceTypeWithoutPrice
            end
          end
        end
      end

      swagger_schema :ServiceTypeWithoutPrice do
        property :id do
          key :type, :integer
          key :example, 1
        end
        property :name do
          key :type, :string
          key :example, 'Service 1'
        end
        property :description do
          key :type, :string
        end
      end

      swagger_path '/trainers' do
        operation :get do
          key :description, 'Get trainers. All params are not required'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Trainers]

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

          parameter do
            key :name, :search
            key :in, :query
            key :type, :string
            key :example, 'trainer'
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :TrainersResponse
            end
          end
        end
      end

      swagger_path '/trainers/{id}' do
        operation :get do
          key :description, 'Get trainer'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Trainers]

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
              key :'$ref', :TrainerResponse
            end
          end
        end
      end
    end
  end
end

module Api
  module V1
    class AdditionalServices < ActionController::Base
      include Swagger::Blocks

      swagger_schema :AdditionalServicesResponse do
        property :additional_services do
          items do
            property :id do
              key :type, :integer
              key :example, 1
            end
            property :name do
              key :type, :string
              key :example, 'Clinic 1'
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

      swagger_schema :AdditionalSerivceResponse do
        property :additional_service do
          property :id do
            key :type, :integer
            key :example, 1
          end
          property :name do
            key :type, :string
            key :example, 'Clinic 1'
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
          property :favorite_id do
            key :type, :integer
            key :example, 1
          end
          property :mobile_number do
            key :type, :string
            key :example, '+3805050505050'
          end
          property :email do
            key :type, :string
            key :example, 'clinis1@mail.com'
          end
          property :website do
            key :type, :string
            key :example, 'www.website.com'
          end
        end
      end

      swagger_path '/additional_services' do
        operation :get do
          key :description, 'Get additional services. All params are not required'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %w[Additional\ Services]

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
            key :example, 'service'
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :AdditionalServicesResponse
            end
          end
        end
      end

      swagger_path '/additional_services/{id}' do
        operation :get do
          key :description, 'Get additional service'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %w[Additional\ Services]

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
              key :'$ref', :AdditionalSerivceResponse
            end
          end
        end
      end
    end
  end
end

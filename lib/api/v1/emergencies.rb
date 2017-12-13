module Api
  module V1
    class Emergencies < ActionController::Base
      include Swagger::Blocks

      swagger_schema :EmergenciesResponse do
        property :emergencies do
          items do
            property :name do
              key :type, :string
              key :example, 'Clinic 1'
            end
            property :address do
              key :type, :string
              key :example, 'Uzhgorod'
            end
            property :distance do
              key :type, :number
              key :example, 34
            end
            property :mobile_number do
              key :type, :string
              key :example, '+3805050505050'
            end
            property :type do
              key :type, :string
              key :example, 'Clinic'
            end
          end
        end
      end

      swagger_path '/emergencies' do
        operation :get do
          key :description, 'Get emergencies centres'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Emergency]

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
              key :'$ref', :EmergenciesResponse
            end
          end
        end
      end

    end
  end
end

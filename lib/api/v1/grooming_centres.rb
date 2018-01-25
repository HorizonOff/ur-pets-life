module Api
  module V1
    class GroomingCentres < ActionController::Base
      include Swagger::Blocks

      swagger_schema :GroomingCentresResponse do
        property :grooming_centres do
          items do
            property :id do
              key :type, :integer
              key :example, 1
            end
            property :name do
              key :type, :string
              key :example, 'Grooming centre 1'
            end
            property :picture_url do
              key :type, :string
            end
            property :working_hours do
              key :'$ref', :WorkingHours
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

      swagger_schema :GroomingCentreResponse do
        property :grooming_centre do
          property :id do
            key :type, :integer
            key :example, 1
          end
          property :name do
            key :type, :string
            key :example, 'Grooming centre 1'
          end
          property :picture_url do
            key :type, :string
          end
          property :working_hours do
            key :'$ref', :WorkingHours
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
          property :email do
            key :type, :string
            key :example, 'grooming1@mail.com'
          end
          property :website do
            key :type, :string
            key :example, 'www.website.com'
          end
          property :favorite_id do
            key :type, :integer
            key :example, 1
          end
          property :service_options do
            key :type, :array
            key :example, ['Drop off']
          end
          property :service_types do
            items do
              key :'$ref', :ServiceType
            end
          end
        end
      end

      swagger_path '/grooming_centres' do
        operation :get do
          key :description, 'Get grooming centres. All params are not required'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Grooming\ Centres]

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
            key :name, :time_zone
            key :in, :query
            key :type, :integer
            key :example, 3
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
              key :'$ref', :GroomingCentresResponse
            end
          end
        end
      end

      swagger_path '/grooming_centres/{id}' do
        operation :get do
          key :description, 'Get grooming centre'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Grooming\ Centres]

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

          parameter do
            key :name, :time_zone
            key :in, :query
            key :type, :integer
            key :example, 3
          end


          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :GroomingCentreResponse
            end
          end
        end
      end
    end
  end
end

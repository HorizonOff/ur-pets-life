module Api
  module V1
    class DayCareCentres < ActionController::Base
      include Swagger::Blocks

      swagger_schema :DayCareCentresResponse do
        property :day_care_centres do
          items do
            property :id do
              key :type, :integer
              key :example, 1
            end
            property :name do
              key :type, :string
              key :example, 'Day Care 1'
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

      swagger_schema :DayCareCentreResponse do
        property :day_care_centre do
          property :id do
            key :type, :integer
            key :example, 1
          end
          property :name do
            key :type, :string
            key :example, 'Day Care 1'
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
            key :example, 'day_care1@mail.com'
          end
          property :website do
            key :type, :string
            key :example, 'www.website.com'
          end
          property :favorite_id do
            key :type, :integer
            key :example, 1
          end
          property :service_option_details do
            items do
              key :'$ref', :ServiceOptionDetail
            end
          end
          property :service_types do
            items do
              key :'$ref', :ServiceType
            end
          end
        end
      end

      swagger_schema :ServiceType do
        property :pet_type_id do
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
        property :service_details do
          items do
            key :'$ref', :ServiceDetail
          end
        end
      end

      swagger_schema :ServiceOptionDetail do
        property :id do
          key :type, :integer
          key :example, 1
        end
        property :service_option_id do
          key :type, :integer
          key :example, 1
        end
        property :price do
          key :type, :integer
          key :example, 123
        end
        property :name do
          key :type, :string
          key :example, 'Pick Up'
        end
      end

      swagger_schema :ServiceDetail do
        property :id do
          key :type, :integer
          key :example, 1
        end
        property :pet_type_id do
          key :type, :integer
          key :example, 1
        end
        property :price do
          key :type, :integer
          key :example, 123
        end
        property :weight do
          key :type, :number
          key :example, 15
        end
      end

      swagger_path '/day_care_centres' do
        operation :get do
          key :description, 'Get day care centres. All params are not required'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Day\ Care\ Centres]

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

          parameter do
            key :name, :search
            key :in, :query
            key :type, :string
            key :example, 'day'
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :DayCareCentresResponse
            end
          end
        end
      end

      swagger_path '/day_care_centres/{id}' do
        operation :get do
          key :description, 'Get day care centre'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Day\ Care\ Centres]

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
              key :'$ref', :DayCareCentreResponse
            end
          end
        end
      end

    end
  end
end

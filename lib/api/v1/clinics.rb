module Api
  module V1
    class Clinics < ActionController::Base
      include Swagger::Blocks

      swagger_schema :ClinicsResponse do
        property :clinics do
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
            property :consultation_fee do
              key :type, :integer
              key :example, 345
            end
          end
        end
      end

      swagger_schema :ClinicResponse do
        property :clinic do
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
          property :consultation_fee do
            key :type, :integer
            key :example, 345
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
          property :vets do
            items do
              key :'$ref', :Vet
            end
          end
        end
      end

      swagger_schema :WorkingHours do
        property :open_at do
          key :type, :string
          key :example, '11:00'
        end
        property :close_at do
          key :type, :string
          key :example, '19:00'
        end
      end

      swagger_path '/clinics' do
        operation :get do
          key :description, 'Get clinics. All params are not required'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %w[Clinics]

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
              key :'$ref', :ClinicsResponse
            end
          end
        end
      end

      swagger_path '/clinics/{id}' do
        operation :get do
          key :description, 'Get clinic'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %w[Clinics]

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
              key :'$ref', :ClinicResponse
            end
          end
        end
      end
    end
  end
end

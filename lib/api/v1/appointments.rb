module Api
  module V1
    class Appointments < ActionController::Base
      include Swagger::Blocks

      swagger_schema :AppointmentInput do
        property :appointment do
          property :bookable_type do
            key :type, :string
            key :example, 'Clinic'
          end
           property :bookable_id do
            key :type, :integer
            key :example, 1
          end
          property :pet_id do
            key :type, :integer
            key :example, 1
          end
          property :vet_id do
            key :type, :integer
            key :example, 1
          end
          property :booked_at do
            key :type, :string
            key :example, Time.now.utc.iso8601
          end
          property :comment do
            key :type, :string
          end
        end
      end

      swagger_schema :AppointmentsResponse do
        property :appointments do
          items do
            property :id do
              key :type, :integer
              key :example, 10
            end
             property :bookable_at do
              key :type, :string
              key :example, "2017-12-15T14:36:44.000Z"
            end
            property :picture_url do
              key :type, :string
            end
            property :adress do
              key :type, :string
            end
            property :distance do
              key :type, :number
              key :example, 34.57
            end
            property :working_hours do
              key :'$ref', :WorkingHours
            end
          end
        end
        property :total_count do
          key :type, :integer
          key :example, 35
        end
      end

      swagger_schema :AppointmentResponse do
        property :appointment do
          property :id do
            key :type, :integer
            key :example, 10
          end
           property :bookable_at do
            key :type, :string
            key :example, "2017-12-15T14:36:44.000Z"
          end
          property :picture_url do
            key :type, :string
          end
          property :adress do
            key :type, :string
          end
          property :distance do
            key :type, :number
            key :example, 34.57
          end
          property :working_hours do
            key :'$ref', :WorkingHours
          end
        end
      end

      swagger_path '/appointments' do
        operation :post do
          key :description, 'Create an appointment'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Appointments]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :appointment
            key :in, :body
            key :required, true
            key :description, "Bookable_type: Clinic/DayCareCentre/GroomingCentre\n" +
                              "vet_id - required if bookable_type - Clinic\n" +
                              'bookable_type, bookable_id, booked_at, pet_id - required'

            schema do
              key :'$ref', :AppointmentInput
            end
          end

          response 200 do
            key :description, 'Success response'
          end
        end

        operation :get do
          key :description, 'Get all appointments'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Appointments]

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
            key :name, :past
            key :in, :query
            key :type, :boolean
            key :example, false
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :AppointmentsResponse
            end
          end
        end
      end

      swagger_path '/pets/{id}/health_history' do
        operation :get do
          key :description, 'Show pet health history'
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
          parameter do
            key :name, :page
            key :in, :query
            key :type, :integer
            key :example, 1
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :AppointmentsResponse
            end
          end
        end
      end

      swagger_path '/appointments/{id}' do
        operation :get do
          key :description, 'Show appointment'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %w[Appointments]

          security do
            key :api_key, []
          end
          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :required, true
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
              key :'$ref', :AppointmentResponse
            end
          end
        end
      end
    end
  end
end

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
          property :pet_ids do
            key :type, :array
            key :example, [1]
          end
          property :vet_id do
            key :type, :integer
            key :example, 1
          end
          property :start_at do
            key :type, :integer
            key :example, 1516318200
          end
          property :number_of_days do
            key :type, :integer
            key :example, 10
          end
          property :comment do
            key :type, :string
          end
          property :cart_items_attributes do
            items do
              key :'$ref', :CartItemInput
            end
          end
        end
      end

      swagger_schema :CartItemInput do
        property :pet_id do
          key :type, :integer
          key :example, 1
        end
        property :serviceable_type do
          key :type, :string
          key :example, 'ServiceDetail'
        end
        property :serviceable_id do
          key :type, :integer
          key :example, 1
        end
      end

      swagger_schema :AppointmentsResponse do
        property :appointments do
          items do
            property :id do
              key :type, :integer
              key :example, 10
            end
             property :start_at do
              key :type, :integer
              key :example, 1516318200
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

      swagger_schema :PetAppointmentResponse do
        property :id do
          key :type, :integer
          key :example, 1
        end
        property :avatar_url do
          key :type, :string
        end
        property :name do
          key :type, :string
          key :example, 'Pluto'
        end
        property :service_details do
          key :'$ref', :PetServices
        end
        property :diagnosis do
          key :'$ref', :DiagnosisResponse
        end
        property :diagnosis do
          key :'$ref', :DiagnosisResponse
        end
      end

      swagger_schema :PetServices do
        items do
          property :id do
            key :type, :integer
            key :example, 1
          end
          property :name do
            key :type, :string
            key :example, 'Service 3'
          end
          property :price do
            key :type, :integer
            key :example, 345
          end
        end
      end

      swagger_schema :DiagnosisResponse do
        property :condition do
          key :type, :string
          key :example, 'All good. No lockers'
        end
        property :message do
          key :type, :string
          key :example, 'Some message'
        end
        property :recipes do
          key :type, :array
          key :example, ['1st recipe', '2nd recipe']
        end
      end

      swagger_schema :AppointmentResponse do
        property :appointment do
          property :id do
            key :type, :integer
            key :example, 10
          end
          property :time_slot do
            property :start_at do
              key :type, :integer
              key :example, 1516217199
            end
            property :end_at do
              key :type, :integer
              key :example, 1516217199
            end
            property :number_of_days do
              key :type, :integer
              key :example, 10
            end
          end
          property :comment do
            key :type, :string
            key :example, 'comment'
          end
          property :bookable_type do
            key :type, :string
            key :example, "Clinic"
          end
          property :vet do
            key :'$ref', :VetResponse
          end
          property :booked_object do
            key :'$ref', :Clinic
          end
          property :pets do
            key :'$ref', :PetAppointmentResponse
          end
          property :next_appointment do
            key :type, :integer
            key :example, 1516318200
          end
          property :service_option_details do
            items do
              key :'$ref', :ServiceOptionDetail
            end
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
            key :description, "Bookable_type: Clinic/DayCareCentre/GroomingCentre/Boarding\n" +
                              "vet_id & pet_ids - required if bookable_type - Clinic\n" +
                              "bookable_type, bookable_id, start_at, pet_id - required\n" +
                              "cart_items_attributes - required ib bookable type NOT A CLINIC\n" +
                              'serviceable_type - ServiceDetail/ServiceOptionDetail'

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

      swagger_path '/appointments/{id}/cancel' do
        operation :put do
          key :description, 'Cancel appointment'
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

          response 200 do
            key :description, 'Success response'
          end
        end
      end
    end
  end
end

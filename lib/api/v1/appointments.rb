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
      end
    end
  end
end

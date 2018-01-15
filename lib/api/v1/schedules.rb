module Api
  module V1
    class Schedules < ActionController::Base
      include Swagger::Blocks

      swagger_schema :ScheduleResponse do
        property :time_slots do
          items do
            property :start_at do
              key :type, :string
              key :example, '10:00 AM'
            end
          end
        end
      end

      swagger_schema :ScheduleWithEndResponse do
        property :time_slots do
          items do
            property :start_at do
              key :type, :string
              key :example, '10:00 AM'
            end

            property :end_at do
              key :type, :string
              key :example, '10:30 AM'
            end
          end
        end
      end

      swagger_path '/grooming_centres/{id}/schedule' do
        operation :get do
          key :description, 'Get grooming centre schedule. All params are required'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Grooming\ Centres Schedules]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :example, 1
          end

          parameter do
            key :name, :date
            key :in, :query
            key :type, :string
            key :example, '10 Jan 2018'
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :ScheduleResponse
            end
          end
        end
      end

      swagger_path '/day_care_centres/{id}/schedule' do
        operation :get do
          key :description, 'Get daycare centre schedule. All params are required'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Day\ Care\ Centres Schedules]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :example, 1
          end

          parameter do
            key :name, :date
            key :in, :query
            key :type, :string
            key :example, '10 Jan 2018'
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :ScheduleResponse
            end
          end
        end
      end

      swagger_path '/vets/{id}/schedule' do
        operation :get do
          key :description, 'Get vet schedule. All params are required'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Vets Schedules]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :example, 1
          end

          parameter do
            key :name, :date
            key :in, :query
            key :type, :string
            key :example, '10 Jan 2018'
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :ScheduleWithEndResponse
            end
          end
        end
      end
    end
  end
end

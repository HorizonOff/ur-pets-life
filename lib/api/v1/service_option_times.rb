module Api
  module V1
    class ServiceOptionTimes < ActionController::Base
      include Swagger::Blocks

      swagger_schema :ServiceOptionTimesResponse do
        property :time_ranges do
          items do
            key :'$ref', :ServiceOptionTime
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
        property :service_option_times do
          items do
            key :'$ref', :ServiceOptionTime
          end
        end
      end

      swagger_schema :ServiceOptionTime do
        property :id do
          key :type, :integer
          key :example, 1
        end
        property :time_range do
          key :type, :string
          key :example, '4AM - 5AM'
        end
      end

      swagger_path '/service_option_details/{id}/time_ranges' do
        operation :get do
          key :description, 'Get Services time ranges'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Time\ ranges]

          security do
            key :api_key, []
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
              key :'$ref', :ServiceOptionTimesResponse
            end
          end
        end
      end
    end
  end
end

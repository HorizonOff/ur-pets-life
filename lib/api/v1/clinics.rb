module Api
  module V1
    class Clinics < ActionController::Base
      include Swagger::Blocks

      swagger_path '/clinics' do
        operation :get do
          key :description, 'Get clinics'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %w[Clinics]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :longitude
            key :in, :query
            key :type, :number
            key :example, 48.6208
          end

          parameter do
            key :name, :latitude
            key :in, :query
            key :type, :number
            key :example, 22.287883
          end

          parameter do
            key :name, :time_zone
            key :in, :query
            key :type, :integer
            key :example, 3
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end

      swagger_path '/clinics/{id}' do
        operation :get do
          key :description, 'Get clinic'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %w[Clinics]

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
            key :name, :longitude
            key :in, :query
            key :type, :number
            key :example, 48.6208
          end

          parameter do
            key :name, :latitude
            key :in, :query
            key :type, :number
            key :example, 22.287883
          end

          parameter do
            key :name, :time_zone
            key :in, :query
            key :type, :integer
            key :example, 3
          end


          response 200 do
            key :description, 'Success response'
          end
        end
      end
    end
  end
end

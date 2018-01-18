module Api
  module V1
    class Weights < ActionController::Base
      include Swagger::Blocks

      swagger_schema :WeightsResponse do
        property :weights do
          items do
            property :date do
              key :type, :integer
              key :example, 1516217199
            end
            property :weight do
              key :type, :number
              key :example, 2
            end
          end
        end
      end

      swagger_path '/pets/{id}/weight_history' do
        operation :get do
          key :description, 'Show pet weight history'
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

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :WeightsResponse
            end
          end
        end
      end
    end
  end
end

module Api
  module V1
    class Sales < ActionController::Base
      include Swagger::Blocks

      swagger_path '/sale_categories' do
        operation :get do
          key :description, 'Names of sale categories'
          key :consumes, %w[application/json]
          key :consumes, %w[application/json]
          key :tags, %w[Sale]

          response 200 do
            key :description, 'Success response'
          end
        end
      end
    end
  end
end

module Api
  module V1
    class VaccineTypes < ActionController::Base
      include Swagger::Blocks

      swagger_path '/vaccine_types' do
        operation :get do
          key :description, 'Get available types of vaccine for pet'
          key :consumes, %w[application/json]
          key :consumes, %w[application/json]
          key :tags, %W[Vaccine\ types]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :pet_category
            key :in, :query
            key :required, true
            key :description, "cat/dog/other"
            key :type, :string
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end
    end
  end
end

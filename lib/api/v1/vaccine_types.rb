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
            key :name, :pet_type_id
            key :in, :query
            key :required, true
            key :description, "Available pet_types look pet_types documantation.\n" +
                               'cat = 1 dog = 2 other= 3'
            key :type, :integer
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end
    end
  end
end

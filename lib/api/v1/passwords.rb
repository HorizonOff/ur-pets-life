module Api
  module V1
    class Passwords < ActionController::Base
      include Swagger::Blocks

      swagger_path '/passwords/forgot' do
        operation :post do
          key :description, 'Forgot password'
          key :produces, %w[multipart/form-data]
          key :consumes, %w[multipart/form-data]
          key :tags, %w[Psaswords]

          parameter do
            key :name, :email
            key :in, :formData
            key :required, true
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

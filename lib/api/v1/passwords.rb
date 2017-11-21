module Api
  module V1
    class Passwords < ActionController::Base
      include Swagger::Blocks

      swagger_path '/passwords' do
        operation :put do
          security do
            key :api_key, []
          end

          key :description, 'Change password'
          key :produces, %w[multipart/form-data]
          key :consumes, %w[multipart/form-data]
          key :tags, %w[Psaswords]

          parameter do
            key :name, :current_password
            key :in, :formData
            key :required, true
            key :type, :string
          end

          parameter do
            key :name, :password
            key :in, :formData
            key :required, true
            key :type, :string
          end

          parameter do
            key :name, :password_confirmation
            key :in, :formData
            key :required, true
            key :type, :string
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end

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

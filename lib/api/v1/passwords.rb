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
          key :produces, 'application/json'
          key :consumes, 'application/json'
          key :tags, %w[Passwords]

          parameter do
            key :name, :body
            key :in, :body
            key :required, true

            schema do
              property :current_password do
                key :type, :string
              end
              property :password do
                key :type, :string
              end
              property :password_confirmation do
                key :type, :string
              end
            end
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end

      swagger_path '/passwords/forgot' do
        operation :post do
          key :description, 'Forgot password'
          key :produces, 'application/json'
          key :consumes, 'application/json'
          key :tags, %w[Passwords]

          parameter do
            key :name, :body
            key :in, :body
            key :required, true

            schema do
              property :email do
                key :type, :string
              end
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

module Api
  module V1
    class Sessions < ActionController::Base
      include Swagger::Blocks

      # swagger_schema :Devise do
      #   property :device_type do
      #     key :type, :string
      #   end

      #   property :device_id do
      #     key :type, :string
      #   end

      #   property :push_token do
      #     key :type, :email
      #   end
      # end

      # swagger_schema :SignInParams do
      #   property :email do
      #     key :type, :string
      #   end
      #   property :password do
      #     key :type, :string
      #   end
      # end

      # swagger_path '/sessions' do
      #   operation :post do
      #     key :description, 'User Sign in'
      #     key :produces, %w[multipart/form-data]
      #     key :consumes, %w[multipart/form-data]
      #     # key :consumes, %w[application/json]
      #     # key :consumes, %w[application/json]
      #     key :tags, %w[Sessions]

      #     parameter do
      #       key :name, :email
      #       key :in, :formData
      #       key :required, true
      #       key :type, :string
      #     end
      #     parameter do
      #       key :name, :password
      #       key :in, :formData
      #       key :required, true
      #       key :type, :password
      #     end
      #     parameter do
      #       key :name, :device_type
      #       key :in, :formData
      #       key :required, true
      #       key :type, :string
      #     end
      #     parameter do
      #       key :name, :device_id
      #       key :in, :formData
      #       key :required, true
      #       key :type, :string
      #     end
      #     parameter do
      #       key :name, :push_token
      #       key :in, :formData
      #       key :required, true
      #       key :type, :string
      #     end

      #     response 200 do
      #       key :description, 'Success response'
      #     end
      #   end
      # end
      swagger_path '/sessions' do
        operation :post do
          key :description, 'Sign in via email'
          key :produces, %w[multipart/form-data]
          key :consumes, %w[multipart/form-data]
          key :tags, %w[Sessions]

          parameter do
            key :name, :email
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
            key :name, :device_type
            key :in, :formData
            key :required, true
            key :type, :string
          end
          parameter do
            key :name, :device_id
            key :in, :formData
            key :required, true
            key :type, :string
          end
          parameter do
            key :name, :push_token
            key :in, :formData
            key :required, true
            key :type, :string
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end

      swagger_path '/sessions/facebook' do
        operation :post do
          key :description, 'Sign in via facebook'
          key :produces, %w[multipart/form-data]
          key :consumes, %w[multipart/form-data]
          key :tags, %w[Sessions]

          parameter do
            key :name, :access_token
            key :in, :formData
            key :required, true
            key :type, :string
          end
          parameter do
            key :name, :device_type
            key :in, :formData
            key :required, true
            key :type, :string
          end
          parameter do
            key :name, :device_id
            key :in, :formData
            key :required, true
            key :type, :string
          end
          parameter do
            key :name, :push_token
            key :in, :formData
            key :required, true
            key :type, :string
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end

      swagger_path '/sessions/google' do
        operation :post do
          key :description, 'Sign in via google'
          key :produces, %w[multipart/form-data]
          key :consumes, %w[multipart/form-data]
          key :tags, %w[Sessions]

          parameter do
            key :name, :access_token
            key :in, :formData
            key :required, true
            key :type, :string
          end
          parameter do
            key :name, :device_type
            key :in, :formData
            key :required, true
            key :type, :string
          end
          parameter do
            key :name, :device_id
            key :in, :formData
            key :required, true
            key :type, :string
          end
          parameter do
            key :name, :push_token
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
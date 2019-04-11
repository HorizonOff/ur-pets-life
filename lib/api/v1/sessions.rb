module Api
  module V1
    class Sessions < ActionController::Base
      include Swagger::Blocks

      swagger_path '/sessions' do
        operation :post do
          key :description, 'Sign in via email'
          key :produces, 'application/json'
          key :consumes, 'application/json'
          key :tags, %w[Sessions]

          parameter do
            key :name, :body
            key :in, :body
            key :description, "Device_type: 'ios' or 'android'.\nPush_token: optional"
            key :required, true

            schema do
              property :email do
                key :type, :string
                key :example, 'omerbinjamal@gmail.com'
              end
              property :password do
                key :type, :string
                key :example, '11111111'
              end
              property :device_type do
                key :type, :string
                key :example, 'ios'
              end
              property :device_id do
                key :type, :string
              end
              property :push_token do
                key :type, :string
              end
            end
          end

          response 200 do
            key :description, 'Success response'
          end
        end

        operation :delete do
          security do
            key :api_key, []
          end

          key :description, 'Sign out'
          key :produces, %w[application/json]
          key :consumes, %w[application/json]
          key :tags, %w[Sessions]

          response 200 do
            key :description, 'Success response'
          end
        end
      end

      swagger_path '/sessions/facebook' do
        operation :post do
          key :description, 'Sign in via facebook'
          key :produces, 'application/json'
          key :consumes, 'application/json'
          key :tags, %w[Sessions]

          parameter do
            key :name, :body
            key :in, :body
            key :description, "Device_type: 'ios' or 'android'.\nPush_token: optional"
            key :required, true

            schema do
              property :access_token do
                key :type, :string
              end
              property :device_type do
                key :type, :string
              end
              property :device_id do
                key :type, :string
              end
              property :push_token do
                key :type, :string
              end
            end
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end

      swagger_path '/sessions/google' do
        operation :post do
          key :description, 'Sign in via google'
          key :produces, 'application/json'
          key :consumes, 'application/json'
          key :tags, %w[Sessions]

          parameter do
            key :name, :body
            key :in, :body
            key :description, "Device_type: 'ios' or 'android'.\nPush_token: optional"
            key :required, true

            schema do
              property :access_token do
                key :type, :string
              end
              property :device_type do
                key :type, :string
              end
              property :device_id do
                key :type, :string
              end
              property :push_token do
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

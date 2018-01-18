module Api
  module V1
    class Users < ActionController::Base
      include Swagger::Blocks

      swagger_schema :User do
        property :first_name do
          key :type, :string
        end
        property :last_name do
          key :type, :string
        end
        property :email do
          key :type, :email
        end
        property :mobile_number do
          key :type, :string
        end
        property :facebook_id do
          key :type, :string
        end
        property :google_id do
          key :type, :string
        end
        property :password do
          key :type, :string
        end
        property :password_confirmation do
          key :type, :string
        end
      end

      swagger_schema :UserFields do
        property :first_name do
          key :type, :string
        end
        property :last_name do
          key :type, :string
        end
        property :email do
          key :type, :email
        end
        property :mobile_number do
          key :type, :string
        end
      end

      swagger_schema :Location do
        property :latitude do
          key :type, :number
          key :example, 48.6208
        end
        property :longitude do
          key :type, :number
          key :example, 22.287883
        end
        property :city do
          key :type, :string
          key :example, 'Uzhgorod'
        end
        property :area do
          key :type, :string
        end
        property :street do
          key :type, :string
        end
        property :building_type do
          key :type, :string
        end
        property :building_name do
          key :type, :string
        end
        property :unit_number do
          key :type, :string
        end
        property :villa_number do
          key :type, :string
        end
        property :comment do
          key :type, :string
        end
      end

      swagger_schema :UserInput do
        allOf do
          schema do
            property :user do
              key :'$ref', :User
              property :location_attributes do
                key :'$ref', :Location
              end
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
      end

      swagger_schema :UserResponse do
        allOf do
          schema do
            property :user do
              key :'$ref', :UserFields
              property :location_attributes do
                key :'$ref', :Location
              end
            end
          end
        end
      end

      swagger_path '/users' do
        operation :post do
          key :description, 'User registration'
          key :consumes, %w[application/json]
          key :consumes, %w[application/json]
          key :tags, %w[Users]

          parameter do
            key :name, :user
            key :in, :body
            key :required, true
            key :description, "facebook_id, google_id, mobile_number, location_attributes - optional\n" +
                              "building_type: 0 for building(or 'building'), 1 for villa (or 'villa')"

            schema do
              key :'$ref', :UserInput
            end
          end

          response 200 do
            key :description, 'Success response'
          end
        end

        operation :put do
          key :description, 'Update profile info'
          key :consumes, %w[application/json]
          key :consumes, %w[application/json]
          key :tags, %w[Users]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :user
            key :in, :body
            key :required, true
            key :description, "building_type: 0 for building(or 'building'), 1 for villa (or 'villa')"

            schema do
              property :user do
                property :first_name do
                  key :type, :string
                end
                property :last_name do
                  key :type, :string
                end
                property :email do
                  key :type, :email
                end
                property :mobile_number do
                  key :type, :string
                end
                property :location_attributes do
                  key :'$ref', :Location
                end
              end
            end
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end

      swagger_path '/users/profile' do
        operation :get do
          key :description, "Get user's profile info"
          key :consumes, %w[application/json]
          key :consumes, %w[application/json]
          key :tags, %w[Users]

          security do
            key :api_key, []
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :UserResponse
            end
          end
        end
      end
    end
  end
end

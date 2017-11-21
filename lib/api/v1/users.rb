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
        property :password do
          key :type, :password
        end

        property :password_confirmation do
          key :type, :password
        end
        property :location_attributes do
        end
      end


      swagger_schema :UserUpdate do
        property :first_name do
          key :type, :string
        end

        property :last_name do
          key :type, :string
        end

        property :email do
          key :type, :email
        end
        property :location_attributes do
        end
      end

      swagger_schema :Location do
        property :latitude do
          key :type, :float
        end
        property :longitude do
          key :type, :float
        end

        property :country do
          key :type, :string
        end
        property :city do
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

            schema do
              property :user do
                property :first_name do
                  key :type, :string
                end
                property :last_name do
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
    end
  end
end
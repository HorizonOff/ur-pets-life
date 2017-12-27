module Api
  module V1
    class LostAndFounds < ActionController::Base
      include Swagger::Blocks
      swagger_schema :LostAndFoundResponse do
        property :pet do
          property :id do
            key :type, :integer
            key :example, 10
          end
          property :avatar_url do
            key :type, :string
          end
          property :name do
            key :type, :string
            key :example, 'Pluto'
          end
          property :comment do
            key :type, :string
          end
          property :mobile_number do
            key :type, :string
            key :example, '+34053452392300'
          end
          property :address do
            key :type, :string
            key :example, 'Uzhgorod'
          end
          property :distance do
            key :type, :number
            key :example, 34
          end
          property :pictures do
            items do
              key :'$ref', :Picture
            end
          end
        end
      end

      swagger_schema :LostAndFoundsResponse do
        property :pets do
          items do
            property :id do
              key :type, :integer
              key :example, 10
            end
            property :avatar_url do
              key :type, :string
            end
            property :name do
              key :type, :string
              key :example, 'Pluto'
            end
            property :pet_type_id do
              key :type, :integer
              key :example, 2
            end
            property :address do
              key :type, :string
              key :example, 'Dubai'
            end
            property :distance do
              key :type, :number
              key :example, 34
            end
            property :lost_at do
              key :type, :string
              key :example, '2017-12-12T11:13:40Z'
            end
            property :found_at do
              key :type, :string
              key :example, nil
            end
          end
        end
      end


      swagger_path '/lost_and_founds' do
        operation :get do
          key :description, 'Get all lost or found pets'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Lost\ and\ Found]

          parameter do
            key :name, :longitude
            key :in, :query
            key :type, :number
            key :example, 22.287883
          end

          parameter do
            key :name, :latitude
            key :in, :query
            key :type, :number
            key :example, 48.6208
          end

          parameter do
            key :name, :found
            key :in, :query
            key :type, :boolean
          end

          parameter do
            key :name, :page
            key :in, :query
            key :type, :integer
            key :example, 1
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :LostAndFoundsResponse
            end
          end
        end
      end


      swagger_path '/lost_and_founds/{id}' do
        operation :get do
          key :description, 'Show lost or found pet'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Lost\ and\ Found]

          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :required, true
          end
          parameter do
            key :name, :longitude
            key :in, :query
            key :type, :number
            key :example, 22.287883
          end

          parameter do
            key :name, :latitude
            key :in, :query
            key :type, :number
            key :example, 48.6208
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :LostAndFoundResponse
            end
          end
        end
      end

      swagger_path '/pets/can_be_lost' do
        operation :get do
          key :description, 'Get list of users pets that can be lost'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %w[Pets Lost\ and\ Found]

          security do
            key :api_key, []
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :PetsResponse
            end
          end
        end
      end
    end
  end
end

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

      swagger_schema :LostInput do
        allOf do
          schema do
            property :pet do
              key :'$ref', :LostFields
              property :location_attributes do
                key :'$ref', :Location
              end
            end
          end
        end
      end

      swagger_schema :LostFields do
        property :lost_at do
          key :type, :string
          key :example, '2017-12-12T11:13:40Z'
        end
        property :description do
          key :type, :string
          key :example, 'Black cat'
        end
        property :mobile_number do
          key :type, :string
          key :example, '+34053452392300'
        end
        property :additional_comment do
          key :type, :string
          key :example, 'Help me'
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

      swagger_path '/pets/{id}/lost' do
        operation :put do
          key :description, 'Pet is lost'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %w[Pets Lost]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :required, true
          end

          parameter do
            key :name, :pet
            key :in, :body
            key :required, true
            key :description, "You can send only 1 pair of attributes\n" +
                              'is_lost - false OR is_for_adoption:: true/false'

            schema do
              key :'$ref', :LostInput
            end
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end

      swagger_path '/pets/{id}/change_status' do
        operation :put do
          key :description, 'Update pet lost and adoption statuses'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %w[Pets Lost Adoption]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :required, true
          end

          parameter do
            key :name, :pet
            key :in, :body
            key :required, true
            key :description, "You can send only 1 pair of attributes\n" +
                              'is_lost - false OR is_for_adoption:: true/false'

            schema do
              property :pet do
                property :is_lost do
                  key :type, :boolean
                  key :example, false
                end
                property :is_for_adoption do
                  key :type, :boolean
                end
              end
            end
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end


      swagger_path '/pets/found' do
        operation :post do
          key :description, 'Found pet'
          key :consumes, %w[multipart/form-data]
          key :produces, %w[application/json]
          key :tags, %w[Pets Found]

          security do
            key :api_key, []
          end

          parameter do
            key :name, 'pet[description]'
            key :in, :formData
            key :required, true
            key :type, :string
            key :example, 'Black cat'
          end
          parameter do
            key :name, 'pet[found_at]'
            key :in, :formData
            key :required, true
            key :type, :string
            key :example, '2017-12-12T11:13:40Z'
          end
          parameter do
            key :name, 'pet[pet_type_id]'
            key :in, :formData
            key :required, true
            key :type, :integer
            key :example, 1
          end
          parameter do
            key :name, 'pet[additional_type]'
            key :in, :formData
            key :type, :string
            key :description, 'Required if pet_type_id - 3 - Other'
          end
          parameter do
            key :name, 'pet[additional_comment]'
            key :in, :formData
            key :type, :string
            key :example, 'Help me'
          end
          parameter do
            key :name, 'pet[mobile_number]'
            key :in, :formData
            key :type, :string
            key :example, '+34053452392300'
          end
          parameter do
            key :name, 'pet[avatar]'
            key :in, :formData
            key :type, :file
          end

          parameter do
            key :name, 'pet[location_attributes][latitude]'
            key :in, :formData
            key :type, :number
            key :example, 48.6208
          end
          parameter do
            key :name, 'pet[location_attributes][longitude]'
            key :in, :formData
            key :type, :number
            key :example, 22.287883
          end
          parameter do
            key :name, 'pet[location_attributes][city]'
            key :in, :formData
            key :type, :string
            key :example, 'Uzhgorod'
          end
          parameter do
            key :name, 'pet[location_attributes][area]'
            key :in, :formData
            key :type, :string
          end
          parameter do
            key :name, 'pet[location_attributes][street]'
            key :in, :formData
            key :type, :string
          end
          parameter do
            key :name, 'pet[location_attributes][building_type]'
            key :in, :formData
            key :type, :integer
            key :example, 0
          end
          parameter do
            key :name, 'pet[location_attributes][unit_number]'
            key :in, :formData
            key :type, :integer
          end
          parameter do
            key :name, 'pet[location_attributes][villa_number]'
            key :in, :formData
            key :type, :integer
          end
          parameter do
            key :name, 'pet[location_attributes][comment]'
            key :in, :formData
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

module Api
  module V1
    class Pets < ActionController::Base
      include Swagger::Blocks

      swagger_schema :VaccinationInput do
        property :vaccine_type_id do
          key :type, :integer
        end
        property :done_at do
          key :type, :integer
        end
      end
      swagger_schema :VaccinationUpdate do
        property :id do
          key :type, :integer
        end
        property :vaccine_type_id do
          key :type, :integer
        end
        property :done_at do
          key :type, :datetime
        end
        property :_destroy do
          key :type, :boolean
        end
      end

      swagger_path '/pets' do
        operation :get do
          key :description, 'Get all pets'
          key :consumes, %w[application/json]
          key :consumes, %w[application/json]
          key :tags, %w[Pets]

          security do
            key :api_key, []
          end

          response 200 do
            key :description, 'Success response'
          end
        end

        operation :post do
          key :description, 'Create pet'
          key :consumes, %w[application/json]
          key :consumes, %w[application/json]
          key :tags, %w[Pets]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :pet
            key :in, :body
            key :required, true
            key :description, "Name, birthday, pet_type_id, sex: required.\n" + \
                              "Sex: 'male' or 0, 'female' or 1.\n Breed_id: 'null/valid_id'" + \
                              "Additional_type required if Pet type is Other"

            schema do
              property :pet do
                property :name do
                  key :type, :string
                end
                property :birthday do
                  key :type, :datetime
                end
                property :pet_type_id do
                  key :type, :integer
                end
                property :additional_type do
                  key :type, :string
                end
                property :sex do
                  key :type, :string
                end
                property :breed_id do
                  key :type, :integer
                end
                property :weight do
                  key :type, :float
                end
                property :comment do
                  key :type, :text
                end
                property :vaccinations_attributes do
                  items do
                    key :'$ref', :VaccinationInput
                  end
                end
              end
            end
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end

      swagger_path '/pets/{id}' do
        operation :get do
          key :description, 'Show pet'
          key :consumes, %w[application/json]
          key :consumes, %w[application/json]
          key :tags, %w[Pets]

          security do
            key :api_key, []
          end
          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :required, true
          end

          response 200 do
            key :description, 'Success response'
          end
        end

        operation :put do
          key :description, 'Update pet'
          key :consumes, %w[application/json]
          key :consumes, %w[application/json]
          key :tags, %w[Pets]

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
            key :description, "Name, birthday, pet_type_id, sex: required.\n" + \
                              "Sex: 'male' or 0, 'female' or 1.\n Breed_id: 'null/valid_id'" + \
                              "Additional_type required if Pet type is Other"

            schema do
              property :pet do
                property :name do
                  key :type, :string
                end
                property :birthday do
                  key :type, :datetime
                end
                property :additional_type do
                  key :type, :string
                end
                property :sex do
                  key :type, :string
                end
                property :breed_id do
                  key :type, :integer
                end
                property :weight do
                  key :type, :float
                end
                property :comment do
                  key :type, :text
                end

                property :vaccinations_attributes do
                  items do
                    key :'$ref', :VaccinationUpdate
                  end
                end
              end
            end
          end

          response 200 do
            key :description, 'Success response'
          end
        end

        operation :delete do
          key :description, 'delete pet'
          key :consumes, %w[application/json]
          key :consumes, %w[application/json]
          key :tags, %w[Pets]

          security do
            key :api_key, []
          end
          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :required, true
          end
          response 200 do
            key :description, 'Success response'
          end
        end
      end
    end
  end
end

module Api
  module V1
    class Pets < ActionController::Base
      include Swagger::Blocks

      swagger_path '/pets' do
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
            key :description, "Name, birthday, category, sex: required.\n" + \
                              "Category: 'cat/dog/other'.\n Sex: 'male/female'.\n Breed_id: 'null/valid_id'"

            schema do
              property :pet do
                property :name do
                  key :type, :string
                end
                property :birthday do
                  key :type, :datetime
                end
                property :category do
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
              end
            end
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end

      swagger_path '/pets/{id}' do
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
            key :description, "Name, birthday, category, sex: required.\n" + \
                              "Category: 'cat/dog/other'.\n Sex: 'male/female'.\n Breed_id: 'null/valid_id'"


            schema do
              property :pet do
                property :name do
                  key :type, :string
                end
                property :birthday do
                  key :type, :datetime
                end
                property :category do
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

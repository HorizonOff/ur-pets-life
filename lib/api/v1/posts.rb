module Api
  module V1
    class Posts < ActionController::Base
      include Swagger::Blocks

      swagger_schema :PostInput do
        property :post do
          property :title do
            key :type, :string
            key :example, 'Title'
          end
           property :message do
            key :type, :string
            key :example, 'Message'
          end
          property :pet_type_id do
            key :type, :integer
            key :example, 1
          end
        end
      end

      swagger_schema :PostsResponse do
        property :posts do
          items do
            property :id do
              key :type, :integer
              key :example, 1
            end
            property :title do
              key :type, :string
              key :example, 'Title'
            end
            property :message do
              key :type, :string
              key :example, 'Message'
            end
            property :comments_count do
              key :type, :integer
              key :example, 1
            end
            property :user_name do
              key :type, :string
              key :example, 'Batman'
            end
            property :avatar_url do
              key :type, :string
            end
            property :created_at do
              key :type, :integer
              key :example, 345324323
            end
          end
        end
        property :total_count do
          key :type, :integer
          key :example, 35
        end
      end

      swagger_path '/posts' do
        operation :post do
          key :description, 'Create post'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Posts]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :post
            key :in, :body
            key :required, true

            schema do
              key :'$ref', :PostInput
            end
          end

          response 200 do
            key :description, 'Success response'
          end
        end

        operation :get do
          key :description, 'Get all posts'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Posts]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :created_at
            key :in, :query
            key :type, :integer
            key :example, 1516217199
            key :required, true
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :PostsResponse
            end
          end
        end
      end
    end
  end
end

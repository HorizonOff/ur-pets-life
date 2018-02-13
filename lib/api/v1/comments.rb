module Api
  module V1
    class Comments < ActionController::Base
      include Swagger::Blocks

      swagger_schema :CommentInput do
        property :comment do
          property :message do
            key :type, :string
            key :example, 'Message'
          end
        end
      end

      swagger_schema :CommentsResponse do
        property :comments do
          items do
            property :id do
              key :type, :integer
              key :example, 1
            end
            property :message do
              key :type, :string
              key :example, 'Message'
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

      swagger_path '/posts/{id}/comments' do
        operation :post do
          key :description, 'Create comment'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Comments]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :example, 1
            key :required, true
          end

          parameter do
            key :name, :comment
            key :in, :body
            key :required, true

            schema do
              key :'$ref', :CommentInput
            end
          end

          response 200 do
            key :description, 'Success response'
          end
        end

        operation :get do
          key :description, 'Get all comments'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Comments]

          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :example, 1
            key :required, true
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
              key :'$ref', :CommentsResponse
            end
          end
        end
      end
    end
  end
end

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
          property :mobile_image_url do
            key :type, :string
            key :example, 'https://s3.eu-central-1.amazonaws.com/urpets-dev/urpets/uploads/item/picture/15/Big___Small_Pumkins.JPG'
          end
        end
      end

      swagger_schema :PostCommentsResponse do
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

      swagger_schema :AppointmentCommentsResponse do
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
        property :title do
          key :type, :string
          key :example, 'Clinic'
        end
        property :message do
          key :type, :string
          key :example, 'message'
        end
        property :created_at do
          key :type, :integer
          key :example, 345324323
        end
        property :unread_comments_count_by_user do
          key :type, :integer
          key :example, 1
        end
        property :unread_commented_appointments_count do
          key :type, :integer
          key :example, 2
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
              key :'$ref', :PostCommentsResponse
            end
          end
        end
      end


      swagger_path '/appointments/{id}/comments' do
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
            key :name, :created_at
            key :in, :query
            key :type, :integer
            key :example, 1516217199
            key :required, true
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :AppointmentCommentsResponse
            end
          end
        end
      end
    end
  end
end

module Api
  module V1
    class Notifications < ActionController::Base
      include Swagger::Blocks

      swagger_schema :UnreadNotificationsResponse do
        property :unread_notifications_count do
          key :type, :integer
          key :example, 35
        end
      end

      swagger_schema :NotificationsResponse do
        property :notifications do
          items do
            property :id do
              key :type, :integer
              key :example, 1
            end
            property :message do
              key :type, :string
              key :example, 'Message'
            end
            property :source_type do
              key :type, :string
              key :example, 'appointment, pet, lost'
            end
            property :source_id do
              key :type, :integer
              key :example, 1
            end
            property :avatar_url do
              key :type, :string
            end
            property :created_at do
              key :type, :integer
              key :example, 345324323
            end
            property :viewed_at do
              key :type, :string
            end
          end
        end
        property :total_count do
          key :type, :integer
          key :example, 35
        end
        property :unread_notifications_count do
          key :type, :integer
          key :example, 35
        end
      end

      swagger_path '/notifications' do
        operation :get do
          key :description, 'Get all notifications'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Notifications]

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
              key :'$ref', :NotificationsResponse
            end
          end
        end
      end

      swagger_path '/notifications/unread' do
        operation :get do
          key :description, 'Get unread notifications count'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Notifications]

          security do
            key :api_key, []
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :UnreadNotificationsResponse
            end
          end
        end
      end
    end
  end
end

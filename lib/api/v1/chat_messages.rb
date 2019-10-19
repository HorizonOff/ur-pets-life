module Api
  module V1
    class ChatMessages < ActionController::Base
      include Swagger::Blocks

      swagger_path '/chat_messages' do
        operation :post do
          key :description, 'create chat messsage'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %w[ChatMessages]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :chat_message
            key :in, :body
            key :required, true

            schema do
              key :'$ref', :ChatMessageInput
            end
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end

      swagger_schema :ChatMessageInput do
        property :chat_message do
          property :text do
            key :type, :string
            key :example, 'Message'
          end
          property :m_type do
            key :type, :string
            key :example, 'user'
          end
          property :mobile_photo_url do
            key :type, :string
            key :example, 'https://s3.eu-central-1.amazonaws.com/urpets-dev/urpets/uploads/item/picture/15/Big___Small_Pumkins.JPG'
          end
          property :mobile_video_url do
            key :type, :string
            key :example, 'https://s3.eu-central-1.amazonaws.com/urpets-dev/SampleVideo_1280x720_1mb.mp4'
          end
          property :video_duration do
            key :type, :integer
            key :example, 10
          end
        end
      end
    end
  end
end

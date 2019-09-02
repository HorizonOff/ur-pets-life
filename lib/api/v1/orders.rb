module Api
  module V1
    class Orders < ActionController::Base
      include Swagger::Blocks

      swagger_path '/orders' do
        operation :post do
          key :description, 'Create order'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Orders]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :body
            key :in, :body
            key :required, true

            schema do
              key :'$ref', :OrderInput
            end
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end

      swagger_path '/orders/{id}' do
        operation :patch do
          key :description, 'Create order'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Orders]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :example, 1
          end

          parameter do
            key :name, :body
            key :in, :body
            key :required, true

            schema do
              property :TransactionId do
                key :type, :string
                key :example, '13546546'
              end
              property :TransactionDate do
                key :type, :string
                key :example, '17/04/2019'
              end
            end
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end

      swagger_schema :OrderInput do
        property :IsCash do
          key :type, :integer
          key :example, 0
        end
         property :Order_Notes do
          key :type, :string
          key :example, 'Message'
        end
        property :RedeemPoints do
          key :type, :integer
          key :example, 500
        end
        property :location_id do
          key :type, :integer
          key :example, 3
        end
      end
    end
  end
end

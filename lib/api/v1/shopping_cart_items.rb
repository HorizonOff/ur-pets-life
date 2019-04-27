module Api
  module V1
    class ShoppingCartItems < ActionController::Base
      include Swagger::Blocks

      swagger_path '/shopping_cart_items' do
        operation :get do
          key :description, 'List items'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Items]

          security do
            key :api_key, []
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end

      swagger_path '/shopping_cart_items' do
        operation :post do
          key :description, 'List items'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Items]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :body
            key :in, :body
            key :required, true

            schema do
              property :quantity do
                key :type, :integer
                key :example, 1
              end
               property :item_id do
                key :type, :integer
                key :example, 1
              end
              property :IsRecurring do
                key :type, :boolean
                key :example, false
              end
            end
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end
    end
  end
end

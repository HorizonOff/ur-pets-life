module Api
  module V1
    class OrderItems < ActionController::Base
      include Swagger::Blocks

      swagger_path '/order_item/{id}/cancelorder' do
        operation :get do
          key :description, 'Quick search item'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Items]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :id
            key :in, :path
            key :type, :integer
            key :example, 1
          end

          response 200 do
            # key :description, 'Success response'
            # schema do
            #   key :'$ref', :ItemSearchResponse
            # end
          end
        end
      end
    end
  end
end

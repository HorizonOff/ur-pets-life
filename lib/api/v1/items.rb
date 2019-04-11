module Api
  module V1
    class Items < ActionController::Base
      include Swagger::Blocks

      swagger_schema :ItemSearchResponse do
        property :items do
          items do
            property :id do
              key :type, :number
              key :example, 1
            end
            property :name do
              key :type, :string
              key :example, 'BirdFood'
            end
            property :picture do
              key :type, :string
              key :example, 'www.amazon.link'
            end
          end
        end
      end

      swagger_path '/quick_search_items' do
        operation :get do
          key :description, 'Quick search item'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Search]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :keyword
            key :in, :query
            key :type, :string
            key :example, 'BirdFood'
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :ItemSearchResponse
            end
          end
        end
      end
    end
  end
end

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
        property :brands do
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
        property :brands do
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

          parameter do
            key :name, :sale_only
            key :in, :query
            key :type, :boolean
            key :example, false
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :ItemSearchResponse
            end
          end
        end
      end

      swagger_path '/search_items_by_keywords' do
        operation :post do
          key :description, 'Quick search item'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Search]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :body
            key :in, :body
            schema do
              property :sale_only do
                key :type, :boolean
                key :example, false
              end
              property :lowerprice do
                key :type, :integer
                key :example, 0
              end
              property :upperprice do
                key :type, :integer
                key :example, 1000
              end
              property :minrating do
                key :type, :integer
                key :example, 0
              end
              property :maxrating do
                key :type, :integer
                key :example, 5
              end
              property :pageno do
                key :type, :integer
                key :example, 0
              end
              property :size do
                key :type, :integer
                key :example, 20
              end
            end
          end

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :ItemsResponse
            end
          end
        end
      end

      swagger_path '/search_items_filter' do
        operation :post do
          key :description, 'Quick search item'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Search]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :body
            key :in, :body
            schema do
              property :sale_only do
                key :type, :boolean
                key :example, false
              end
            end
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

module Api
  module V1
    class Favorites < ActionController::Base
      include Swagger::Blocks

      swagger_schema :FavoriteInput do
        property :favorite do
          property :favoritable_type do
            key :type, :string
            key :example, 'Clinic'
          end
           property :favoritable_id do
            key :type, :integer
            key :example, 1
          end
        end
      end

      # swagger_schema :FavoritesResponse do
      #   property :favorites do
      #     items do
      #       property :id do
      #         key :type, :integer
      #         key :example, 10
      #       end
      #        property :start_at do
      #         key :type, :integer
      #         key :example, 1516318200
      #       end
      #       property :picture_url do
      #         key :type, :string
      #       end
      #       property :adress do
      #         key :type, :string
      #       end
      #       property :distance do
      #         key :type, :number
      #         key :example, 34.57
      #       end
      #       property :working_hours do
      #         key :'$ref', :WorkingHours
      #       end
      #     end
      #   end
      #   property :total_count do
      #     key :type, :integer
      #     key :example, 35
      #   end
      # end

      swagger_path '/favorites' do
        operation :post do
          key :description, 'Add to favorite'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Favorites]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :favorite
            key :in, :body
            key :required, true
            key :description, "Favoritable_type: Clinic/DayCareCentre/GroomingCentre/Vet/Trainer\n" +
                              'favoritable_type, favoritable_id - required'

            schema do
              key :'$ref', :FavoriteInput
            end
          end

          response 200 do
            key :description, 'Success response'
          end
        end

        # operation :get do
        #   key :description, 'Get all favorites'
        #   key :consumes, %w[application/json]
        #   key :produces, %w[application/json]
        #   key :tags, %W[Favorites]

        #   security do
        #     key :api_key, []
        #   end

        #   parameter do
        #     key :name, :longitude
        #     key :in, :query
        #     key :type, :number
        #     key :example, 22.287883
        #   end

        #   parameter do
        #     key :name, :latitude
        #     key :in, :query
        #     key :type, :number
        #     key :example, 48.6208
        #   end

        #   parameter do
        #     key :name, :time_zone
        #     key :in, :query
        #     key :type, :integer
        #     key :example, 3
        #   end

        #   parameter do
        #     key :name, :page
        #     key :in, :query
        #     key :type, :integer
        #     key :example, 1
        #   end

        #   parameter do
        #     key :name, :past
        #     key :in, :query
        #     key :type, :boolean
        #     key :example, false
        #   end

        #   response 200 do
        #     key :description, 'Success response'
        #     schema do
        #       key :'$ref', :AppointmentsResponse
        #     end
        #   end
        # end
      end


      swagger_path '/favorites/{id}' do
        operation :delete do
          key :description, 'Remove from favorites'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Favorites]

          security do
            key :api_key, []
          end

          parameter do
            key :name, :id
            key :in, :path
            key :required, true
          end

          response 200 do
            key :description, 'Success response'
          end
        end
      end



    end
  end
end

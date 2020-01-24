module Api
  module V1
    class LocationsController < Api::BaseController
      before_action :find_user_location, only: %i[update destroy]

      def create
        @location = @user.location.find_or_initialize_by(location_params)

        serialized_location = LocationSerializer.new(@location)

        if @location.save
          render json: { message: 'Location create successfully', location: serialized_location }, status: 200
        else
          render_422(parse_errors_messages(@location))
        end
      end

      def update
        if @location.update(location_params)
          render json: { message: 'Location update successfully' }, status: 200
        else
          render_422(parse_errors_messages(@location))
        end
      end

      def destroy
        if @location.update(place_id: nil)
          render json: { message: 'Deleted successfully' }, status: 200
        else
          render_422(parse_errors_messages(@location))
        end
      end

      private

      def find_user_location
        @location = current_user.location.find_by_id(params['id'])
      end

      def location_params
        params.permit(:latitude, :longitude, :city, :area, :street, :building_type, :building_name, :unit_number, :villa_number, :comment, :name)
      end
    end
  end
end


module Api
  module V1
    class LocationsController < Api::BaseController
      def create
        @location = @user.location.find_or_initialize_by(location_params)

        if @location.save
          render json: { message: 'Location create successfully' }, status: 200
        else
          render_422(parse_errors_messages(@location))
        end
      end

      def update
        @location = @user.location.find_by_id(params['id'])

        if @location.update(location_params)
          render json: { message: 'Location update successfully' }, status: 200
        else
          render_422(parse_errors_messages(@location))
        end
      end

      def destroy
        if @location.destroy
          render json: { message: 'Deleted successfully' }, status: 200
        else
          render_422(parse_errors_messages(@location))
        end
      end

      private

      def location_params
        params.permit(:latitude, :longitude, :city, :area, :street, :building_type, :building_name, :unit_number, :villa_number, :comment, :name)
      end
    end
  end
end


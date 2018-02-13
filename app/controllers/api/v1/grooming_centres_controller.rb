module Api
  module V1
    class GroomingCentresController < Api::BaseController
      skip_before_action :authenticate_user, except: :schedule
      before_action :set_grooming_centre, except: :index
      before_action :parse_date, only: :schedule

      def index
        grooming_centres = grooming_centres_query.find_objects
        serialized_centres = ActiveModel::Serializer::CollectionSerializer.new(
          grooming_centres, serializer: GroomingCentreIndexSerializer, scope: serializable_params
        )

        render json: { grooming_centres: serialized_centres, total_count: grooming_centres.total_count }
      end

      def show
        favorite = @grooming_centre.favorites.find_by(user: @user)

        render json: @grooming_centre, scope: serializable_params.merge(favorite: favorite),
               include: 'service_types,service_types.service_details'
      end

      def schedule
        time_slots = schedule_parser_service.retrieve_time_slots

        render json: { time_slots: time_slots }
      end

      private

      def set_grooming_centre
        @grooming_centre = GroomingCentre.find_by_id(params[:id])
        return render_404 unless @grooming_centre
      end

      def grooming_centres_query
        @grooming_centres_query ||= ::Api::V1::LocationBasedQuery.new('GroomingCentre', params)
      end

      def schedule_parser_service
        @schedule_parser_service ||= ::Api::V1::ScheduleParserService.new(@grooming_centre.schedule, @date)
      end

      def parse_date
        @date = Time.zone.at(params[:date].to_i)
        return render_422(date: 'Date is required') if params[:date].blank? || @date.blank?
      end
    end
  end
end

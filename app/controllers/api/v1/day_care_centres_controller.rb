module Api
  module V1
    class DayCareCentresController < Api::BaseController
      skip_before_action :authenticate_user, except: :schedule
      before_action :set_day_care_centre, except: :index
      before_action :parse_date, only: :schedule

      def index
        day_care_centres = day_care_centres_query.find_objects
        serialized_centres = ActiveModel::Serializer::CollectionSerializer.new(
          day_care_centres, serializer: DayCareCentreIndexSerializer, scope: serializable_params
        )

        render json: { day_care_centres: serialized_centres, total_count: day_care_centres.total_count }
      end

      def show
        favorite = @day_care_centre.favorites.find_by(user: @user)

        render json: @day_care_centre, scope: serializable_params.merge(favorite: favorite),
               include: 'service_types,service_types.service_details'
      end

      def schedule
        time_slots = schedule_parser_service.retrieve_time_slots
        render json: { time_slots: time_slots }
      end

      private

      def set_day_care_centre
        @day_care_centre = DayCareCentre.find_by_id(params[:id])
        return render_404 unless @day_care_centre
      end

      def day_care_centres_query
        @day_care_centres_query ||= ::Api::V1::LocationBasedQuery.new('DayCareCentre', params)
      end

      def schedule_parser_service
        @schedule_parser_service ||= ::Api::V1::ScheduleParserService.new(@day_care_centre.schedule, @date)
      end

      def parse_date
        @date = Time.zone.at(params[:date].to_i)
        return render_422(date: 'Date is required') if params[:date].blank? || @date.blank?
      end
    end
  end
end

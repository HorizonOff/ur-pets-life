module Api
  module V1
    class BoardingsController < Api::BaseController
      skip_before_action :authenticate_user, except: :schedule
      before_action :set_boarding, except: :index
      before_action :parse_date, only: :schedule

      def index
        boardings = boardings_query.find_objects
        serialized_centres = ActiveModel::Serializer::CollectionSerializer.new(
          boardings, serializer: BoardingIndexSerializer, scope: serializable_params
        )

        render json: { boardings: serialized_centres, total_count: boardings.total_count }
      end

      def show
        favorite = @boarding.favorites.find_by(user: @user)

        render json: @boarding, scope: serializable_params.merge(favorite: favorite),
               include: 'service_types,service_types.service_details'
      end

      def schedule
        time_slots = schedule_parser_service.retrieve_time_slots
        render json: { time_slots: time_slots }
      end

      private

      def set_boarding
        @boarding = Boarding.find_by_id(params[:id])
        return render_404 unless @boarding
      end

      def boardings_query
        @boardings_query ||= ::Api::V1::LocationBasedQuery.new('Boarding', params)
      end

      def schedule_parser_service
        @schedule_parser_service ||= ::Api::V1::ScheduleParserService.new(@boarding.schedule, @date)
      end

      def parse_date
        @date = Time.zone.at(params[:date].to_i)
        return render_422(date: 'Date is required') if params[:date].blank? || @date.blank?
      end
    end
  end
end

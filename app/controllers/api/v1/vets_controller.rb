module Api
  module V1
    class VetsController < Api::BaseController
      skip_before_action :authenticate_user, only: :show
      before_action :set_vet
      before_action :parse_date, only: :schedule

      def show
        render json: @vet
      end

      def schedule
        time_slots = schedule_parser_service.retrieve_time_slots
        render json: { time_slots: time_slots }
      end

      private

      def set_vet
        @vet = Vet.find_by_id(params[:id])
        return render_404 unless @vet
      end

      def parse_date
        @date = Time.zone.at(params[:date].to_i)
        return render_422(date: 'Date is required') if params[:date].blank? || @date.blank?
      end

      def schedule_parser_service
        @schedule_parser_service ||= ::Api::V1::VetScheduleParserService.new(@vet, @date)
      end
    end
  end
end

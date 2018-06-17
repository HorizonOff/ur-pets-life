module Api
  module V1
    class CommentedAppointmentsController < Api::BaseController
      before_action :parse_date

      def index
        appointments = current_user.appointments.joins(:last_comment).where('comments.created_at < ?', @created_at)
                                   .includes(:last_comment).limit(20)

        serialized_appointments = ActiveModel::Serializer::CollectionSerializer.new(
          appointments, serializer: CommentedAppointmentSerializer
        )

        render json: { appointments: serialized_appointments, total_count: current_user.commented_appointments_count }
      end

      private

      def parse_date
        @created_at = Time.zone.at(params[:created_at].to_i)
      end
    end
  end
end

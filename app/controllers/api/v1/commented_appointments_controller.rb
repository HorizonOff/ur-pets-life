module Api
  module V1
    class CommentedAppointmentsController < Api::BaseController
      before_action :parse_date

      def index
        appointments = current_user.commented_appointments.joins(:comments)
                                   .having('max (comments.created_at) < ?', @created_at)
                                   .order('max (comments.created_at) DESC').group('appointments.id')
                                   .includes(:last_comment, :bookable).limit(20)

        orders = current_user.commented_orders.joins(:comments)
                                   .having('max (comments.created_at) < ?', @created_at)
                                   .order('max (comments.created_at) DESC').group('orders.id')
                                   .includes(:last_comment).limit(20)

        serialized_appointments = ActiveModel::Serializer::CollectionSerializer.new(
          appointments, serializer: CommentedAppointmentSerializer
        )

        serialized_orders = ActiveModel::Serializer::CollectionSerializer.new(
          orders, serializer: CommentedOrderSerializer
        )

        render json: { appointments: serialized_appointments, orders: serialized_orders, total_count: (current_user.commented_orders_count + current_user.commented_appointments_count) }
      end

      private

      def parse_date
        @created_at = Time.zone.at(params[:created_at].to_i)
      end
    end
  end
end

module Api
  module V1
    class NotificationsController < Api::BaseController
      before_action :set_time, onle: :index

      def index
        notifications = @user.notifications.where('created_at < ?', @created_at).order(created_at: :desc)
                             .includes(:pet, :appointment, appointment: :bookable).limit(20)
        serialized_notifications = ActiveModel::Serializer::CollectionSerializer.new(notifications)

        notifications.view

        render json: { notifications: serialized_notifications, total_count: @user.notifications_count,
                       unread_notifications_count: unread_notifications_count }
      end

      def unread
        render json: { unread_notifications_count: unread_notifications_count }
      end

      private

      def set_time
        @created_at = Time.zone.at(params[:created_at].to_i)
      end

      def unread_notifications_count
        @unread_notifications_count ||= @user.unread_notifications.count
      end
    end
  end
end

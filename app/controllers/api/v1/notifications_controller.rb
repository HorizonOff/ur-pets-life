module Api
  module V1
    class NotificationsController < Api::BaseController
      def index
        @created_at = Time.zone.at(params[:created_at].to_i)
        notifications = @user.notifications.where('created_at < ?', @created_at).order(created_at: :desc)
                             .includes(:pet, :appointment, appointment: :bookable).limit(20)
        serialized_notifications = ActiveModel::Serializer::CollectionSerializer.new(notifications)

        render json: { notifications: serialized_notifications, total_count: @user.notifications_count }
      end
    end
  end
end

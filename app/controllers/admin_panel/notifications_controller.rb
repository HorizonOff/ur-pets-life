module AdminPanel
  class NotificationsController < AdminPanelController
    before_action :authorize_super_admin

    def index
      respond_to do |format|
        format.html {}
        format.json { filter_notifications }
      end
    end

    def new; end

    def create
      notification_creation_service.create_notifications
      if notification_creation_service.error.blank?
        redirect_to admin_panel_notifications_path
      else
        render :new
      end
    end

    def show
      @notification = Notification.find_by(id: params[:id])
      @notification = ::AdminPanel::NotificationDecorator.decorate(@notification)
    end

    private

    def filter_notifications
      filtered_notifications = filter_and_pagination_query.filter
      notifications = ::AdminPanel::NotificationDecorator.decorate_collection(filtered_notifications)
      serialized_notifications = ActiveModel::Serializer::CollectionSerializer.new(
        notifications, serializer: ::AdminPanel::NotificationFilterSerializer, adapter: :attributes
      )

      render json: { draw: params[:draw], recordsTotal: Notification.count,
                     recordsFiltered: filtered_notifications.total_count, data: serialized_notifications }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('Notification', params)
    end

    def notification_creation_service
      @notification_creation_service ||= ::AdminPanel::NotificationCreationService.new(params, current_admin)
    end
  end
end

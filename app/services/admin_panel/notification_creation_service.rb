module AdminPanel
  class NotificationCreationService
    attr_reader :error

    def initialize(params, admin)
      @params = params
      @admin = admin
    end

    def create_notifications
      if params[:all_users].present?
        create_notification_for_all_users
      else
        params[:user_ids].each { |user_id| create_notification_for_user(user_id) }
      end
    rescue StandardError => e
      add_error(e.message)
      return
    end

    def create_notification_for_user(user_id)
      @notification = admin.notifications.create!(user_id: user_id, message: params[:message],
                                                  skip_push_sending: params[:skip_push_sending].present?)
    end

    private

    attr_reader :params, :admin

    def create_notification_for_all_users
      User.all.each { |u| create_notification_for_user(u.id) }
    end

    def add_error(msg)
      @error = { message: msg }
    end
  end
end

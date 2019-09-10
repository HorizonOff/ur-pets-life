module AdminPanel
  class NotificationDecorator < ApplicationDecorator
    decorates :notification
    delegate_all


    def name
      model.user&.name
    end

    def skip_push_sending
      text = model.skip_push_sending? ? 'No' : 'Yes'
      span_class = model.skip_push_sending? ? 'label-danger' : 'label-success'
      content_tag(:span, text, class: "label #{span_class}")
    end

    def created_at
      model.created_at.strftime('%-d %b %Y %I:%M %p')
    end

    def actions
      link_to 'Show', url_helpers.admin_panel_notification_path(model), class: 'btn btn-primary btn-xs'
    end
  end
end

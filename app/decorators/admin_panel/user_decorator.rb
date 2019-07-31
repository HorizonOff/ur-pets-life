module AdminPanel
  class UserDecorator < ApplicationDecorator
    decorates :user
    delegate_all

    def status
      text = model.is_active? ? 'Active' : 'Locked'
      span_class = model.is_active? ? 'label-success' : 'label-danger'
      content_tag(:span, text, class: "label #{span_class}")
    end

    def last_action_at
      return content_tag(:i, '', class: "fa fa-power-off text-danger") + ' Offline' if model.last_action_at.blank?

      if model.last_action_at < (Time.current - 15.minutes)
        content_tag(:i, '', class: "fa fa-power-off text-danger") +
          " Offline<br>Last actions at #{model.last_action_at.strftime('%-d %b %Y %I:%M %p')}".html_safe
      else
        content_tag(:i, '', class: "fa fa-power-off text-success") + ' Online'
      end
    end

    def created_at
      model.created_at.strftime('%-d %b %Y %I:%M %p')
    end

    def actions
      (link_to 'Show', url_helpers.admin_panel_user_path(model), class: 'btn btn-primary btn-xs') +
        (link_to 'Edit', url_helpers.edit_admin_panel_user_path(model), class: 'btn btn-warning btn-xs') +
        (link_to 'Delete', url_helpers.admin_panel_user_path(model),
                 data: { confirm: 'Are you sure?' }, method: :delete, remote: true,
                 class: 'btn btn-danger btn-xs check_response')
    end
  end
end

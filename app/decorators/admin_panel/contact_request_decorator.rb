module AdminPanel
  class ContactRequestDecorator < ApplicationDecorator
    decorates :contact_request
    delegate_all

    def status
      text = model.is_answered? ? 'Answered' : 'New'
      span_class = model.is_answered? ? 'label-success' : 'label-warning'
      content_tag(:span, text, class: "label #{span_class}")
    end

    def user_name
      model.user.try(:name)
    end

    def user_mobile_number
      model.user.try(:mobile_number)
    end

    def created_at
      model.created_at.strftime('%-d %b %Y %I:%M %p')
    end

    def actions
      link_to 'Show', url_helpers.admin_panel_contact_request_path(model), class: 'btn btn-primary btn-xs'
    end
  end
end

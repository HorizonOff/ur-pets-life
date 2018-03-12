module AdminPanel
  class BoardingDecorator < ApplicationDecorator
    decorates :boarding
    delegate_all

    def picture
      content_tag(:image, '', src: model.picture.thumb.url, class: 'avatar') if model.picture.present?
    end

    def status
      text = model.is_active? ? 'Active' : 'Inactive'
      span_class = model.is_active? ? 'label-success' : 'label-danger'
      content_tag(:span, text, class: "label #{span_class}")
    end

    def actions
      (link_to 'Show', url_helpers.admin_panel_boarding_path(model), class: 'btn btn-primary btn-xs') +
        (link_to 'Edit', url_helpers.edit_admin_panel_boarding_path(model), class: 'btn btn-warning btn-xs') +
        (link_to 'Delete', url_helpers.admin_panel_boarding_path(model),
                 data: { confirm: 'Are you sure?' }, method: :delete, remote: true,
                 class: 'btn btn-danger btn-xs check_response')
    end
  end
end

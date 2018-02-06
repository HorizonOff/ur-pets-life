module AdminPanel
  class VetDecorator < ApplicationDecorator
    decorates :clinic
    delegate_all

    def avatar
      content_tag(:image, '', src: model.avatar.thumb.url, class: 'avatar') if model.avatar.present?
    end

    def status
      text = model.is_active? ? 'Active' : 'Inactive'
      span_class = model.is_active? ? 'label-success' : 'label-danger'
      content_tag(:span, text, class: "label #{span_class}")
    end

    def actions
      (link_to 'Show', url_helpers.admin_panel_clinic_path(model), class: 'btn btn-primary btn-xs') +
        (link_to 'View calendar', url_helpers.admin_panel_vet_calendars_path(model), class: 'btn btn-info btn-xs') +
        (link_to 'Edit', url_helpers.edit_admin_panel_clinic_path(model), class: 'btn btn-warning btn-xs') +
        (link_to 'Delete', url_helpers.admin_panel_clinic_path(model),
                 method: :delete, remote: true, class: 'btn btn-danger btn-xs check_response')
    end
  end
end

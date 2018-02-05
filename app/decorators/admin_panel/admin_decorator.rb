module AdminPanel
  class AdminDecorator < ApplicationDecorator
    decorates :clinic
    delegate_all

    def avatar
      content_tag(:image, '', src: model.avatar.thumb.url, class: 'avatar') if model.avatar.present?
    end

    def super_admin_status
      text = model.is_super_admin? ? 'Yes' : 'No'
      span_class = model.is_super_admin? ? 'label-success' : 'label-danger'
      content_tag(:span, text, class: "label #{span_class}")
    end

    def status
      text = model.is_active? ? 'Active' : 'Locked'
      span_class = model.is_active? ? 'label-success' : 'label-danger'
      content_tag(:span, text, class: "label #{span_class}")
    end

    def actions
      lock_unlock_text = model.is_active? ? 'Lock' : 'Activate'
      (link_to lock_unlock_text, url_helpers.change_status_admin_panel_admin_path(model),
               method: :put, remote: true, class: 'btn btn-info btn-xs check_response') +
        (link_to 'Delete', url_helpers.admin_panel_admin_path(model),
                 method: :delete, remote: true, class: 'btn btn-danger btn-xs check_response')
    end
  end
end

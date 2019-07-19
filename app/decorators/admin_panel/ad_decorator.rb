module AdminPanel
  class AdDecorator < ApplicationDecorator
    decorates :ad
    delegate_all

    def image
      content_tag(:image, '', src: model.image.thumb.url, class: 'avatar')
    end

    def is_active
      text = model.is_active? ? 'Active' : 'Inactive'
      span_class = model.is_active? ? 'label-success' : 'label-danger'
      content_tag(:span, text, class: "label #{span_class}")
    end

    def actions
      lock_unlock_text = model.is_active? ? 'Deactivate' : 'Activate'
      link_to lock_unlock_text, url_helpers.change_status_admin_panel_ad_path(model),
              method: :put, remote: true, class: 'btn btn-info btn-xs check_response'
    end
  end
end

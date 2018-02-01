class DayCareCentreDecorator < ApplicationDecorator
  decorates :day_care_centre
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
    (link_to 'Show', url_helpers.admin_panel_day_care_centre_path(model), class: 'btn btn-primary btn-xs') +
      (link_to 'Edit', url_helpers.edit_admin_panel_day_care_centre_path(model), class: 'btn btn-warning btn-xs') +
      (link_to 'Delete', url_helpers.admin_panel_day_care_centre_path(model),
               method: :delete, class: 'btn btn-danger btn-xs')
  end
end

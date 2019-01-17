module AdminPanel
  class ItemCategoryDecorator < ApplicationDecorator
  delegate_all

  def IsHaveBrand
    text = model.IsHaveBrand? ? 'Yes' : 'No'
    span_class = model.IsHaveBrand? ? 'label-success' : 'label-danger'
    content_tag(:span, text, class: "label #{span_class}")
  end

  def picture
    content_tag(:image, '', src: model.picture.url, class: 'avatar') if model.picture?
  end

  def actions
    # (link_to 'Show', url_helpers.admin_panel_item_category_path(model), class: 'btn btn-primary btn-xs') +
      (link_to 'Edit', url_helpers.edit_admin_panel_item_category_path(model), class: 'btn btn-warning btn-xs')
      #(link_to 'Delete', url_helpers.admin_panel_item_category_path(model),
      #         data: { confirm: 'Are you sure?' }, method: :delete, remote: true,
      #         class: 'btn btn-danger btn-xs check_response')
  end

end
end

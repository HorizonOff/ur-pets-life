module AdminPanel
  class ItemBrandDecorator < ApplicationDecorator
  delegate_all

  def picture
    content_tag(:image, '', src: model.picture.url, class: 'avatar') if model.picture?
  end

  def actions
    (link_to 'Show', url_helpers.admin_panel_item_brand_path(model), class: 'btn btn-primary btn-xs') +
      (link_to 'Edit', url_helpers.edit_admin_panel_item_brand_path(model), class: 'btn btn-warning btn-xs') +
      (link_to 'Delete', url_helpers.admin_panel_item_brand_path(model),
               data: { confirm: 'Are you sure?' }, method: :delete, remote: true,
               class: 'btn btn-danger btn-xs check_response')
  end
end
end

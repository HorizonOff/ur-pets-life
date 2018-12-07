module AdminPanel
  class OrderDecorator < ApplicationDecorator
  delegate_all

  def name
    model.item.name
  end

  def picture
    content_tag(:image, '', src: model.item.picture.url, class: 'avatar') if model.item.picture?
  end

  def created_at
    model.created_at.to_date
  end

  def status
    text = model.status
    if model.status == "pending"
      span_class = 'label-warning'
      text = "Pending"
    elsif model.status == "on_the_way"
      span_class = 'label-info'
      text = "On The Way"
    elsif model.status == "delivered"
      span_class = 'label-success'
      text = "Delivered"
    elsif model.status == "cancelled"
      span_class = 'label-danger'
      text = "Cancelled"
    end
    content_tag(:span, text, class: "label #{span_class}")
  end

  def IsRecurring
    text = model.IsRecurring? ? 'Yes' : 'No'
    span_class = model.IsRecurring? ? 'label-success' : 'label-default'
    content_tag(:span, text, class: "label #{span_class}")
  end

  def actions
    (link_to 'View Details', url_helpers.admin_panel_order_path(model), class: 'btn btn-primary btn-xs')
    #(link_to 'Update Status', url_helpers.edit_admin_panel_order_path(model), class: 'btn btn-warning btn-xs')
      #(link_to 'Delete', url_helpers.admin_panel_item_path(model),
            #   data: { confirm: 'Are you sure?' }, method: :delete, remote: true,
            #   class: 'btn btn-danger btn-xs check_response')
  end


end
end

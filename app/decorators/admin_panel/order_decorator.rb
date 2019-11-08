module AdminPanel
  class OrderDecorator < ApplicationDecorator
  delegate_all

  def user_id
    model.user.name
  end

  def location_id
    shippinglocation = model.location
    shippingaddress = (shippinglocation.villa_number.blank? ? '' : (shippinglocation.villa_number + ' '))  + (shippinglocation.unit_number.blank? ? '' : (shippinglocation.unit_number + ' ')) + (shippinglocation.building_name.blank? ? '' : (shippinglocation.building_name + ' ')) + (shippinglocation.street.blank? ? '' : (shippinglocation.street + ' ')) + (shippinglocation.area.blank? ? '' : (shippinglocation.area + ' ')) + (shippinglocation.city.blank? ? '' : shippinglocation.city)
    shippingaddress
  end

  def order_status_flag
    text = model.order_status_flag
    if model.order_status_flag == "pending"
      span_class = 'label-warning'
      text = "Pending"
    elsif model.order_status_flag == "on_the_way"
      span_class = 'label-info'
      text = "On The Way"
    elsif model.order_status_flag == "delivered"
      span_class = 'label-success'
      text = "Delivered"
    elsif model.order_status_flag == "delivered_by_card"
      span_class = 'label-success'
      text = "Delivered by card"
    elsif model.order_status_flag == "delivered_by_cash"
      span_class = 'label-success'
      text = "Delivered by cash"
    elsif model.order_status_flag == "delivered_online"
      span_class = 'label-success'
      text = "Delivered Online"
    elsif model.order_status_flag == "cancelled"
      span_class = 'label-danger'
      text = "Cancelled"
    elsif model.order_status_flag == "confirmed"
      span_class = 'label-primary'
      text = "Confirmed"
    end
    content = content_tag(:span, text, class: "label #{span_class}")
  end

  def IsCash
    text = model.IsCash? ? 'COD' : 'Telr'
    span_class = model.IsCash? ? 'label-default' : 'label-info'
    content_tag(:span, text, class: "label #{span_class}")
  end

  def is_pre_recurring
    text = model.is_pre_recurring? ? 'Yes' : 'No'
    span_class = model.is_pre_recurring? ? 'label-default' : 'label-info'
    content_tag(:span, text, class: "label #{span_class}")
  end

  def Payment_Status
    text = model.Payment_Status == 1 ? 'confirmed' : 'pending'
    span_class = model.Payment_Status == 1 ? 'label-success' : 'label-warning'
    content_tag(:span, text, class: "label #{span_class}")
  end

  def Order_Notes
    model.Order_Notes&.truncate(50)
  end

  def Total
    (model.Total - (model.RedeemPoints? ? model.RedeemPoints : 0)).round(2)
  end

  def is_viewed
    text = model.is_viewed? ? 'viewed' : 'new'
    span_class = model.is_viewed? ? 'label-primary' : 'label-danger'
    tags = content_tag(:span, text, class: "label #{span_class}")
    tags += comments_icon
    if model.unread_comments_count_by_admin > 0
      tags += unread_comments_icon
    end

    tags
  end

  def created_at
    model.created_at.strftime('%-d %b %Y %I:%M %p')
  end

  def delivery_at
    model.delivery_at&.strftime('%-d %b %Y %I:%M %p')
  end

  def actions
    links = (link_to 'View Details', url_helpers.admin_panel_order_path(model), class: 'btn btn-primary btn-xs')
    if model.order_status_flag.in?(%w(delivered delivered_by_card delivered_by_cash delivered_online)) || model.user.is_registered == false
      links += (link_to 'Download Invoice', url_helpers.invoice_admin_panel_order_path(model, :format => :pdf), class: 'btn btn-info btn-xs')
    end
    links
  end

  private

  def comments_icon
    content_tag(
      :span, model.comments_count, class: 'fa fa-comment pull-right', style: 'color:orange;'
    )
  end

  def unread_comments_icon
    content_tag(
      :span, model.unread_comments_count_by_admin, class: 'fa fa-comment pull-right', style: 'color:green;'
    )
  end

end
end

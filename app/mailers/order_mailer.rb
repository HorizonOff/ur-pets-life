class OrderMailer < ApplicationMailer

  def send_order_notification_email_to_admin(orderid)
    @order = Order.includes({user: [:location]}, {order_items: [:item]}).where(:id => orderid).first
    @shippinglocation = Location.where(:id => @order.location_id).first
    @userAddress = (@shippinglocation.villa_number.blank? ? '' : (@shippinglocation.villa_number + ' '))  + (@shippinglocation.unit_number.blank? ? '' : (@shippinglocation.unit_number + ' ')) + (@shippinglocation.building_name.blank? ? '' : (@shippinglocation.building_name + ' ')) + (@shippinglocation.street.blank? ? '' : (@shippinglocation.street + ' ')) + (@shippinglocation.area.blank? ? '' : (@shippinglocation.area + ' ')) + (@shippinglocation.city.blank? ? '' : @shippinglocation.city)
    mail(to: ENV['ADMIN'], subject: 'New Order Received')
  end

  def send_order_delivery_invoice(orderid, to_address)
    @order = Order.includes({user: [:location]}, {order_items: [:item]}).where(:id => orderid).first
    @shippinglocation = Location.where(:id => @order.location_id).first
    @userAddress = (@shippinglocation.villa_number.blank? ? '' : (@shippinglocation.villa_number + ' '))  + (@shippinglocation.unit_number.blank? ? '' : (@shippinglocation.unit_number + ' ')) + (@shippinglocation.building_name.blank? ? '' : (@shippinglocation.building_name + ' ')) + (@shippinglocation.street.blank? ? '' : (@shippinglocation.street + ' ')) + (@shippinglocation.area.blank? ? '' : (@shippinglocation.area + ' ')) + (@shippinglocation.city.blank? ? '' : @shippinglocation.city)
    mail(to: to_address, subject: 'Order Delivered')
  end
end

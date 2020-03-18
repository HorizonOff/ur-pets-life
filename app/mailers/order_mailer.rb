class OrderMailer < ApplicationMailer

  def send_order_notification_email_to_admin(order_id)
    @order = Order.find_by_id(order_id)
    @user_address = Location.find_by_id(@order.location_id).address
    mail(to: ENV['ADMIN'], subject: 'New Order Received')
  end

  def send_recurring_order_notification_email_to_admin(order_id)
    @order = Order.find_by_id(order_id)
    mail(to: ENV['ADMIN'], subject: 'New Recurring Order Received')
  end

  def send_order_delivery_invoice(order_id, to_address)
    @order = Order.find_by_id(order_id)
    @user_address = Location.find_by_id(@order.location_id).address
    mail(to: to_address, subject: 'Order Delivered')
  end

  def send_order_placement_notification_to_customer(to_address, order_id)
    @order = Order.find_by_id(order_id)
    @user_address = Location.find_by_id(@order.location_id).address
    mail(to: to_address, subject: 'Order Placed')
  end

  def send_recurring_order_placement_notification_to_customer(toAddress, order_id)
    @order = Order.find_by_id(order_id)
    mail(to: toAddress, subject: 'Recurring Order Placed')
  end

  def send_order_confimation_notification_to_customer(orderid)
    @order = Order.where(:id => orderid).first
    toAddress = User.where(:id => @order.user_id).first.email
    mail(to: toAddress, subject: 'Order Confirmation')
  end

  def send_order_cancellation_notification_to_customer(orderitemid)
    orderitem = OrderItem.where(:id => orderitemid).first
    @order = Order.where(:id => orderitem.order_id).first
    toAddress = User.where(:id => @order.user_id).first.email
    @itemName = Item.where(:id => orderitem.item_id).first.name
    mail(to: toAddress, subject: 'Order Item Cancelled')
  end

  def send_low_inventory_alert(itemid)
    @iteminfo = Item.where(:id => itemid).first
    mail(to: ENV['ADMIN'], subject: 'Inventory Alert')
  end

  def send_telr_error(order, type, error)
    @order = order
    @type = type
    @error = error
    mail(to: ENV['ADMIN'], subject: 'Telr Error')
  end

  def send_manual_capture_request(order, refund)
    @order = order
    @refund = refund
    mail(to: ENV['ADMIN'], subject: 'Manual Capture Request')
  end

  def send_empty_inventory_alert(order_id)
    @order_id = order_id
    mail(to: ENV['ADMIN'], subject: 'Inventory Alert')
  end

  def send_order_cancellation_notification_to_admin(orderitemid)
    @orderitem = OrderItem.where(:id => orderitemid).first
    @itemName = Item.where(:id => @orderitem.item_id).first.name
    mail(to: ENV['ADMIN'], subject: 'Order Item Cancelled')
  end

  def send_complete_cancel_order_email_to_customer(orderid, toAddress)
    @orderno = orderid
    mail(to: toAddress, subject: 'Order Cancelled')
    mail(to: ENV['ADMIN'], subject: 'Order Cancelled')
  end

  def send_recurring_failure_alert_to_admin(order_item_id)
    @order_item = OrderItem.find_by_id(order_item_id)
    @user_address = Location.find_by_id(@order_item.location_id).address
    mail(to: ENV['ADMIN'], subject: 'Recurring Order Failure Alert')
  end

  def send_recurring_success_alert_to_admin(order_id)
    @order = Order.find_by_id(order_id)
    @user_address = Location.find_by_id(@order.location_id).address
    mail(to: ENV['ADMIN'], subject: 'System Placed Recurring Order Alert')
  end

  def send_recurring_success_alert_to_customer(order_id)
    @order = Order.find_by_id(order_id)
    @user_address = Location.find_by_id(@order.location_id).address
    mail(to: @order.user.email, subject: 'Recurring Order Alert')
  end

  def inform_about_comment(order_id)
    @order = Order.find_by_id(order_id)
    mail(to: ENV['ADMIN'], subject: 'New reply')
  end
end

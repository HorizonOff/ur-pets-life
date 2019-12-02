module AdminPanel
  module OrderUpdateHelper
    def update_status(order)
      order.order_items.each do |order_item|
        if order_item.status != 'cancelled'

          if order.order_status_flag == 'cancelled'
            item = Item.find_by_id(order_item.item_id)
            item.increment!(:quantity, order_item.Quantity) if item.present?
          end
          order_item.update(status: order.order_status_flag)
        end
      end

      if params['TransactionId'].present?
        set_order_notifcation_email(order, order.order_items.where(IsRecurring: true).present?)
        order.user.notifications.create(order: order, message: 'Your Order has been placed successfully')
      end

      order.user.notifications.create(order: order,
                                      message: "Your Order status for Order #" + order.id.to_s + " has been " +
                                          (order.order_status_flag_cancelled? ? "Cancelled" : "updated to " + order.order_status_flag))

      if order.order_status_flag.in?(%w(delivered delivered_by_card delivered_by_cash delivered_online))
        set_order_delivery_invoice(order.id, order.user.email)
        order.update_attributes(Payment_Status: 1)

        if order.used_pay_code.present?
          order.used_pay_code.notifications
              .create(message: '30 points have been added to your account since your friend used your Pay It Forward code',
                      user_id: order.used_pay_code.user.id)

          if order.user.pay_code.blank?
            order.used_pay_code.notifications
                .create(message: 'A Pay It Forward code is now available for you so you can share it with 3 of your friends and receive 30 points from each of them. You can find the code under “ My Codes “ in the main Menu',
                        user_id: order.used_pay_code.code_user.id)
            order.used_pay_code.create_new_pay_code
          end
          order.used_pay_code.add_redeem_points

        elsif order.user.pay_code.blank?
          order.user.generate_pay_code
          order.user.notifications
              .create(message: 'A Pay It Forward code is now available for you so you can share it with 3 of your friends and receive 30 points from each of them. You can find the code under “ My Codes “ in the main Menu',
                      user_id: order.user_id)
        end

      elsif order.order_status_flag == 'confirmed'
        user_redeem_points_record = RedeemPoint.where(user_id: order.user_id).first
        TelrGetWorker.perform_async('capture', order.Total, order.id) if order.TransactionId.present?
        user_redeem_points_record.update_attributes(net_worth: user_redeem_points_record.net_worth + order.earned_points,
                                                    last_net_worth: user_redeem_points_record.net_worth,
                                                    last_reward_type: "Discount Per Transaction",
                                                    last_reward_worth: order.earned_points,
                                                    last_reward_update: Time.now,
                                                    totalearnedpoints: (user_redeem_points_record.totalearnedpoints + order.earned_points))
        send_order_confirmation_email_to_customer(order.id)

      elsif order.order_status_flag == 'cancelled'
        user_redeem_point_reimburse = RedeemPoint.where(user_id: order.user_id).first
        TelrGetWorker.perform_async('release', order.Total, order.id) if order.TransactionId.present?
        user_redeem_point_reimburse.update_attributes(net_worth: user_redeem_point_reimburse.net_worth + order.RedeemPoints,
                                                      totalavailedpoints: user_redeem_point_reimburse.totalavailedpoints - order.RedeemPoints)
        order.update_attributes(Subtotal: 0, Delivery_Charges: 0, Vat_Charges: 0, Total: 0, earned_points: 0, RedeemPoints: 0)
        send_complete_cancel_order_email_to_customer(order.id, order.user.email)
      end
    end

    private

    def set_order_delivery_invoice(orderid, userEmail)
      OrderMailer.send_order_delivery_invoice(orderid, ENV['ADMIN']).deliver
      OrderMailer.send_order_delivery_invoice(orderid, userEmail).deliver
    end

    def send_order_confirmation_email_to_customer(orderid)
      OrderMailer.send_order_confimation_notification_to_customer(orderid).deliver
    end

    def send_complete_cancel_order_email_to_customer(orderid, user_email)
      OrderMailer.send_complete_cancel_order_email_to_customer(orderid, user_email).deliver
    end

    def set_order_notifcation_email(order, is_any_recurring_item)
      OrderMailer.send_order_notification_email_to_admin(order.id).deliver_later
      OrderMailer.send_order_placement_notification_to_customer(order.user.email, order.id).deliver_later
      return unless is_any_recurring_item

      OrderMailer.send_recurring_order_notification_email_to_admin(order.id).deliver_later
      OrderMailer.send_recurring_order_placement_notification_to_customer(order.user.email, order.id).deliver_later
    end
  end
end

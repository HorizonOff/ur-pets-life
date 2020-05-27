module OrdersServices
  class OrderStatusUpdateService
    def initialize(order, status, transaction_id)
      @order = order
      @status = status
      @transaction_id = transaction_id
    end

    def update_order_status
      update_order_item_status
      cashless_payment_notifications if transaction_id.present? && order.order_status_flag_pending?
      updated_status_notification
      delivered_order if order.order_status_flag.in?(%w(delivered delivered_by_card delivered_by_cash delivered_online))
      confirmed_order if order.order_status_flag_confirmed?
      cancelled_order if order.order_status_flag_cancelled?
    end

    private

    attr_reader :order, :status, :transaction_id

    def update_order_item_status
      order.order_items.each do |order_item|
        if order_item.status != 'cancelled'

          if order.order_status_flag == 'cancelled'
            order_item.item.increment!(:quantity, order_item.Quantity)
          end
          order_item.update(status: order.order_status_flag)
        end
      end
    end

    def cashless_payment_notifications
      set_order_notification_email(order.order_items.where(IsRecurring: true).present?)
      order.user.notifications.create(order: order, message: 'Your Order has been placed successfully')
      order.update_columns(Payment_Status: params[:Payment_Status])
    end

    def updated_status_notification
      order.user.notifications.create(order: order,
                                      message: "Your Order status for Order #" + order.id.to_s + " has been " +
                                          (order.order_status_flag_cancelled? ? "cancelled" : "updated to " + order.order_status_flag))
    end

    def delivered_order
      set_order_delivery_invoice
      order.update_attributes(Payment_Status: 1)

      if order.used_pay_code.present?
        order.used_pay_code.notifications
            .create(message: '30 points have been added to your account since your friend used your Pay It Forward code',
                    user_id: order.used_pay_code.user.id)

        if order.user.pay_code.blank?
          order.used_pay_code.notifications
              .create(message: 'A Pay It Forward code is now available for you so you can share it with 3 of your
                                friends and receive 30 points from each of them. You can find the code under
                                “ My Codes “ in the main Menu',
                      user_id: order.used_pay_code.code_user.id)
          order.used_pay_code.create_new_pay_code
        end
        order.used_pay_code.add_redeem_points

      elsif order.user.pay_code.blank?
        order.user.generate_pay_code
        order.user.notifications
            .create(message: 'A Pay It Forward code is now available for you so you can share it with 3 of your friends
                              and receive 30 points from each of them. You can find the code under “ My Codes “ in the
                              main Menu',
                    user_id: order.user_id)
      end
    end

    def confirmed_order
      user_redeem_points_record = order.user&.redeem_point

      telr_worker('capture') if order.TransactionId.present?

      user_redeem_points_record.update_attributes(net_worth: user_redeem_points_record.net_worth + order.earned_points,
                                                  last_net_worth: user_redeem_points_record.net_worth,
                                                  last_reward_type: "Discount Per Transaction",
                                                  last_reward_worth: order.earned_points,
                                                  last_reward_update: Time.now,
                                                  totalearnedpoints: (user_redeem_points_record.totalearnedpoints + order.earned_points))
      send_order_confirmation_email
    end

    def cancelled_order
      user_redeem_point_reimburse = RedeemPoint.where(user_id: order.user_id)

      telr_worker('release') if order.TransactionId.present?

      user_redeem_point_reimburse.update_attributes(net_worth: user_redeem_point_reimburse.net_worth + order.RedeemPoints,
                                                    totalavailedpoints: user_redeem_point_reimburse.totalavailedpoints - order.RedeemPoints)
      order.update_attributes(Subtotal: 0, Delivery_Charges: 0, Vat_Charges: 0, Total: 0, earned_points: 0, RedeemPoints: 0)
      send_cancel_order_email
    end

    def set_order_delivery_invoice
      OrderMailer.send_order_delivery_invoice(order.id, ENV['ADMIN']).deliver
      OrderMailer.send_order_delivery_invoice(order.id, order.user.email).deliver
    end

    def send_order_confirmation_email
      OrderMailer.send_order_confimation_notification_to_customer(order.id).deliver
    end

    def send_cancel_order_email
      OrderMailer.send_complete_cancel_order_email_to_customer(order.id, order.user.email).deliver
    end

    def set_order_notification_email(any_recurring_item)
      OrderMailer.send_order_notification_email_to_admin(order.id).deliver_later
      OrderMailer.send_order_placement_notification_to_customer(order.user.email, order.id).deliver_later
      return unless any_recurring_item

      OrderMailer.send_recurring_order_notification_email_to_admin(order.id).deliver_later
      OrderMailer.send_recurring_order_placement_notification_to_customer(order.user.email, order.id).deliver_later
    end

    def telr_worker(method)
      order_price = order.Total - order.RedeemPoints
      TelrGetWorker.perform_async(method, order_price, order.id)
    end
  end
end




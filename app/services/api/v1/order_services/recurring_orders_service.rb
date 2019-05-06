module API
  module V1
    module OrderServices
    class RecurringOrdersService

      def initialize()
      end

      def perform
        @recrringDate = (DateTime.now.to_time + 1.days).to_date
        puts "Fetching Recurring Items for " + @recrringDate.beginning_of_day.to_s + " to " + @recrringDate.end_of_day.to_s
        @orderitems = get_recurring_orders
        puts "found(s) " + @orderitems.count.to_s + " item(s)"
        puts "Placing Recurring Orders"
        place_recurring_orders
        puts "Job terminating . .  . . "
      end

      def get_recurring_orders
        OrderItem.includes(:item, {order: [:user]}).where('"IsRecurring" = true AND status = \'delivered\' AND next_recurring_due_date BETWEEN (?) AND (?)', @recrringDate.beginning_of_day, @recrringDate.end_of_day )
      end

      def place_recurring_orders
        @orderitems.each do |orderitem|
          user = orderitem.order.user
          discount = ::Api::V1::DiscountDomainService.new(user.email.dup).dicount_on_email
          is_user_from_company = discount.present?
          puts "processing " + orderitem.id.to_s + " ..."
          trans_id = ""
          paymentStatus = 0
          @discounted_items_amount = 0
          trans_date = DateTime.now
          if discount.present? && orderitem.item.discount.zero?
            subTotal = orderitem.item.price * ((100 - discount).to_f / 100) * orderitem.Quantity
          else
            subTotal = orderitem.item.price * orderitem.Quantity
          end
          if orderitem.item.discount > 0
            @discounted_items_amount = (orderitem.item.price * orderitem.Quantity)
          end
          total_price_without_discount = orderitem.item.price * orderitem.Quantity
          company_discount = (subTotal - total_price_without_discount).round(2)
          deliveryCharges = subTotal < 100 ? 20 : 0
          vatCharges = (total_price_without_discount/100).to_f * 5
          total = subTotal + deliveryCharges + vatCharges

          if orderitem.order.IsCash == false
            #gateway_response = perform_order_transaction(total, orderitem.item.description, orderitem.order.id, orderitem.order.TransactionId)
            paymentStatus = 0
            #trans_id = gateway_response[0]
            #trans_date = gateway_response[1]
          end

          @recurringorder = Order.new(user_id: orderitem.order.user_id, RedeemPoints: 0, TransactionId: trans_id,
                                      TransactionDate: trans_date, Subtotal: total_price_without_discount,
                                      Delivery_Charges: deliveryCharges,
                                      shipmenttime: 'with in 7 days', Vat_Charges: vatCharges, Total: total,
                                      Order_Status: 1, Payment_Status: paymentStatus,
                                      Order_Notes: orderitem.order.Order_Notes, IsCash: true,
                                      location_id: orderitem.order.location_id, is_viewed: false,
                                      order_status_flag: 'pending', company_discount: company_discount,
                                      is_user_from_company: is_user_from_company)
          if @recurringorder.save
            puts "Order placed for " + orderitem.id.to_s
            @neworderitemcreate = OrderItem.new(:IsRecurring => false, :order_id => @recurringorder.id, :item_id => orderitem.item.id, :Quantity => orderitem.Quantity, :Unit_Price => orderitem.item.price, :Total_Price => subTotal, :IsReviewed => false, :status => :pending, :isdiscounted => (orderitem.item.discount > 0 ? true : false))
            @neworderitemcreate.save

            discount_per_transaction = 0
            amount_to_be_awarded = subTotal - @discounted_items_amount
            if amount_to_be_awarded > 0
              if amount_to_be_awarded <= 500
                discount_per_transaction =+ (3*amount_to_be_awarded)/100
              elsif amount_to_be_awarded > 500 and amount_to_be_awarded <= 1000
                discount_per_transaction =+ (5*amount_to_be_awarded)/100
              elsif amount_to_be_awarded > 1000 and amount_to_be_awarded <= 2000
                discount_per_transaction =+ (7.5*amount_to_be_awarded)/100
              elsif amount_to_be_awarded > 2000
                discount_per_transaction =+ (10*amount_to_be_awarded)/100
              end
            end
            @user_redeem_point_record = RedeemPoint.where(:user_id => @recurringorder.user_id).first
            @user_redeem_point_record.update(:net_worth => (@user_redeem_point_record.net_worth + discount_per_transaction), :last_net_worth => @user_redeem_point_record.net_worth, :last_reward_type => "Discount Per Transaction (Recurring Order)", :last_reward_worth => discount_per_transaction, :last_reward_update => Time.now, :totalearnedpoints => (@user_redeem_point_record.totalearnedpoints + discount_per_transaction))
            @recurringorder.update(:earned_points => discount_per_transaction)

            item = Item.where(:id => orderitem.item.id).first
            item.decrement!(:quantity, orderitem.Quantity)
            if item.quantity < 3
              send_inventory_alerts(item.id)
            end

            recurrion_interval = RecurssionInterval.where(:id => orderitem.recurssion_interval_id).first
            next_due_date = orderitem.next_recurring_due_date.to_date
            next_due_date = next_due_date.to_time + (recurrion_interval.days).days
            orderitem.update(:next_recurring_due_date => next_due_date.to_date)
            puts "sending success alert for " + orderitem.id.to_s
            send_order_sucess_alerts(orderitem, @recurringorder)

          else
            puts "sending failure alert for " + orderitem.id.to_s
            send_failure_alert_to_admin(orderitem.id)
          end

        end

      end

      def send_failure_alert_to_admin(orderitemid)
        OrderMailer.send_recurring_failure_alert_to_admin(orderitemid).deliver
      end

      def send_order_sucess_alerts(orderitem, recurringorder)
        OrderMailer.send_recurring_success_alert_to_admin(orderitem.id).deliver
        OrderMailer.send_recurring_success_alert_to_customer(orderitem.id).deliver
        @user = User.where(:id => recurringorder.user_id).first
        @user.notifications.create(order: recurringorder, message: 'Your Order for Recurring Item ' + orderitem.item.name + ' has been placed.')
      end

      def perform_order_transaction(amount, desc, orderid, trans_ref)
        API::V1::OrderServices::OnlinePaymentService.send_payment_request('sale', 'cont', trans_ref, desc, orderid, amount)
      end

      def send_inventory_alerts(itemid)
        OrderMailer.send_low_inventory_alert(itemid).deliver
      end

    end
  end
end
end

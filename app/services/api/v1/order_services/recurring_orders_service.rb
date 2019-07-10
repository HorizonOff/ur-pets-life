module API
  module V1
    module OrderServices
      class RecurringOrdersService
        def initialize(); end

        def perform
          @recrringDate = DateTime.current + 1.days
          # @orderitems = get_recurring_orders

          place_recurring_orders
        end

        # def get_recurring_orders
        #   OrderItem.includes(:item, {order: [:user]}).where('"IsRecurring" = true AND status = \'delivered\' AND next_recurring_due_date BETWEEN (?) AND (?)', @recrringDate.beginning_of_day, @recrringDate.end_of_day )
        # end

        def place_recurring_orders
          User.joins(:orders).includes(orders: :order_items).find_each do |user|
            order_items = user.order_items.where(IsRecurring: true)
                                          .where("status IN ['delivered', 'delivered_by_cash', 'delivered_by_card']")
                                          .where(next_recurring_due_date: @recrringDate.beginning_of_day..@recrringDate.end_of_day)
            next if order_items.blank?

            isoutofstock = false
            @itemsprice = 0
            @total_price_without_discount = 0
            @discounted_items_amount = 0
            discount = ::Api::V1::DiscountDomainService.new(user.email.dup).dicount_on_email
            is_user_from_company = discount.present?
            order_items.each do |cartitem|
              if discount.present? && cartitem.item.discount.zero?
                @itemsprice += cartitem.item.price * ((100 - discount).to_f / 100) * cartitem.Quantity
              else
                @itemsprice += (cartitem.item.price * cartitem.Quantity)
              end
              @total_price_without_discount += (cartitem.item.price * cartitem.Quantity)
              if cartitem.item.discount > 0
                @discounted_items_amount += (cartitem.item.price * cartitem.Quantity)
              end
              isoutofstock = true if cartitem.item.quantity < cartitem.Quantity
            end
            # return render json: { Message: 'Out of Stock', status: :out_of_stock } if isoutofstock == true

            subTotal = @itemsprice.to_f.round(2)
            deliveryCharges = (subTotal < 100 ? 20 : 0)
            company_discount = (@itemsprice - @total_price_without_discount).round(2)
            vatCharges = ((@total_price_without_discount/100).to_f * 5).round(2)
            total = subTotal + deliveryCharges + vatCharges

            user_redeem_points = 0
            permitted_redeem_points = 0
            paymentStatus = 0
            trans_date = DateTime.now

            @recurringorder = Order.new(user_id: user.id, RedeemPoints: permitted_redeem_points,
                                        TransactionId: '', is_pre_recurring: true,
                                        TransactionDate: trans_date, Subtotal: @total_price_without_discount,
                                        Delivery_Charges: deliveryCharges, shipmenttime: 'with in 7 days',
                                        Vat_Charges: vatCharges,
                                        Total: total, Order_Status: 1, Payment_Status: paymentStatus,
                                        Order_Notes: '',
                                        IsCash: true, location_id: order_items.last.order.location_id, is_viewed: false,
                                        order_status_flag: 'pending', company_discount: company_discount,
                                        is_user_from_company: is_user_from_company)
            if @recurringorder.save
              send_inventory_alerts(@recurringorder.id) if isoutofstock

              order_items.each do |cartitem|
                neworderitemcreate = OrderItem.new(IsRecurring: false, order_id: @recurringorder.id,
                                                   item_id: cartitem.item.id, Quantity: cartitem.Quantity,
                                                   Unit_Price: cartitem.item.price, Total_Price: subTotal,
                                                   IsReviewed: false, status: :pending,
                                                   isdiscounted: cartitem.item.discount.positive?)
                neworderitemcreate.save

                unless isoutofstock
                  item = Item.where(id: cartitem.item.id).first
                  item.decrement!(:quantity, cartitem.Quantity)
                  send_inventory_alerts(item.id) if item.quantity < 3
                end

                recurrion_interval = RecurssionInterval.where(id: cartitem.recurssion_interval_id).first
                next_due_date = cartitem.next_recurring_due_date.to_date
                next_due_date = next_due_date.to_time + recurrion_interval.days.days
                cartitem.update(next_recurring_due_date: next_due_date.to_date)
              end

              discount_per_transaction = 0
              amount_to_be_awarded = subTotal - @discounted_items_amount
              if amount_to_be_awarded.positive?
                if amount_to_be_awarded <= 500
                  discount_per_transaction = (3 * amount_to_be_awarded) / 100
                elsif amount_to_be_awarded > 500 && amount_to_be_awarded <= 1000
                  discount_per_transaction = (5 * amount_to_be_awarded) / 100
                elsif amount_to_be_awarded > 1000 && amount_to_be_awarded <= 2000
                  discount_per_transaction = (7.5 * amount_to_be_awarded) / 100
                elsif amount_to_be_awarded > 2000
                  discount_per_transaction = (10 * amount_to_be_awarded) / 100
                end
              end
              @user_redeem_point_record = RedeemPoint.where(user_id: @recurringorder.user_id).first
              @user_redeem_point_record.update(net_worth: (@user_redeem_point_record.net_worth +
                                                          discount_per_transaction),
                                               last_net_worth: @user_redeem_point_record.net_worth,
                                               last_reward_type: 'Discount Per Transaction (Recurring Order)',
                                               last_reward_worth: discount_per_transaction,
                                               last_reward_update: Time.now,
                                               totalearnedpoints: (@user_redeem_point_record.totalearnedpoints +
                                                                  discount_per_transaction))
              @recurringorder.update(earned_points: discount_per_transaction)

              send_order_sucess_alerts(@recurringorder)
            else
              send_failure_alert_to_admin(orderitem.id)
            end
          end
        end

        def send_failure_alert_to_admin(orderitemid)
          OrderMailer.send_recurring_failure_alert_to_admin(orderitemid).deliver
        end

        def send_order_sucess_alerts(recurringorder)
          OrderMailer.send_recurring_success_alert_to_admin(recurringorder.id).deliver
          OrderMailer.send_recurring_success_alert_to_customer(recurringorder.id).deliver
          @user = User.where(:id => recurringorder.user_id).first
          @user.notifications.create(order: recurringorder, message: 'Your recurring order is scheduled to be automatically placed and
delivered tomorrow. If you wish to cancel please go to My Account/My Order History/Recurring')
        end

        def send_inventory_alerts(itemid)
          OrderMailer.send_low_inventory_alert(itemid).deliver
        end

        def send_empty_inventory_alerts(order_id)
          OrderMailer.send_empty_inventory_alert(order_id).deliver
        end
      end
    end
  end
end

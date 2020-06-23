module Api
  module V1
    module OrderServices
      class OrderCreateService
        def initialize(user, location_id, user_cart_items, params)
          @user = user
          @location_id = location_id
          @user_cart_items = user_cart_items
          @out_of_stock = false
          @pay_code = params[:pay_code]
          @admin_discount = params[:order][:admin_discount].to_f
          @redeem_points = params[:order][:RedeemPoints]
          @delivery_date = params[:Delivery_Date]
          @order_notes = params[:Order_Notes]
          @is_cash = params[:IsCash]
          @quantity = 0
          @items_price = 0
          @total_price_without_discount = 0
          @discounted_items_amount = 0
          @permitted_redeem_points = 0
          @discount_per_transaction = 0
        end

        def order_create
          calculate_discount
          return out_of_stock if out_of_stock
          create_order
          order
        end

        private

        attr_reader :user, :location_id, :out_of_stock, :pay_code, :user_cart_items, :admin_discount, :redeem_points,
                    :delivery_date, :order_notes, :is_cash, :quantity, :items_price, :total_price_without_discount,
                    :discounted_items_amount, :permitted_redeem_points, :discount_per_transaction, :discount, :sub_total,
                    :order

        def calculate_discount
          @discount = ::Api::V1::DiscountDomainService.new(user.email.dup).dicount_on_email

          user_cart_items.each do |cart_item|
            return @out_of_stock = true if cart_item.item.quantity < cart_item.quantity

            if discount.positive? && cart_item.item.discount.zero? && !(user.member_type.in?(%w(silver gold)) &&
                cart_item.item.supplier.in?(%w(MARS NESTLE))) && user.email != 'development@urpetslife.com'
              @items_price += cart_item.item.price * ((100 - discount).to_f / 100) * cart_item.quantity
            else
              @items_price += (cart_item.item.price * cart_item.quantity)
            end

            @total_price_without_discount += (cart_item.item.price * cart_item.quantity)
            @discounted_items_amount += (cart_item.item.price * cart_item.quantity) if cart_item.item.discount > 0
          end
        end

        def create_order
          sub_total = @total_price_without_discount.to_f.round(2)
          if user.email != 'development@urpetslife.com'
            delivery_charges = (sub_total < 100 ? 20 : 0)
          else
            delivery_charges = 7
          end

          company_discount = (@total_price_without_discount - @items_price).round(2)
          code_discount = ::Api::V1::DiscountCodeService.new(pay_code, user, sub_total).discount_from_code
          vat_charges = ((@total_price_without_discount/100).to_f * 5).round(2)
          @user_redeem_point_record = OrdersServices::OrderMathService.new(sub_total, redeem_points, user).calculate_redeem_points unless is_calculating
          amount_to_be_awarded = sub_total - @permitted_redeem_points - @discounted_items_amount
          if amount_to_be_awarded > 0 && discount.zero? && user.email != 'development@urpetslife.com'
            @discount_per_transaction = OrdersServices::OrderMathService.new(amount_to_be_awarded, nil, nil).calculate_discount
          end
          total = sub_total + delivery_charges + vat_charges + code_discount - company_discount

          @order = Order.new(user_id: user.id, RedeemPoints: @permitted_redeem_points, Subtotal: @total_price_without_discount,
                             Delivery_Charges: delivery_charges, shipmenttime: 'with in 7 days', Vat_Charges: vat_charges,
                             Total: total, Order_Status: 1, Payment_Status: 1, Delivery_Date: delivery_date,
                             Order_Notes: order_notes, IsCash: is_cash, location_id: location_id,
                             company_discount: company_discount, is_user_from_company: discount.positive?,
                             admin_discount: @admin_discount, earned_points: @discount_per_transaction)

          if @order.save
            if @order.code_discount != 0
              pay_code_owner = User.find_by(pay_code: pay_code)
              UsedPayCode.create(user_id: pay_code_owner.id, order_id: @order.id, code_user_id: user.id)
            end

            if @permitted_redeem_points.positive?
              @user_redeem_point_record.update(net_worth: (user_redeem_points - @permitted_redeem_points),
                                               last_net_worth: user_redeem_points, last_reward_type: 'Order Deduction',
                                               last_reward_worth: @permitted_redeem_points, last_reward_update: Time.now,
                                               totalavailedpoints: (@user_redeem_point_record.totalavailedpoints
                                               + @permitted_redeem_points))
            end

            @user_cart_items.each do |cart_item|
              order_item = OrderItem.new(order_id: @order.id, item_id: cart_item.item.id, Quantity: cart_item.quantity,
                               Unit_Price: cart_item.item.price, Total_Price: (cart_item.item.price * cart_item.quantity),
                               isdiscounted: cart_item.item.discount.positive?,
                               next_recurring_due_date: DateTime.now)

              if order_item.new_record? && cart_item.recurssion_interval_id.present?
                next_due_date = Time.current + cart_item.recurssion_interval.days.days
                order_item.update_attributes(next_recurring_due_date: next_due_date,
                                                      recurssion_interval_id: cart_item.recurssion_interval_id)
              end

              if order_item.save
                cart_item.item.decrement!(:quantity, cart_item.quantity)
                send_inventory_alerts(cart_item.item.id) if cart_item.item.quantity < 3

                if @is_cash
                  set_order_notifcation_email(@order, cart_item.IsRecurring)
                  user.notifications.create(order: @order, message: 'Your Order has been placed successfully')
                end
              end
            end

            user.shopping_cart_items.destroy_all
          end
        end

        def send_inventory_alerts(item_id)
          OrderMailer.send_low_inventory_alert(item_id).deliver_now
        end

        def set_order_notifcation_email(order, is_recurring_item)
          OrderMailer.send_order_notification_email_to_admin(order.id).deliver_now
          OrderMailer.send_order_placement_notification_to_customer(user.email, order.id).deliver_now
          return unless is_recurring_item

          OrderMailer.send_recurring_order_notification_email_to_admin(order.id).deliver_now
          OrderMailer.send_recurring_order_placement_notification_to_customer(user.email, order.id).deliver_now
        end
      end
    end
  end
end
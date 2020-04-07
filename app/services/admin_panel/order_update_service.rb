module AdminPanel
  class OrderUpdateService

    def initialize(order, sub_total_price, undiscounted_order_items)
      @order = order
      @sub_total_price = sub_total_price
      @undiscounted_order_items = undiscounted_order_items
      @points_to_be_reverted = 0
      @discounted_products_price = 0
      @discounted_price = 0
      @discount_per_transaction = order.earned_points
    end

    def update
      calculate_discounts
      calculate_amount_remaining(sub_total_price, order.RedeemPoints)

      return cancel_order && send_cancel_order_email if update_to_cancelled
      update_order
    end

    private

    attr_reader :order, :sub_total_price, :points_to_be_reverted, :undiscounted_order_items,
                :discounted_products_price, :discounted_price, :update_to_cancelled, :discount_per_transaction

    def calculate_discounts
      @update_to_cancelled = true
      discount = ::Api::V1::DiscountDomainService.new(order.user.email.dup).dicount_on_email

      order.order_items.each do |order_items|
        if order_items.status != 'cancelled'
          @discounted_products_price += order_items.Total_Price if order_items.isdiscounted
          @discounted_price += (order_items.Total_Price * ((100 - discount).to_f / 100)) - order_items.Total_Price if discount.positive?

          @update_to_cancelled = false
        end
      end
      update_to_cancelled
    end

    def calculate_amount_remaining(sub_total_price, order_redeem_points)
      if sub_total_price >= order_redeem_points
        @points_to_be_reverted = 0
      elsif sub_total_price < order_redeem_points
        @points_to_be_reverted = order_redeem_points - sub_total_price
      end

      rollback_user_redeem_points if points_to_be_reverted > 0
    end

    def send_cancel_order_email
      OrderMailer.send_complete_cancel_order_email_to_customer(order.id, order.user.email).deliver
    end

    def cancel_order
      order.update(Subtotal: 0, Delivery_Charges: 0, Vat_Charges: 0, Total: 0,
                   order_status_flag: 'cancelled', earned_points: 0, RedeemPoints: 0)
    end

    def update_order
      delivery_charges = sub_total_price > 100 ? 0 : 20
      vat_charges = ((sub_total_price/100) * 5).round(2)
      total = sub_total_price + delivery_charges + vat_charges + discounted_price + order.code_discount - order.admin_discount - order.RedeemPoints
      total = 0 if total.negative?

      if undiscounted_order_items.positive?
        sub_total = order.Subtotal - undiscounted_order_items
        order_price_for_award = sub_total - (order.RedeemPoints - points_to_be_reverted) - discounted_products_price
        order_discount(order_price_for_award)
      else
        @discount_per_transaction = order.earned_points
      end

      order.update(Subtotal: sub_total_price, Delivery_Charges: delivery_charges, Vat_Charges: vat_charges,
                   Total: total, RedeemPoints: order.RedeemPoints - points_to_be_reverted,
                   earned_points: @discount_per_transaction, company_discount: discounted_price)
    end

    def order_discount(order_price)
      if order_price <= 500
        @discount_per_transaction =+ (3*order_price)/100
      elsif order_price > 500 and order_price <= 1000
        @discount_per_transaction =+ (5*order_price)/100
      elsif order_price > 1000 and order_price <= 2000
        @discount_per_transaction =+ (7.5*order_price)/100
      elsif order_price > 2000
        @discount_per_transaction =+ (10*order_price)/100
      end
      @discount_per_transaction.to_f.ceil
    end

    def rollback_user_redeem_points
      user_redeem_point = order.user.redeem_point
      net_worth = user_redeem_point.net_worth

      user_redeem_point.update(net_worth: net_worth + points_to_be_reverted, last_net_worth: net_worth,
                               last_reward_type: "Discount Per Transaction (Order Cancel Roll Back)",
                               last_reward_worth: points_to_be_reverted, last_reward_update: Time.now,
                               totalavailedpoints: user_redeem_point.totalavailedpoints - points_to_be_reverted)
    end
  end
end


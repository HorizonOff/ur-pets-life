module AdminPanel
  class OrderCreateService

    def initialize(user, location_id, params)
      @user = user
      @location_id = location_id
      @order_items_attributes = params[:order][:order_items_attributes]
      @admin_discount = params[:order][:admin_discount].to_f
      @redeem_points = params[:order][:RedeemPoints]
      @delivery_date = params[:Delivery_Date]
      @order_notes = params[:Order_Notes]
      @quantity = 0
      @items_price = 0
      @total_price_without_discount = 0
      @discounted_items_amount = 0
      @permitted_redeem_points = 0
      @discount_per_transaction = 0
    end

    def order_create
      calculate_discount
      return 'Items blank!' if @item.blank?
      create_order
      order
    end

    private

    attr_reader :user, :location_id, :order_items_attributes, :admin_discount, :redeem_points, :delivery_date,
                :order_notes, :quantity, :items_price, :total_price_without_discount, :discounted_items_amount,
                :permitted_redeem_points, :discount_per_transaction, :discount, :sub_total, :order

    def calculate_discount
      @discount = user.is_registered? ? ::Api::V1::DiscountDomainService.new(user.email.dup).dicount_on_email : 0

      order_items_attributes.each do |hash_key, hash_value|
        @item = Item.find_by_id(hash_value['item_id'])
        next if @item.blank?

        @quantity = hash_value['Quantity'].to_i
        @quantity = @item.quantity if @item.quantity < @quantity

        if discount.positive? && @item.discount.zero? && !(user.member_type.in?(%w(silver gold)) &&
            @item.supplier.in?(%w(MARS NESTLE))) && user.email != 'development@urpetslife.com'
          @items_price += @item.price * ((100 - discount).to_f / 100) * @quantity
        else
          @items_price += (@item.price * @quantity)
        end

        @total_price_without_discount += (@item.price * @quantity)
        @discounted_items_amount += (@item.price * @quantity) if @item.discount > 0
      end
    end

    def create_order
      sub_total = @items_price.to_f.round(2)
      if user.email != 'development@urpetslife.com'
        delivery_charges = (sub_total < 100 ? 20 : 0)
      else
        delivery_charges = 7
      end

      company_discount = (@total_price_without_discount - @items_price).round(2)
      vat_charges = ((@total_price_without_discount/100).to_f * 5).round(2)
      calculate_redeem_points(sub_total)
      amount_to_be_awarded = sub_total - @permitted_redeem_points - @discounted_items_amount
      transaction_discount(amount_to_be_awarded) if amount_to_be_awarded > 0 && discount.zero? && user.email != 'development@urpetslife.com'
      total = sub_total + delivery_charges + vat_charges - company_discount - @permitted_redeem_points
      @admin_discount = total if @admin_discount > total
      total -= @admin_discount

      @order = Order.new(user_id: user.id, RedeemPoints: @permitted_redeem_points, Subtotal: @total_price_without_discount,
                         Delivery_Charges: delivery_charges, shipmenttime: 'with in 7 days', Vat_Charges: vat_charges,
                         Total: total, Order_Status: 1, Payment_Status: 1, Delivery_Date: delivery_date,
                         Order_Notes: order_notes, IsCash: true, location_id: location_id,
                         company_discount: company_discount, is_user_from_company: discount.positive?,
                         admin_discount: @admin_discount, earned_points: @discount_per_transaction)

      if @order.save
        if @permitted_redeem_points.positive?
          @user_redeem_point_record.update(net_worth: (user_redeem_points - @permitted_redeem_points),
                                           last_net_worth: user_redeem_points, last_reward_type: 'Order Deduction',
                                           last_reward_worth: @permitted_redeem_points, last_reward_update: Time.now,
                                           totalavailedpoints: (@user_redeem_point_record.totalavailedpoints
                                           + @permitted_redeem_points))
        end


        order_items_attributes.each do |hash_key, hash_value|
          item = Item.find_by_id(hash_value['item_id'])

          OrderItem.create(order_id: @order.id, item_id: item.id, Quantity: @quantity,
                           Unit_Price: item.price, Total_Price: (item.price * @quantity),
                           isdiscounted: item.discount.positive?,
                           next_recurring_due_date: DateTime.now)

          item.decrement!(:quantity, @quantity)
          send_inventory_alerts(item.id) if item.quantity < 3
        end
      end
    end

    def calculate_redeem_points(sub_total)
      requested_redeem_points = redeem_points.to_i

      if user.redeem_point.present?
        @user_redeem_point_record = user.redeem_point
      else
        @user_redeem_point_record = RedeemPoint.create(user_id: user.id, net_worth: 0, last_net_worth: 0,
                                                       totalearnedpoints: 0, totalavailedpoints: 0)
      end
      user_redeem_points = @user_redeem_point_record.net_worth

      if requested_redeem_points > 0
        if requested_redeem_points <= user_redeem_points
          @permitted_redeem_points = requested_redeem_points
        else
          @permitted_redeem_points = user_redeem_points
        end
      end

      @permitted_redeem_points = sub_total if @permitted_redeem_points > sub_total
    end

    def transaction_discount(price_for_award)
      if price_for_award <= 500
        @discount_per_transaction =+ (3*price_for_award)/100
      elsif price_for_award > 500 && price_for_award <= 1000
        @discount_per_transaction =+ (5*price_for_award)/100
      elsif price_for_award > 1000 && price_for_award <= 2000
        @discount_per_transaction =+ (7.5*price_for_award)/100
      elsif price_for_award > 2000
        @discount_per_transaction =+ (10*price_for_award)/100
      end

      @discount_per_transaction.to_f.ceil
    end

    def send_inventory_alerts(item_id)
      OrderMailer.send_low_inventory_alert(item_id).deliver_later
    end
  end
end



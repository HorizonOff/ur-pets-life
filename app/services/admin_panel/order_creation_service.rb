module AdminPanel
  class OrderCreationService

    def initialize(user, params)
      @user = user
      @params_location_id = params[:location_id]
      @order_items_attributes = params[:order][:order_items_attributes]
      @admin_discount = params[:order][:admin_discount]
      @redeem_points = params[:order][:RedeemPoints]
      @delivery_date = params[:Delivery_Date]
      @order_notes = params[:Order_Notes]

      create_order
    end

    def get_created_order
      @created_order = @order
    end

    private

    attr_reader :user, :params_location_id, :order_items_attributes, :admin_discount, :redeem_points, :delivery_date, :order_notes

    def create_order
      is_out_of_stock = false
      @items_price = 0
      @total_price_without_discount = 0
      @discounted_items_amount = 0
      permitted_redeem_points = 0
      admin_discount = 0
      discount = @user&.is_registered? ? ::Api::V1::DiscountDomainService.new(@user.email.dup).dicount_on_email : 0
      @is_user_from_company = discount.positive?

      location_id = params_location_id.present? ? params_location_id : new_location_id
      check_for_unregistered_user(location_id) if @user.blank?
      return redirect_to new_admin_panel_order_path, flash: { error: "User must exist!" } if @user.blank?

      order_items_attributes.each do |hash_key, hash_value|
        @item = Item.find_by_id(hash_value['item_id'])
        next if @item == nil
        hash_value['quantity'] = @item.quantity if @item.quantity < hash_value['quantity'].to_i

        if discount.positive? && @item.discount.zero? &&
            !(@user.member_type.in?(%w(silver gold)) && @item.supplier.in?(%w(MARS NESTLE))) &&
            @user.email != 'development@urpetslife.com'
          @items_price += @item.price * ((100 - discount).to_f / 100) * hash_value['quantity'].to_i
        else
          @items_price += (@item.price * hash_value['quantity'].to_i)
        end
        @total_price_without_discount += (@item.price * hash_value['quantity'].to_i)
        if @item.discount > 0
          @discounted_items_amount += (@item.price * hash_value['quantity'].to_i)
        end
      end
      return redirect_to new_admin_panel_order_path, flash: { error: "Item must exist!" } if @item == nil

      subTotal = @items_price.to_f.round(2)
      if @user.email != 'development@urpetslife.com'
        deliveryCharges = (subTotal < 100 ? 20 : 0)
      else
        deliveryCharges = 7
      end

      admin_discount = admin_discount.to_i if admin_discount.present?
      company_discount = (@total_price_without_discount - @items_price).round(2)
      vatCharges = ((@total_price_without_discount/100).to_f * 5).round(2)
      total = subTotal + deliveryCharges + vatCharges - company_discount
      admin_discount = total if admin_discount > total
      total -= admin_discount

      user_redeem_points = 0
      requested_redeem_points = redeem_points.to_i
      paymentStatus = 1
      if @user.redeem_point.present?
        @user_redeem_point_record = @user.redeem_point
      else
        @user_redeem_point_record = RedeemPoint.new(user_id: @user.id, net_worth: 0, last_net_worth: 0,
                                                    totalearnedpoints: 0, totalavailedpoints: 0)
        @user_redeem_point_record.save
      end
      user_redeem_points = @user_redeem_point_record.net_worth

      if requested_redeem_points > 0
        if requested_redeem_points <= user_redeem_points
          permitted_redeem_points = requested_redeem_points
        else
          permitted_redeem_points = user_redeem_points
        end
      end

      if permitted_redeem_points > subTotal
        permitted_redeem_points = subTotal
      end


      @order = Order.new(user_id: @user.id, RedeemPoints: permitted_redeem_points, Subtotal: @total_price_without_discount,
                         Delivery_Charges: deliveryCharges, shipmenttime: 'with in 7 days', Vat_Charges: vatCharges,
                         Total: total, Order_Status: 1, Payment_Status: paymentStatus,
                         Delivery_Date: delivery_date, Order_Notes: order_notes,
                         IsCash: true, is_viewed: false, location_id: location_id,
                         order_status_flag: 'pending', company_discount: company_discount,
                         is_user_from_company: @is_user_from_company, admin_discount: admin_discount)

      if @order.save
        if permitted_redeem_points > 0
          @user_redeem_point_record.update(net_worth: (user_redeem_points - permitted_redeem_points),
                                           last_net_worth: user_redeem_points, last_reward_type: 'Order Deduction',
                                           last_reward_worth: permitted_redeem_points, last_reward_update: Time.now,
                                           totalavailedpoints: (@user_redeem_point_record.totalavailedpoints
                                           + permitted_redeem_points))
        end
        discount_per_transaction = 0
        amount_to_be_awarded = subTotal - permitted_redeem_points - @discounted_items_amount
        if amount_to_be_awarded > 0 && @user.present? && (discount.blank? || discount.zero?) && @user.email != 'development@urpetslife.com'
          if amount_to_be_awarded <= 500
            discount_per_transaction =+ (3*amount_to_be_awarded)/100
          elsif amount_to_be_awarded > 500 and amount_to_be_awarded <= 1000
            discount_per_transaction =+ (5*amount_to_be_awarded)/100
          elsif amount_to_be_awarded > 1000 and amount_to_be_awarded <= 2000
            discount_per_transaction =+ (7.5*amount_to_be_awarded)/100
          elsif amount_to_be_awarded > 2000
            discount_per_transaction =+ (10*amount_to_be_awarded)/100
          end
          discount_per_transaction.to_f.ceil
        end

        @order.update(earned_points: discount_per_transaction)
        is_any_recurring_item = false
        order_items_attributes.each do |hash_key, hash_value|
          item = Item.find_by_id(hash_value['item_id'])

          @new_order_item_create = OrderItem.new(IsRecurring: false, order_id: @order.id,
                                                 item_id: item.id, Quantity: hash_value['quantity'].to_i,
                                                 Unit_Price: item.price,
                                                 Total_Price: (item.price * hash_value['quantity'].to_i),
                                                 IsReviewed: false, status: :pending,
                                                 isdiscounted: (item.discount > 0 ? true : false),
                                                 next_recurring_due_date: DateTime.now)
          @new_order_item_create.save

          item.decrement!(:quantity, hash_value['quantity'].to_i)
          if item.quantity < 3
            send_inventory_alerts(item.id)
          end
        end
      end
      get_created_order
    end
  end
end



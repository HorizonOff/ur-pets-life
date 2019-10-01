module AdminPanel
  class OrdersController < AdminPanelController
    before_action :authorize_super_admin_employee, only: :index
    before_action :set_admin_panel_order, only: [:show, :edit, :update, :destroy]
    before_action :view_new_order, only: :show

    @@filtered_user_id = 0
  # GET /admin_panel/orders
  # GET /admin_panel/orders.json
  def index
    set_filtered_user
    respond_to do |format|
      format.html {}
      format.xlsx { export_data }
      format.json { filter_orders }
    end
  end

  def show
    @shippinglocation = Location.where(:id => @admin_panel_order.location_id).first
    @shippingaddress = (@shippinglocation.villa_number.blank? ? '' : (@shippinglocation.villa_number + ' '))  + (@shippinglocation.unit_number.blank? ? '' : (@shippinglocation.unit_number + ' ')) + (@shippinglocation.building_name.blank? ? '' : (@shippinglocation.building_name + ' ')) + (@shippinglocation.street.blank? ? '' : (@shippinglocation.street + ' ')) + (@shippinglocation.area.blank? ? '' : (@shippinglocation.area + ' ')) + (@shippinglocation.city.blank? ? '' : @shippinglocation.city)
    @orderitems = OrderItem.includes(:item).where(:order_id => @admin_panel_order.id)

    if @admin_panel_order.order_status_flag == 'pending' && !@admin_panel_order.IsCash?
      @statusoption = [['Confirm', 'confirmed'], ['Delivered', 'delivered'], ['Cancel', 'cancelled']]
    elsif @admin_panel_order.order_status_flag == 'pending'
      @statusoption = [['Confirm', 'confirmed'], ['Delivered by card', 'delivered_by_card'], ['Delivered by cash', 'delivered_by_cash'], ['Cancel', 'cancelled']]
    elsif @admin_panel_order.order_status_flag == 'confirmed'
      @statusoption = [['On The Way', 'on_the_way'], ['Cancel', 'cancelled']]
    elsif @admin_panel_order.order_status_flag == 'on_the_way' && !@admin_panel_order.IsCash?
      @statusoption = [['Delivered', 'delivered'], ['Cancel', 'cancelled']]
    elsif @admin_panel_order.order_status_flag == 'on_the_way'
      @statusoption = [['Delivered by card', 'delivered_by_card'], ['Delivered by cash', 'delivered_by_cash'], ['Cancel', 'cancelled']]
    elsif @admin_panel_order.order_status_flag.in?(['delivered', 'delivered_by_card', 'delivered_by_cash'])
      @statusoption = [['Cancel', 'cancelled']]
    end
  end

  # GET /admin_panel/orders/new
  def new
    @order = Order.new
    @order.build_location
    @order.order_items.build
  end

  # GET /admin_panel/orders/1/edit
  def edit

  end

  def ordercomments
    @parent_object = Order.includes(:user).where(:id => params[:id]).first
    @parent_object.update_attributes(:unread_comments_count_by_admin => 0)
    @comments = @parent_object.comments.includes(:writable).order(id: :desc).page(params[:page])
    @comment = @parent_object.comments.new
  end
  # POST /admin_panel/orders
  # POST /admin_panel/orders.json
  def create
    is_out_of_stock = false
    @items_price = 0
    @total_price_without_discount = 0
    @discounted_items_amount = 0
    @user = User.find_by_id(params['user_id'])
    @unregistered_user = UnregisteredUser.find_by_id(params['unregistered_user_id']) if @user.blank?
    permitted_redeem_points = 0
    admin_discount = 0
    discount = @user.present? ? ::Api::V1::DiscountDomainService.new(@user.email.dup).dicount_on_email : 0
    @is_user_from_company = discount.positive?

    params['order']['order_items_attributes'].each do |hash_key, hash_value|
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
    if @user.blank? || @user.email != 'development@urpetslife.com'
      deliveryCharges = (subTotal < 100 ? 20 : 0)
    else
      deliveryCharges = 5.75
    end

    admin_discount = params['order'][:admin_discount].to_i if params['order'][:admin_discount].present?
    company_discount = (@items_price - @total_price_without_discount).round(2)
    vatCharges = ((@total_price_without_discount/100).to_f * 5).round(2)
    total = subTotal + deliveryCharges + vatCharges
    admin_discount = total if admin_discount > total
    total -= admin_discount

    if @user.present?
      user_redeem_points = 0
      requested_redeem_points = params['order'][:RedeemPoints].to_i
      paymentStatus = 0
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
    end
    check_for_unregistered_user if @unregistered_user.blank?
    unregistered_user_id = @unregistered_user&.id
    return redirect_to new_admin_panel_order_path, flash: { error: "User must exist!" } if unregistered_user_id.blank? && @user.blank?
    location_id = @user.present? ? @user.location.id : new_location_id

    @order = Order.new(user_id: params['user_id'], unregistered_user_id: unregistered_user_id,
                       RedeemPoints: permitted_redeem_points, Subtotal: @total_price_without_discount,
                       Delivery_Charges: deliveryCharges, shipmenttime: 'with in 7 days', Vat_Charges: vatCharges,
                       Total: total, Order_Status: 1, Payment_Status: paymentStatus,
                       Delivery_Date: params[:Delivery_Date], Order_Notes: params[:Order_Notes],
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
      params['order']['order_items_attributes'].each do |hash_key, hash_value|
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
      redirect_to admin_panel_order_path(@order)
    else
      render :new
    end
  end

  def calculating_price
    return render json: { subtotal: 0, total: 0 } if params['item']['order_items'].blank?
    @items_price = 0
    @total_price_without_discount = 0
    @discounted_items_amount = 0
    @user = User.find_by_id(params['item']['user_id'])
    admin_discount = 0
    discount = @user.present? ? ::Api::V1::DiscountDomainService.new(@user.email.dup).dicount_on_email : 0

    params['item']['order_items']['0'].each do |item, hash_value|
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

    subTotal = @items_price.to_f.round(2)
    if @user.blank? || @user.email != 'development@urpetslife.com'
      deliveryCharges = (subTotal < 100 ? 20 : 0)
    else
      deliveryCharges = 5.75
    end
    admin_discount = params['item'][:admin_discount].to_i
    redeem_points = params['item'][:RedeemPoints].to_i
    vatCharges = ((@total_price_without_discount/100).to_f * 5).round(2)
    total = subTotal + deliveryCharges + vatCharges
    if admin_discount > total && redeem_points > 0
      admin_discount = total
      redeem_points = 0
    elsif redeem_points + admin_discount > total && redeem_points != 0
      with_discount = total - admin_discount
      admin_discount = 0
      if redeem_points > with_discount
        redeem_points = with_discount
      else
        with_discount -= redeem_points
        redeem_points = 0
      end
      total = with_discount
    end
    admin_discount = total if admin_discount > total

    total -= admin_discount + redeem_points
    render json: { subtotal: subTotal, total: total.round(2) }
  end

  def max_quantity
    quantity = Item.find_by(id: params['item']['item_id'])&.quantity

    render json: { quantity: quantity || 1}
  end

  def invoice
    @order = Order.where(:id => params[:id]).first
    respond_to do |format|
      format.pdf do
        pdf = render_to_string  pdf: "INV-#{@order.id}.pdf",
                                layout: "pdf.html.erb",
                                show_as_html: false,
                                encoding: "UTF-8",
                                template: "admin_panel/invoices/show.html.erb"
      send_data pdf, filename: "INV-#{@order.id}.pdf", type: "application/pdf", disposition: "attachment"
      end
    end
  end

  def cancel
    orderitem = OrderItem.where(:id => params[:id]).first
    orderitem.update_attributes(status: :cancelled)

    updateordertocancel = true
    discountedproductsprice = 0
    allorderitems = OrderItem.where(:order_id => orderitem.order_id)
    allorderitems.each do |items|
      if items.status != 'cancelled'
        if items.isdiscounted == true
          discountedproductsprice += items.Total_Price
        end
        updateordertocancel = false
      end
    end

    order = Order.where(:id => orderitem.order_id).first

    order_amount_remaining = order.Subtotal - orderitem.Total_Price
    redeem_points_consumed = order.RedeemPoints

    points_to_be_reverted = 0
    if order_amount_remaining >= redeem_points_consumed
      points_to_be_reverted = 0
    elsif order_amount_remaining < redeem_points_consumed
       points_to_be_reverted = redeem_points_consumed - order_amount_remaining
    end

    if updateordertocancel == true
      order.update(:Subtotal => 0, :Delivery_Charges => 0, :Vat_Charges => 0, :Total => 0, :order_status_flag => 'cancelled', :earned_points => 0, :RedeemPoints => 0)
    else
      subTotal = (order.Subtotal - orderitem.Total_Price).to_f.round(2)
      deliveryCharges = subTotal > 100 ? 0 : 20
      vatCharges = ((subTotal/100).to_f * 5).round(2)
      total = subTotal + deliveryCharges + vatCharges

      discount_per_transaction = 0
      if orderitem.isdiscounted == false
        order_price_for_award = subTotal - (order.RedeemPoints - points_to_be_reverted) - discountedproductsprice
        if order_price_for_award <= 500
          discount_per_transaction =+ (3*order_price_for_award)/100
        elsif order_price_for_award > 500 and order_price_for_award <= 1000
          discount_per_transaction =+ (5*order_price_for_award)/100
        elsif order_price_for_award > 1000 and order_price_for_award <= 2000
          discount_per_transaction =+ (7.5*order_price_for_award)/100
        elsif order_price_for_award > 2000
          discount_per_transaction =+ (10*order_price_for_award)/100
        end
        discount_per_transaction.to_f.ceil
      end

      if orderitem.isdiscounted == true
        discount_per_transaction = order.earned_points
      end
      # if points_to_be_reverted > 0
      #   deliveryCharges = (subTotal - (redeem_points_consumed - points_to_be_reverted)) > 100 ? 0 : 20
      #   total = subTotal + deliveryCharges + vatCharges
      # end

      order.update(:Subtotal => subTotal, :Delivery_Charges => deliveryCharges, :Vat_Charges => vatCharges, :Total => total, :RedeemPoints => order.RedeemPoints - points_to_be_reverted, :earned_points => discount_per_transaction)
    end

    user_redeem_point_record = RedeemPoint.where(:user_id => order.user_id).first
    userpoints = user_redeem_point_record.net_worth

    user_redeem_point_record.update(:net_worth => userpoints  + points_to_be_reverted, :last_net_worth => userpoints, :last_reward_type => "Discount Per Transaction (Order Cancel Roll Back)", :last_reward_worth => points_to_be_reverted, :last_reward_update => Time.now, :totalavailedpoints => user_redeem_point_record.totalavailedpoints - points_to_be_reverted)

    item = Item.where(:id => orderitem.item_id).first
    if !item.nil?
      item.increment!(:quantity, orderitem.Quantity)
    end
    if updateordertocancel != true
      send_order_cancellation_email(orderitem.id)
    else
      OrderMailer.send_complete_cancel_order_email_to_customer(order.id, order.user.email).deliver
    end

    redirect_to action: 'show', id: orderitem.order_id
  end
  # PATCH/PUT /admin_panel/orders/1
  # PATCH/PUT /admin_panel/orders/1.json
  def update
    statustoupdate = params["order"]["order_status_flag"].to_s

    if @admin_panel_order.update(:order_status_flag => statustoupdate)
      @admin_panel_order.order_items.each do |orderitem|
        if orderitem.status != 'cancelled'
          if statustoupdate == 'cancelled'
            item = Item.where(:id => orderitem.item_id).first
            if !item.nil?
              item.increment!(:quantity, orderitem.Quantity)
            end
          end
          orderitem.update(:status => statustoupdate)
        end
      end

      if @admin_panel_order.user_id.present?
        orderuser = User.where(:id => @admin_panel_order.user_id).first
        orderuser.notifications.create(order: @admin_panel_order, message: 'Your Order status for Order # ' + @admin_panel_order.id.to_s + ' has been ' + (statustoupdate == 'cancelled' ? 'Cancelled' : 'updated to ' + (statustoupdate == 'on_the_way' ? 'on the way' : statustoupdate)))

        if statustoupdate.in?(%w(delivered delivered_by_card delivered_by_cash))
          set_order_delivery_invoice(@admin_panel_order.id, orderuser.email)
          @admin_panel_order.update_attributes(Payment_Status: 1)
          if @admin_panel_order.used_pay_code.present?
            @admin_panel_order.used_pay_code.notifications
              .create(message: '30 points have been added to your account since your friend used your Pay It Forward code',
                      user_id: @admin_panel_order.used_pay_code.user.id)
            if @admin_panel_order.user.pay_code.blank?
              @admin_panel_order.used_pay_code.notifications
                .create(message: 'A Pay It Forward code is now available for you so you can share it with 3 of your friends and receive 30 points from each of them. You can find the code under “ My Codes “ in the main Menu',
                        user_id: @admin_panel_order.used_pay_code.code_user.id)
              @admin_panel_order.used_pay_code.create_new_pay_code
            end
            @admin_panel_order.used_pay_code.add_redeem_points
          elsif @admin_panel_order.user.pay_code.blank?
            @admin_panel_order.user.generate_pay_code
            @admin_panel_order.user.notifications
              .create(message: 'A Pay It Forward code is now available for you so you can share it with 3 of your friends and receive 30 points from each of them. You can find the code under “ My Codes “ in the main Menu',
                      user_id: @admin_panel_order.user_id)
          end

          if statustoupdate == 'confirmed'
            user_redeem_points_record = RedeemPoint.where(:user_id => @admin_panel_order.user_id).first
            user_redeem_points_record.update(:net_worth => user_redeem_points_record.net_worth + @admin_panel_order.earned_points, :last_net_worth => user_redeem_points_record.net_worth, :last_reward_type => "Discount Per Transaction", :last_reward_worth => @admin_panel_order.earned_points, :last_reward_update => Time.now, :totalearnedpoints => (user_redeem_points_record.totalearnedpoints + @admin_panel_order.earned_points))
            send_order_confirmation_email_to_customer(@admin_panel_order.id)
          end

          if statustoupdate == 'cancelled'
            user_redeem_point_reimburse = RedeemPoint.where(:user_id => @admin_panel_order.user_id).first
            user_redeem_point_reimburse.update(:net_worth => user_redeem_point_reimburse.net_worth + @admin_panel_order.RedeemPoints, :totalavailedpoints => user_redeem_point_reimburse.totalavailedpoints - @admin_panel_order.RedeemPoints)
            @admin_panel_order.update(:Subtotal => 0, :Delivery_Charges => 0, :Vat_Charges => 0, :Total => 0, :order_status_flag => 'cancelled', :earned_points => 0, :RedeemPoints => 0)

            OrderMailer.send_complete_cancel_order_email_to_customer(@admin_panel_order.id, @admin_panel_order.user.email).deliver
          end
        end
      end

      flash[:success] = 'Order Item was successfully updated'
      redirect_to controller: 'orders', action: 'show', id: @admin_panel_order.id
    else
      render :show
    end
  end

  # DELETE /admin_panel/orders/1
  # DELETE /admin_panel/orders/1.json
  def destroy
    @admin_panel_order.destroy
    respond_to do |format|
      format.html { redirect_to admin_panel_orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def check_for_unregistered_user
      return if params['order']['unregistered_user'].blank?

      @unregistered_user = UnregisteredUser.find_or_create_by(name: params['order']['unregistered_user']['name'],
                                                              number: params['order']['unregistered_user']['number'])
    end

    def send_inventory_alerts(itemid)
      OrderMailer.send_low_inventory_alert(itemid).deliver_later
    end

    def new_location_id
      Location.create(order_params[:location_attributes]).id
    end

    def order_params
      params.require(:order).permit(location_attributes: location_params)
    end

    def location_params
      %i[latitude longitude city area street building_type building_name unit_number villa_number comment]
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_admin_panel_order
      @admin_panel_order = Order.find(params[:id])
    end

    def set_order_delivery_invoice(orderid, userEmail)
      OrderMailer.send_order_delivery_invoice(orderid, ENV['ADMIN']).deliver
      OrderMailer.send_order_delivery_invoice(orderid, userEmail).deliver
    end

    def send_order_confirmation_email_to_customer(orderid)
      OrderMailer.send_order_confimation_notification_to_customer(orderid).deliver
    end

    def send_order_cancellation_email(orderitemid)
      OrderMailer.send_order_cancellation_notification_to_customer(orderitemid).deliver
      OrderMailer.send_order_cancellation_notification_to_admin(orderitemid).deliver
    end

    def view_new_order
      orderdetails = Order.where(:id => @admin_panel_order.id).first
      orderdetails.update_attribute(:is_viewed, true)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    #def admin_panel_order_params
    #  params.fetch(:admin_panel_order, {})
    #end

    def filter_orders
      filtered_orders = filter_and_pagination_query.filter
      filtered_orders = filtered_orders
      decorated_data = ::AdminPanel::OrderDecorator.decorate_collection(filtered_orders)
      serialized_data = ActiveModel::Serializer::CollectionSerializer.new(
        decorated_data, serializer: ::AdminPanel::OrderSerializer, adapter: :attributes
      )

      render json: { draw: params[:draw], recordsTotal: filtered_orders.count,
                     recordsFiltered: filtered_orders.total_count, data: serialized_data }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('Order', params)
    end

    def set_filtered_user
      if !params.has_key?(:request_type)
        if !params[:user_id].blank?
          @@filtered_user_id = params[:user_id].to_i
        else
          @@filtered_user_id = 0
        end
      end
    end

    def export_data
      is_user_present = @@filtered_user_id > 0 ? false : true
      @orders = Order.visible.order(:id).includes(:location, { user: [:location] }, { order_items: [item: :item_brand] })
                     .where("(users.id = (?) OR #{is_user_present}) AND order_status_flag IN (?)",
                            @@filtered_user_id, ['delivered', 'delivered_by_card', 'delivered_by_cash'])
                     .references(:user)
      if params[:from_date].present? && params[:to_date].present?
        @orders = @orders.created_in_range(params[:from_date].to_date.beginning_of_day,
                                           params[:to_date].to_date.end_of_day)
      end
      user_name = @@filtered_user_id > 0 ? User.where(:id => @@filtered_user_id).first.first_name + '_' : 'all_'
      name = "Orders_for_#{user_name} #{Time.now.utc.strftime('%d-%M-%Y')}.xlsx"
      response.headers['Content-Disposition'] = "attachment; filename*=UTF-8''#{name}"
    end
  end
end

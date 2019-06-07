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

    if @admin_panel_order.order_status_flag == 'pending'
      @statusoption = [['Confirm', 'confirmed'], ['Cancel', 'cancelled']]
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
    @admin_panel_order = OrderItem.new
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
    @admin_panel_order = OrderItem.new(admin_panel_order_params)

    respond_to do |format|
      if @admin_panel_order.save
        format.html { redirect_to @admin_panel_order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @admin_panel_order }
      else
        format.html { render :new }
        format.json { render json: @admin_panel_order.errors, status: :unprocessable_entity }
      end
    end
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
          orderitem.update(:status => statustoupdate)
        end
      end
      orderuser = User.where(:id => @admin_panel_order.user_id).first
      orderuser.notifications.create(order: @admin_panel_order, message: 'Your Order status for Order # ' + @admin_panel_order.id.to_s + ' has been ' + (statustoupdate == 'cancelled' ? 'Cancelled' : 'updated to ' + (statustoupdate == 'on_the_way' ? 'on the way' : statustoupdate)))

      if statustoupdate == 'delivered'
        set_order_delivery_invoice(@admin_panel_order.id, orderuser.email)
        @admin_panel_order.update_attributes(Payment_Status: 1)
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

        @admin_panel_order.order_items.each do |orderitem|
          if orderitem.status != "cancelled"
            item = Item.where(:id => orderitem.item_id).first
            if !item.nil?
              item.increment!(:quantity, orderitem.Quantity)
            end
          end
        end

        OrderMailer.send_complete_cancel_order_email_to_customer(@admin_panel_order.id, @admin_panel_order.user.email).deliver
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

      @orders = Order.order(:id).includes(:location, {user: [:location]}, {order_items: [item: :item_brand]})
                                .where("(users.id = (?) OR #{is_user_present}) AND order_status_flag = (?)",
                                       @@filtered_user_id, 'delivered').references(:user)
      if params[:from_date].present? && params[:to_date].present?
        @orders = @orders.created_in_range(params[:from_date].to_date.beginning_of_day, params[:to_date].to_date.end_of_day)
      end
      user_name = @@filtered_user_id > 0 ? User.where(:id => @@filtered_user_id).first.first_name + '_' : 'all_'
      name = "Orders_for_#{user_name} #{Time.now.utc.strftime('%d-%M-%Y')}.xlsx"
      response.headers['Content-Disposition'] = "attachment; filename*=UTF-8''#{name}"
    end
  end
end

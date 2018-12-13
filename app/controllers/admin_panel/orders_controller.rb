module AdminPanel
  class OrdersController < AdminPanelController
    before_action :authorize_super_admin, only: :index
    before_action :set_admin_panel_order, only: [:show, :edit, :update, :destroy]
    before_action :view_new_order, only: :show
  # GET /admin_panel/orders
  # GET /admin_panel/orders.json
  def index
    respond_to do |format|
      format.html {}
      format.json { filter_orders }
    end
  end

  # GET /admin_panel/orders/1
  # GET /admin_panel/orders/1.json
  def show
    @parentorderinfo = Order.includes(:user).where(:id => @admin_panel_order.order_id).first
    @orderiteminfo = Item.where(:id => @admin_panel_order.item_id).first
    @shippinglocation = Location.where(:id => @parentorderinfo.location_id).first
    @shippingaddress = (@shippinglocation.villa_number.blank? ? '' : (@shippinglocation.villa_number + ' '))  + (@shippinglocation.unit_number.blank? ? '' : (@shippinglocation.unit_number + ' ')) + (@shippinglocation.building_name.blank? ? '' : (@shippinglocation.building_name + ' ')) + (@shippinglocation.street.blank? ? '' : (@shippinglocation.street + ' ')) + (@shippinglocation.area.blank? ? '' : (@shippinglocation.area + ' ')) + (@shippinglocation.city.blank? ? '' : @shippinglocation.city)

    if @admin_panel_order.status == 'pending'
      @statusoption = [['Comfirm', 'confirmed'], ['Cancel', 'cancelled']]
    elsif @admin_panel_order.status == 'confirmed'
      @statusoption = [['On The Way', 'on_the_way']]
    elsif @admin_panel_order.status == 'on_the_way'
      @statusoption = [['Delievered', 'delivered']]
    end

  end

  # GET /admin_panel/orders/new
  def new
    @admin_panel_order = OrderItem.new
  end

  # GET /admin_panel/orders/1/edit
  def edit

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

  # PATCH/PUT /admin_panel/orders/1
  # PATCH/PUT /admin_panel/orders/1.json
  def update
    statustoupdate = params["order_item"]["updated_status"].to_s

    if @admin_panel_order.update(:status => statustoupdate)
      parentorder = Order.where(:id => @admin_panel_order.order_id).first
      orderuser = User.where(:id => parentorder.user_id).first
      itemordered = Item.where(:id => @admin_panel_order.item_id).first

      orderuser.notifications.create(order: parentorder, message: 'Your Order status for ' + itemordered.name + ' has been updated to ' + statustoupdate)

      if statustoupdate == 'delivered'
        sendInvoice = true
        orderItems = OrderItem.where(:order_id => @admin_panel_order.order_id)
        orderItems.each do |itemtocheck|
          if (itemtocheck.status != 'delivered' and itemtocheck.status != 'cancelled')
            sendInvoice = false
          end
        end
        if sendInvoice == true
          orderinfo = Order.where(:id => @admin_panel_order.order_id).first
          customerInfo = User.where(:id => orderinfo.user_id).first
          set_order_delivery_invoice(orderinfo.id, customerInfo.email)
        end
      end

      if statustoupdate == 'confirmed'
        send_order_confirmation_email_to_customer(@admin_panel_order.id)
      end

      if statustoupdate == 'cancelled'
        orderitem = @admin_panel_order
        order = Order.where(:id => orderitem.order_id).first
        subTotal = order.Subtotal - orderitem.Total_Price
        deliveryCharges = subTotal > 100 ? 0 : 20
        vatCharges = (subTotal/100).to_f * 5
        total = subTotal + deliveryCharges + vatCharges

        order.update(:Subtotal => subTotal, :Delivery_Charges => deliveryCharges, :Vat_Charges => vatCharges, :Total => total)

        user_redeem_point_record = RedeemPoint.where(:user_id => order.user_id).first
        userpoints = user_redeem_point_record.net_worth
        discount_per_transaction = 0
        target_revert_price = orderitem.Total_Price

        if target_revert_price <= 500
          discount_per_transaction =+ (3*target_revert_price)/100
        elsif target_revert_price > 500 and target_revert_price <= 1000
          discount_per_transaction =+ (5*target_revert_price)/100
        elsif target_revert_price > 1000 and target_revert_price <= 2000
          discount_per_transaction =+ (7.5*target_revert_price)/100
        elsif target_revert_price > 2000
          discount_per_transaction =+ (10*target_revert_price)/100
        end

        points_to_be_deducted_on_cancel = 0
        if (userpoints > 0 and userpoints < discount_per_transaction)
          points_to_be_deducted_on_cancel = userpoints
        elsif userpoints >= discount_per_transaction
          points_to_be_deducted_on_cancel = discount_per_transaction
        end
        user_redeem_point_record.update(:net_worth => (userpoints -  points_to_be_deducted_on_cancel), :last_net_worth => userpoints, :last_reward_type => "Discount Per Transaction (Order Cancel Roll Back)", :last_reward_worth => discount_per_transaction, :last_reward_update => Time.now, :totalearnedpoints => (user_redeem_point_record.totalearnedpoints - points_to_be_deducted_on_cancel))

        item = Item.where(:id => orderitem.item_id).first
        if !item.nil?
          item.increment!(:quantity, orderitem.Quantity)
        end

        order.update(:earned_points => (order.earned_points - points_to_be_deducted_on_cancel))
        send_order_cancellation_email_to_customer(@admin_panel_order.id)
      end

      flash[:success] = 'Order Item was successfully updated'
      redirect_to admin_panel_orders_path
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
      @admin_panel_order = OrderItem.find(params[:id])
    end

    def set_order_delivery_invoice(orderid, userEmail)
      OrderMailer.send_order_delivery_invoice(orderid, ENV['ADMIN']).deliver
      OrderMailer.send_order_delivery_invoice(orderid, userEmail).deliver
    end

    def send_order_confirmation_email_to_customer(orderitemid)
      OrderMailer.send_order_confimation_notification_to_customer(orderitemid).deliver
    end

    def send_order_cancellation_email_to_customer(orderitemid)
      OrderMailer.send_order_cancellation_notification_to_customer(orderitemid).deliver
    end

    def view_new_order
      orderdetails = Order.where(:id => @admin_panel_order.order_id).first
      orderdetails.update_attribute(:is_viewed, true)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_panel_order_params
      params.fetch(:admin_panel_order, {})
    end

    def filter_orders
      filtered_orders = filter_and_pagination_query.filter
      filtered_orders = filtered_orders.order(id: :desc)
      decorated_data = ::AdminPanel::OrderDecorator.decorate_collection(filtered_orders)
      serialized_data = ActiveModel::Serializer::CollectionSerializer.new(
        decorated_data, serializer: ::AdminPanel::OrderSerializer, adapter: :attributes
      )

      render json: { draw: params[:draw], recordsTotal: filtered_orders.count,
                     recordsFiltered: filtered_orders.total_count, data: serialized_data }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('OrderItem', params)
    end

end
end

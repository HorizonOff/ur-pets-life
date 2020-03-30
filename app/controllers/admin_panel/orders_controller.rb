module AdminPanel
  class OrdersController < AdminPanelController
    include AdminPanel::OrderUpdateHelper
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
    @shipping_address = Location.find_by_id(@admin_panel_order.location_id).address
    @order_items = OrderItem.joins(:item).where(order_id: @admin_panel_order.id)

    if @admin_panel_order.order_status_flag == 'pending' && !@admin_panel_order.IsCash?
      @option_status = [%w(Confirm confirmed), %w(Cancel cancelled)]

    elsif @admin_panel_order.order_status_flag == 'pending'
      @option_status = [%w(Confirm confirmed), %w(Delivered\ by\ card delivered_by_card),
                        %w(Delivered\ by\ cash delivered_by_cash), %w(Delivered\ online delivered_online),
                        %w(Cancel cancelled)]

    elsif @admin_panel_order.order_status_flag == 'confirmed'
      @option_status = [%w(On\ The\ Way on_the_way), %w(Cancel cancelled)]

    elsif @admin_panel_order.order_status_flag == 'on_the_way' && !@admin_panel_order.IsCash?
      @option_status = [%w(Delivered delivered), %w(Cancel cancelled)]

    elsif @admin_panel_order.order_status_flag == 'on_the_way'
      @option_status = [%w(Delivered\ by\ card delivered_by_card), %w(Delivered\ by\ cash delivered_by_cash),
                        %w(Delivered\ online delivered_online), %w(Cancel cancelled)]

    elsif @admin_panel_order.order_status_flag.in?(%w(delivered delivered_by_card delivered_by_cash delivered_online))
      @option_status = [%w(Cancel cancelled)]
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
    user = User.find_by_id(params['user_id'])
    order = AdminPanel::OrderCreationService.new(user, params)

    if order.get_created_order.persisted?
      redirect_to admin_panel_order_path(order.get_created_order)
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
    discount = @user&.is_registered? ? ::Api::V1::DiscountDomainService.new(@user.email.dup).dicount_on_email : 0

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
      deliveryCharges = 7
    end
    company_discount = (@total_price_without_discount - @items_price).round(2)
    admin_discount = params['item'][:admin_discount].to_f
    redeem_points = params['item'][:RedeemPoints].to_i
    vatCharges = ((@total_price_without_discount/100).to_f * 5).round(2)
    total = subTotal + deliveryCharges + vatCharges + company_discount
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
    render json: { subtotal: subTotal, total: total }
  end

  def max_quantity
    quantity = Item.find_by(id: params['item']['item_id'])&.quantity

    render json: { quantity: quantity || 1}
  end

  def user_locations
    locations = Location.where(place_id: params['user_id'], place_type: 'User')

    render json: { locations: locations }
  end

  def invoice
    order = Order.find_by_id(params[:id])
    user_address = Location.find_by_id(order.location_id).address

    respond_to do |format|
      format.pdf do
        pdf = render_to_string  pdf: "INV-#{order.id}.pdf",
                                layout: "pdf.html.erb",
                                show_as_html: false,
                                encoding: "UTF-8",
                                template: "admin_panel/invoices/_show.html.erb",
                                locals: { order: order, user_address: user_address }
      send_data pdf, filename: "INV-#{order.id}.pdf", type: "application/pdf", disposition: "attachment"
      end
    end
  end

  def download_order
    @order = Order.find_by_id(params[:id])

    respond_to do |format|
      format.pdf do
        pdf = render_to_string  pdf: "Order-#{@order.id}.pdf",
                                layout: "pdf.html.erb",
                                show_as_html: false,
                                encoding: "UTF-8",
                                template: "admin_panel/orders/order.html.erb"
        send_data(pdf, filename: "Order-#{@order.id}.pdf", type: "application/pdf", disposition: "attachment")
      end
    end
  end

  def cancel
    orderitem = OrderItem.where(:id => params[:id]).first
    orderitem.update_attributes(status: :cancelled)

    order = Order.find_by_id(orderitem.order_id)
    discount = ::Api::V1::DiscountDomainService.new(order.user.email.dup).dicount_on_email

    updateordertocancel = true
    discountedproductsprice = 0
    discounted_price = 0
    allorderitems = OrderItem.where(:order_id => orderitem.order_id)
    allorderitems.each do |items|
      if items.status != 'cancelled'
        if items.isdiscounted == true
          discountedproductsprice += items.Total_Price
        end

        if discount.positive?
          discounted_price += (items.Total_Price * ((100 - discount).to_f / 100).round(2)) - items.Total_Price
        end

        updateordertocancel = false
      end
    end

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
      total = subTotal + deliveryCharges + vatCharges + discounted_price + order.code_discount

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

      order.update(Subtotal: subTotal,
                   Delivery_Charges: deliveryCharges,
                   Vat_Charges: vatCharges,
                   Total: total,
                   RedeemPoints: order.RedeemPoints - points_to_be_reverted,
                   earned_points: discount_per_transaction,
                   company_discount: discounted_price)
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
    if @admin_panel_order.update(order_status_flag: params["order"]["order_status_flag"])
      update_status(@admin_panel_order)

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
    def check_for_unregistered_user(location_id)
      return if params['order']['unregistered_user'].blank?

      @user = User.find_by(first_name: params['order']['unregistered_user']['name'])

      if @user.blank?
        @user = User.new(first_name: params['order']['unregistered_user']['name'],
                         mobile_number: params['order']['unregistered_user']['number'],
                         location_ids: location_id,
                         is_registered: false)

        @user.skip_user_validation = true
        @user.save
      end
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
                            @@filtered_user_id, %w(delivered delivered_by_card delivered_by_cash delivered_online))
                     .references(:user)
      if params[:from_date].present? && params[:to_date].present?
        @orders = @orders.delivery_in_range(params[:from_date].to_date.beginning_of_day,
                                           params[:to_date].to_date.end_of_day)
      end
      user_name = @@filtered_user_id > 0 ? User.where(:id => @@filtered_user_id).first.first_name + '_' : 'all_'
      name = "Orders_for_#{user_name} #{Time.now.utc.strftime('%d-%M-%Y')}.xlsx"
      response.headers['Content-Disposition'] = "attachment; filename*=UTF-8''#{name}"
    end
  end
end

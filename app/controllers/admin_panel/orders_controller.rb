module AdminPanel
  class OrdersController < AdminPanelController
    before_action :authorize_super_admin_employee, only: :index
    before_action :set_admin_panel_order, only: [:show, :order_comments, :edit, :update, :destroy]
    before_action :view_new_order, only: :show
    before_action :check_for_unregistered_user, only: :create
    before_action :set_user, only: [:create, :calculating_price]

  def index
    respond_to do |format|
      format.html {}
      format.xlsx { export_data }
      format.json { filter_orders }
    end
  end

  def show
    @shipping_address = Location.find_by_id(@admin_panel_order.location_id).address

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

  def new
    @order = Order.new
    @order.build_location
    @order.order_items.build
  end

  def order_comments
    @parent_object = Order.includes(:user).where(:id => params[:id]).first
    @parent_object.update_attributes(:unread_comments_count_by_admin => 0)
    @comments = @parent_object.comments.includes(:writable).order(id: :desc).page(params[:page])
    @comment = @parent_object.comments.new
  end

  def create
    return redirect_to new_admin_panel_order_path, flash: { error: "User must exist!" } if @user.blank?

    order = AdminPanel::OrderCreateService.new(@user, @location_id, params, false).order_create

    return redirect_to new_admin_panel_order_path, flash: { error: "Item must exist!" } if order == "Items blank!"

    if order.persisted?
      redirect_to admin_panel_order_path(order)
    else
      render :new
    end
  end

  def calculating_price
    return render json: { subtotal: 0, total: 0 } if params['item']['order_items'].blank?

    calculating_output = AdminPanel::OrderCreateService.new(@user, nil, params, true).order_create

    render json: { subtotal: calculating_output.first, total: calculating_output.last }
  end

  def max_quantity
    quantity = Item.find_by_id(params['item']['item_id'])&.quantity

    render json: { quantity: quantity || 1}
  end

  def get_items_quantities
    quantities_array = []
    params[:ids_array].each do |item_id|
      next if item_id.blank?

      item = Item.find_by_id(item_id)
      quantities_array.push(item.quantity)
    end

    render json: { quantities_array: quantities_array }
  end

  def user_locations
    locations = Location.where(place_id: params['user_id'], place_type: 'User')

    render json: { locations: locations }
  end

  def invoice
    user_address = Location.find_by_id(@admin_panel_order.location_id).address

    respond_to do |format|
      format.pdf do
        pdf = render_to_string  pdf: "INV-#{@admin_panel_order.id}.pdf",
                                layout: "pdf.html.erb",
                                show_as_html: false,
                                encoding: "UTF-8",
                                template: "admin_panel/invoices/_show.html.erb",
                                locals: { order: @admin_panel_order, user_address: user_address }
        send_data(pdf, filename: "INV-#{@admin_panel_order.id}.pdf", type: "application/pdf", disposition: "attachment")
      end
    end
  end

  def download_order
    respond_to do |format|
      format.pdf do
        pdf = render_to_string  pdf: "Order-#{@admin_panel_order.id}.pdf",
                                layout: "pdf.html.erb",
                                show_as_html: false,
                                encoding: "UTF-8",
                                template: "admin_panel/orders/order.html.erb"
        send_data(pdf, filename: "Order-#{@admin_panel_order.id}.pdf", type: "application/pdf", disposition: "attachment")
      end
    end
  end

  def cancel
    order_item = OrderItem.find_by_id(params[:id])

    AdminPanel::EditOrderItemService.new(order_item.order, nil, order_item).cancel

    redirect_to action: 'show', id: order_item.order_id
  end

  def update
    if params[:commit] == 'Edit order'
      AdminPanel::EditOrderItemService.new(@admin_panel_order, params, nil).update

      flash[:success] = 'Order was successfully updated'
      return redirect_to controller: 'orders', action: 'show'
    end

    if @admin_panel_order.update(order_status_flag: params["order"]["order_status_flag"])
      OrdersServices::OrderStatusUpdateService.new(@admin_panel_order,
                                                   params["order"]["order_status_flag"],
                                                   params['TransactionId']).update_order_status

      flash[:success] = 'Order Item was successfully updated'
      redirect_to controller: 'orders', action: 'show', id: @admin_panel_order.id
    else
      flash[:error] = 'Some error was occurred! Please try again!'
      render :show
    end
  end

  def destroy
    @admin_panel_order.destroy
    respond_to do |format|
      format.html { redirect_to admin_panel_orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def check_for_unregistered_user
      @location_id = params[:location_id].present? ? params[:location_id] : new_location_id

      return if params['order']['unregistered_user'].blank?

      @user = User.find_by(first_name: params['order']['unregistered_user']['name'])

      if @user.blank?
        @user = User.new(first_name: params['order']['unregistered_user']['name'],
                         mobile_number: params['order']['unregistered_user']['number'],
                         location_ids: @location_id,
                         is_registered: false)

        @user.skip_user_validation = true
        @user.save
      end
    end

    def set_user
      @user = User.find_by_id(params['user_id'])
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

    def set_admin_panel_order
      @admin_panel_order = Order.find_by_id(params[:id])
    end

    def view_new_order
      @admin_panel_order.update_attribute(:is_viewed, true)
    end

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

    def export_data
      return if (params[:from_date] || params[:to_date]).blank?

      @orders = Order.visible.includes(:location, :user, order_items: :item).where("order_status_flag IN (:states) AND
                        (updated_at IS NOT NULL AND updated_at > :from_date AND updated_at < :to_date) OR
                        (updated_at IS NULL AND updated_at > :from_date AND updated_at < :to_date)",
                                    states: %w(delivered delivered_by_card delivered_by_cash delivered_online),
                                    from_date: params[:from_date].to_date.beginning_of_day,
                                    to_date: params[:to_date].to_date.end_of_day)

      name = "Orders_for_all_ #{Time.now.utc.strftime('%d-%M-%Y')}.xlsx"
      response.headers['Content-Disposition'] = "attachment; filename*=UTF-8''#{name}"
    end
  end
end

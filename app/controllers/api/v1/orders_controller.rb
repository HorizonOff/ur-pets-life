module Api
  module V1
    class OrdersController < Api::BaseController
      before_action :set_order, only: %w[show re_oder_on_order_id edit update destroy]
      before_action :set_user_cart_items, only: [:create]

      def index
        @orders = @user.orders.visible.includes(:location, order_items: %w[item recurssion_interval item_reviews])
        return render json: { Message: 'No Orders found' } if @orders.blank?

        if (params[:pageno] && params[:size]).present?
          @orders = @orders.limit(params[:size].to_i).offset(params[:pageno].to_i * params[:size].to_i)
        end

        serialized_orders = ActiveModel::Serializer::CollectionSerializer.new(@orders, serializer: OrderIndexSerializer)
        render json: serialized_orders, include: [:location, order_items: %w[item recurssion_interval item_reviews]]
      end

      def admin_orders
        @orders = @user.orders.visible
        @orders = Order.visible if @user.try(:role) == 'super_admin'
        orders_count = @orders.count
        @orders = @orders.where(Payment_Status: 1).order(created_at: :desc).page(params[:page]).per(params[:per_page])
        return render json: { Message: 'No Orders found' } if @orders.blank?

        serialized_orders = ActiveModel::Serializer::CollectionSerializer.new(
          @orders, serializer: OrderSerializer
        )
        render json: { orders: serialized_orders, total_count: orders_count }
      end

      def show
        render json: @order, include: [:location, :user, :driver, order_items: %w[item recurssion_interval item_reviews]],
                             serializer: OrderShowSerializer, adapter: :attributes
      end

      def create
        @order = Api::V1::OrderServices::OrderCreateService.new(@user, @location_id, @user_cart_items, params).order_create

        if @order.persisted?
          render json: {
            Message: "Order was successfully created.",
            status: :created,
            VatPercentage: "5",
            OrderDetails:
              ActiveModelSerializers::SerializableResource.new(@order,
                                                               include: [:location, :user, :driver,
                                                                         order_items: %w[item recurssion_interval item_reviews]],
                                                               adapter: :attributes,
                                                               serializer: OrderCreateSerializer)
          }
        else
          render json: { Message: 'Error creating order', status: :unprocessable_entity, errors: @order.errors }
        end
      end

      def update
        @order.update(order_params)
        OrdersServices::OrderStatusUpdateService.new(@order, params[:order][:order_status_flag], params[:TransactionId]).update_order_status

        render json: {
          Message: 'Order was successfully updated.',
          status: :updated,
          VatPercentage: "5",
          OrderDetails:
            ActiveModelSerializers::SerializableResource.new(@order,
                                                             include: [:location, :user, :driver,
                                                                       order_items: %w[item recurssion_interval item_reviews]],
                                                             adapter: :attributes,
                                                             serializer: OrderUpdateSerializer)
        }
      end

      def destroy
        @order.order_items.destroy_all
        @order.destroy
        respond_to do |format|
          format.json do
            render json: {
              Message: 'Order was successfully destroyed.',
              status: :deleted
            }
          end
        end
      end

      private

      def set_order
        @order = Order.find_by_id(params[:id])
        return render_404 unless @order
      end

      def set_user_cart_items
        @location_id = params[:location_id].present? ? params[:location_id] : new_location_id

        @user_cart_items = @user.shopping_cart_items
        return render json: { Message: 'Cart Empty', status: :unprocessable_entity } if @user_cart_items.blank?
      end

      def order_params
        params.permit(:TransactionId, :TransactionDate, :IsCash, :order_status_flag,
                      :driver_id, location_attributes: location_params)
      end

      def location_params
        %i[latitude longitude city area street building_type building_name unit_number villa_number comment]
      end
    end
  end
end

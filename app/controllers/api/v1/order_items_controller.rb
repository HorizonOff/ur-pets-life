module Api
  module V1
    class OrderItemsController < Api::BaseController
      before_action :set_order_item, only: [:show, :edit, :update, :destroy]
      skip_before_action :authenticate_user, only: :app_base_end_point

      def index
        @order_items = OrderItem.all
      end

      def get_pending_order_items
        pending_orders = OrderItem.joins(:order).where(status: %w[pending confirmed on_the_way],
                                                       orders: { user_id: @user.id, Payment_Status: 1 })
        orders_get_response(pending_orders)
      end

      def changer_order_status
        if params[:order_id].present? && params[:status].present?
          OrderItem.find_by_id(params[:order_id]).update(status: params[:status])

          render json: {
              Message: "Order Item updated.",
              status: :updated
          }
        else
          render json: {
              Message: "Invalid Request.",
              status: :unprocessable_entity
          }
        end
      end

      def get_completed_order_items
        completed_orders = OrderItem.joins(:order).where(status: %w[delivered delivered_by_card delivered_by_cash
                                                                    delivered_online cancelled],
                                                         orders: { user_id: @user.id })
        orders_get_response(completed_orders)
      end

      def get_recurring_order_items
        recurring_orders = OrderItem.joins(:order).where(IsRecurring: true, orders: {user_id: @user.id})
        orders_get_response(recurring_orders)
      end

      def gen_api_end_points
        render json: {
            PrivacyPolicy: "https://www.urpetslife.com/app_pets_life_privacy_policy",
            TermsAndConditions:  "https://www.urpetslife.com/app_term_conditions",
            RefundPolicy: "https://www.urpetslife.com/app_cancelation_policy",
            RedeemPoints: "https://www.urpetslife.com/app_loyalty_program",
        }
      end

      def app_base_end_point
        render json: {
            BaseUrl: ENV["API_BASE_PATH"]
        }
      end

      def get_vat_percentage
        render json: {
            Vat: "5"
        }
      end

      def order_item_reorder
        return render json: { Message: "Invalid Request. Parameter(s) not found.",
                              status: :unprocessable_entity } if params[:id].blank?

        existing_item = OrderItem.find_by_id(params[:id])

        return render json: { Message: "Invalid Request. Order Item not found",
                              status: :unprocessable_entity } if existing_item.blank?

        existing_order = OrderItem.order
        item = Item.find_by_id(existing_item.item_id)

        if existing_order.present? && item.present?
          return render json: { Message: "Limited or Out of Stock", RequestedQuantity: existing_item.Quantity,
                                AvailableQuantity: item.quantity, status: :out_of_stock
          } if item.quantity < existing_item.Quantity

          permitted_quantity = existing_item.Quantity
          sub_total = item.price * permitted_quantity
          delivery_charges = sub_total > 100 ? 0 : 20
          vat_charges = (sub_total/100) * 5
          total = sub_total + delivery_charges + vat_charges
          payment_status = existing_order.IsCash ? 0 : 1

          new_order = Order.new(user_id: @user.id, RedeemPoints: 0, Subtotal: sub_total,
                                Delivery_Charges: delivery_charges, shipmenttime: 'with in 7 days',
                                Vat_Charges: vat_charges, Total: total, Order_Status: 1,
                                Payment_Status: payment_status, Order_Notes: existing_order.Order_Notes,
                                IsCash: existing_order.IsCash, location_id: existing_order.location_id,
                                is_viewed: false, order_status_flag: 'pending')

          if new_order.save
            OrderItem.create(IsRecurring: false, order_id: new_order.id, item_id: item.id, Quantity: permitted_quantity,
                             Unit_Price: item.price, Total_Price: sub_total, IsReviewed: false, status: :pending,
                             isdiscounted: (item.discount > 0 ? true : false), next_recurring_due_date: DateTime.now)

            user_redeem_point_record = RedeemPoint.find_by_user_id(@user.id)
            @discount_per_transaction = 0
            calculating_discount(sub_total)
            net_worth = user_redeem_point_record.net_worth

            user_redeem_point_record.update(net_worth: (net_worth +  @discount_per_transaction),
                                            last_net_worth: net_worth,
                                            last_reward_type: "Discount Per Transaction (Re-Order)",
                                            last_reward_worth: @discount_per_transaction,
                                            last_reward_update: Time.now,
                                            totalearnedpoints: (user_redeem_point_record.totalearnedpoints + @discount_per_transaction))
            item.decrement!(:quantity, permitted_quantity)

            send_inventory_alerts(item.id) if item.quantity < 3

            new_order.update(earned_points: @discount_per_transaction)
            set_order_notification_email(new_order.id)
            @user.notifications.create(order: new_order, message: 'Your Order has been placed successfully')

            render json: {
                Message: "New Order Placed successfully",
                status: :created
            }
          else
            render json: {
                Message: "Error adding Order",
                status: :error
            }
          end
        else
          render json: {
              Message: "Order/Item not found",
              status: :unprocessable_entity
          }
        end
      end

      def order_item_cancel_order
        return render json: { Message: "Invalid request. Parameter(s) missing",
                              status: :Invalid
        } if params[:id].blank?

        order_item = OrderItem.find_by_id(params[:id])
        if order_item.present?
          order = Order.find_by_id(order_item.order_id)

          order_item.update_attributes(status: :cancelled)
          order_amount_remaining = order.Subtotal - order_item.Total_Price
          redeem_points_consumed = order.RedeemPoints

          if order_amount_remaining < redeem_points_consumed
            points_to_be_reverted = redeem_points_consumed - order_amount_remaining
          else
            points_to_be_reverted = 0
          end

          update_order_to_cancel = true
          discounted_products_price = 0

          order_item.order.order_items.each do |order_item|
            if order_item.status != 'cancelled'
              discounted_products_price += order_item.Total_Price if order_item.isdiscounted
              update_order_to_cancel = false
            end
          end

          if update_order_to_cancel
            order.update(Subtotal: 0, Delivery_Charges: 0, Vat_Charges: 0, Total: 0, order_status_flag: 'cancelled',
                         earned_points: 0, RedeemPoints: 0)
          else
            sub_total = (order.Subtotal - order_item.Total_Price).round(2)
            delivery_charges = sub_total > 100 ? 0 : 20
            vat_charges = ((sub_total/100) * 5).round(2)
            total = sub_total + delivery_charges + vat_charges
            @discount_per_transaction = 0

            if order_item.isdiscounted
              @discount_per_transaction = order.earned_points
            else
              order_price_for_award = sub_total - (order.RedeemPoints - points_to_be_reverted) - discounted_products_price
              calculating_discount(order_price_for_award)
              @discount_per_transaction.to_f.ceil
            end

            order.update(Subtotal: sub_total, Delivery_Charges: delivery_charges, Vat_Charges: vat_charges,
                         Total: total, RedeemPoints: order.RedeemPoints - points_to_be_reverted,
                         earned_points: @discount_per_transaction)
          end

          user_redeem_point_record = RedeemPoint.find_by_user_id(user.id)
          user_points = user_redeem_point_record.net_worth

          user_redeem_point_record.update(net_worth: user_points + points_to_be_reverted, last_net_worth: user_points,
                                          last_reward_type: "Discount Per Transaction (Order Cancel Roll Back)",
                                          last_reward_worth: points_to_be_reverted, last_reward_update: Time.now,
                                          totalavailedpoints: user_redeem_point_record.totalavailedpoints - points_to_be_reverted)

          item = order_item.item
          item.increment!(:quantity, order_item.Quantity) if item.present?

          if update_order_to_cancel
            user.notifications.create(order: order, message: 'Your Order # ' + order.id.to_s + ' has been cancelled')
            OrderMailer.send_complete_cancel_order_email_to_customer(order.id, order.user.email).deliver
          else
            user.notifications.create(order: order, message: 'Your Order for ' + item.name + ' has been cancelled')
            send_order_cancellation_email(order_item .id)
          end

          render json: {
              Message: "Order/Item Cancelled successfully",
              status: :deleted
          }
        else
          render json: {
              Message: "Order Item not found.",
              status: :unprocessable_entity
          }
        end
      end

      def order_item_cancel_recurring
        return render json: {
            Message: "Invalid Request. Parameter(s) not found.",
            status: :invalid_request
        } if params[:id].blank?

        order_item = OrderItem.find_by_id(params[:id])

        return render json: {
            Message: "Order Item not found.",
            status: :unprocessable_entity
        } if order_item.blank?

        order_item.update(IsRecurring: false)

        render json: {
            Message: "Item removed from recurring order(s) successfully.",
            status: :deleted
        }
      end

      def show
      end

      def new
        @order_item = OrderItem.new
      end

      def edit
      end

      def create
        @order_item = OrderItem.new(order_item_params)

        respond_to do |format|
          if @order_item.save
            format.html { redirect_to @order_item, notice: 'Order item was successfully created.' }
            format.json { render :show, status: :created, location: @order_item }
          else
            format.html { render :new }
            format.json { render json: @order_item.errors, status: :unprocessable_entity }
          end
        end
      end

      def update
        respond_to do |format|
          if @order_item.update(order_item_params)
            format.html { redirect_to @order_item, notice: 'Order item was successfully updated.' }
            format.json { render :show, status: :ok, location: @order_item }
          else
            format.html { render :edit }
            format.json { render json: @order_item.errors, status: :unprocessable_entity }
          end
        end
      end

      def destroy
        @order_item.destroy
        respond_to do |format|
          format.html { redirect_to order_items_url, notice: 'Order item was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      private

      def calculating_discount(price)
        if price <= 500
          @discount_per_transaction =+ (3*price)/100
        elsif price > 500 && price <= 1000
          @discount_per_transaction =+ (5*price)/100
        elsif price > 1000 && price <= 2000
          @discount_per_transaction =+ (7.5*price)/100
        elsif price > 2000
          @discount_per_transaction =+ (10*price)/100
        end
      end

      def orders_get_response(orders)
        if orders.count > 0
          render json: orders.order(created_at: :desc).as_json(
              :only => [:id, :status, :Quantity, :IsRecurring, :IsReviewed, :Unit_Price, :Total_Price],
              :include => {
                  :item => {
                      :only => [:id, :picture, :name, :price, :discount, :description, :weight, :unit, :short_description]
                  },
                  :recurssion_interval =>  {
                      :only => [:id, :days, :weeks, :label]
                  },
                  :order => {
                      :only => [:id, :IsCash]
                  },
                  :item_reviews => {
                      :only => [:id, :user_id, :item_id, :rating, :comment]
                  }
              }
          )
        else
          render json: {
              Message: "No item(s) found."
          }
        end
      end

      def set_order_item
        @order_item = OrderItem.find_by_id(params[:id])
      end

      def send_inventory_alerts(item_id)
        OrderMailer.send_low_inventory_alert(item_id).deliver
      end

      def send_order_cancellation_email(order_item_id)
        OrderMailer.send_order_cancellation_notification_to_customer(order_item_id).deliver
        OrderMailer.send_order_cancellation_notification_to_admin(order_item_id).deliver
      end

      def set_order_notification_email(order_id)
        OrderMailer.send_order_notification_email_to_admin(order_id).deliver
        OrderMailer.send_order_placement_notification_to_customer(@user.email, order_id).deliver
      end

      def order_item_params
        params.require(:order_item).permit(:order_id, :item_id, :Quantity, :Unit_Price, :Total_Price)
      end
    end
  end
end

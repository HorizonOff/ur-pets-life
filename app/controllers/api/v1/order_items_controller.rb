module Api
  module V1
class OrderItemsController < Api::BaseController
  before_action :set_order_item, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user, only: :app_base_end_point
  # GET /order_items
  # GET /order_items.json
  def index
    @order_items = OrderItem.all
  end
  def get_pending_order_items
    pending_orders = OrderItem.includes(:order).where(order_items: {status: [:pending, :confirmed, :on_the_way]}, orders: {user_id: @user.id})
    if pending_orders.count > 0
    render json: pending_orders.order(created_at: :desc).as_json(
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
        }
      }
    )
  else
    render json: {
      Message: "No item(s) found."
    }
  end
  end

  def changer_order_status
    if (!params[:order_id].nil? and !params[:status].nil?)
      OrderItem.where(:id => params[:order_id]).first.update(:status => params[:status])
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
    completed_orders = OrderItem.includes(:order).where(order_items: {status: [:delivered, :cancelled]}, orders: {user_id: @user.id})
    if completed_orders.count > 0
    render json: completed_orders.order(created_at: :desc).as_json(
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

  def get_recurring_order_items
    recurring_orders = OrderItem.includes(:order).where(order_items: {IsRecurring: true}, orders: {user_id: @user.id})
    if recurring_orders.count > 0
    render json: recurring_orders.order(created_at: :desc).as_json(
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
        }
      }
    )
  else
    render json: {
      Message: "No item(s) found."
    }
  end
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
      if !params[:id].nil?
        existingitem = OrderItem.where(:id => params[:id]).first
        if existingitem.nil?
          render json: {
            Message: "Invalid Request. Order Item not found",
            status: :unprocessable_entity
          }
        else
        existingorder = Order.where(:id => existingitem.order_id).first
        item = Item.where(:id => existingitem.item_id).first
        if (!existingorder.nil? and !item.nil?)
          permitted_quantity = 0
          if (item.quantity < existingitem.Quantity)
            render json: {
              Message: "Limited or Out of Stock",
              RequestedQuantity: existingitem.Quantity,
              AvailableQuantity: item.quantity,
              status: :out_of_stock
            }
          else
          permitted_quantity = existingitem.Quantity
          subTotal = (item.price * permitted_quantity)
          deliveryCharges = (subTotal > 100 ? 0 : 20)
          vatCharges = (subTotal/100).to_f * 5
          total = subTotal + deliveryCharges + vatCharges
          paymentStatus = existingorder.IsCash == true ? 0 : 1
          #if existingorder.IsCash == false
          #  ispaymentconfirm = Api::V1::OrderServices::OnlinePaymentService.send_payment_request('sale', 'cont', @user.last_transaction_ref, existingitem.item.description, existingorder.id, total)
          #end
          # TransactionId and TransactionDate to be inserted while Telr integration
          neworder = Order.new(:user_id => @user.id, :RedeemPoints => 0, :Subtotal => subTotal, :Delivery_Charges => deliveryCharges, :shipmenttime => 'with in 7 days', :Vat_Charges => vatCharges, :Total => total, :Order_Status => 1, :Payment_Status => paymentStatus, :Order_Notes => existingorder.Order_Notes, :IsCash => existingorder.IsCash,  :location_id => existingorder.location_id, :is_viewed => false, :order_status_flag => 'pending')
          if neworder.save
            newitem = OrderItem.new(:IsRecurring => false, :order_id => neworder.id, :item_id => item.id, :Quantity => permitted_quantity, :Unit_Price => item.price, :Total_Price => subTotal, :IsReviewed => false, :status => :pending, :isdiscounted => (item.discount > 0 ? true : false), :next_recurring_due_date => DateTime.now).save

            user_redeem_point_record = RedeemPoint.where(:user_id => @user.id).first
            discount_per_transaction = 0
            if subTotal <= 500
              discount_per_transaction =+ (3*subTotal)/100
            elsif subTotal > 500 and subTotal <= 1000
              discount_per_transaction =+ (5*subTotal)/100
            elsif subTotal > 1000 and subTotal <= 2000
              discount_per_transaction =+ (7.5*subTotal)/100
            elsif subTotal > 2000
              discount_per_transaction =+ (10*subTotal)/100
            end

            user_redeem_point_record.update(:net_worth => (user_redeem_point_record.net_worth +  discount_per_transaction), :last_net_worth => user_redeem_point_record.net_worth, :last_reward_type => "Discount Per Transaction (Re-Order)", :last_reward_worth => discount_per_transaction, :last_reward_update => Time.now, :totalearnedpoints => (user_redeem_point_record.totalearnedpoints + discount_per_transaction))
            item.decrement!(:quantity, permitted_quantity)
            if item.quantity < 3
              send_inventory_alerts(item.id)
            end
            neworder.update(:earned_points => discount_per_transaction)
            set_order_notifcation_email(neworder.id)
            @user.notifications.create(order: neworder, message: 'Your Order has been placed successfully')
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
        end
        else
          render json: {
            Message: "Order/Item not found",
            status: :unprocessable_entity
          }
        end
        end
      else
        render json: {
          Message: "Invalid Request. Parameter(s) not found.",
          status: :unprocessable_entity
        }
      end
  end

  def order_item_cancel_order
      if !params[:id].nil?
        orderitem = OrderItem.where(:id => params[:id]).first
        if !orderitem.nil?
          order = Order.where(:id => orderitem.order_id).first
          if !order.nil?
            orderitem.update_attributes(status: :cancelled)
            order_amount_cancelled = orderitem.Total_Price
            redeem_points_consumed = order.RedeemPoints

            points_to_be_reverted = 0
            if order_amount_cancelled > redeem_points_consumed
              points_to_be_reverted = redeem_points_consumed
            elsif order_amount_cancelled < redeem_points_consumed
               points_to_be_reverted = order_amount_cancelled
            end

            updateordertocancel = true
            allorderitems = OrderItem.where(:order_id => orderitem.order_id)
            allorderitems.each do |items|
              if items.status != 'cancelled'
                updateordertocancel = false
              end
            end

            if updateordertocancel == true
              order.update(:Subtotal => 0, :Delivery_Charges => 0, :Vat_Charges => 0, :Total => 0, :order_status_flag => 'cancelled', :earned_points => 0, :RedeemPoints => 0)
            else
              subTotal = order.Subtotal - orderitem.Total_Price
              deliveryCharges = subTotal > 100 ? 0 : 20
              vatCharges = (subTotal/100).to_f * 5
              total = subTotal + deliveryCharges + vatCharges
              order.update(:Subtotal => subTotal, :Delivery_Charges => deliveryCharges, :Vat_Charges => vatCharges, :Total => total, :RedeemPoints => order.RedeemPoints - points_to_be_reverted)
            end

            user_redeem_point_record = RedeemPoint.where(:user_id => @user.id).first
            userpoints = user_redeem_point_record.net_worth
            discount_per_transaction = 0

            if orderitem.isdiscounted == false
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
            end

            points_to_be_deducted_on_cancel = 0
            if (userpoints > 0 and userpoints < discount_per_transaction)
              points_to_be_deducted_on_cancel = userpoints
            elsif userpoints >= discount_per_transaction
              points_to_be_deducted_on_cancel = discount_per_transaction
            end
            deduct_from_earned_points_to = 0
            if user_redeem_point_record.totalearnedpoints > 0
               if user_redeem_point_record.totalearnedpoints >= points_to_be_deducted_on_cancel
                 deduct_from_earned_points_to = points_to_be_deducted_on_cancel
               else
                 deduct_from_earned_points_to = user_redeem_point_record.totalearnedpoints
               end
            end
            user_redeem_point_record.update(:net_worth => (userpoints -  points_to_be_deducted_on_cancel) + points_to_be_reverted, :last_net_worth => userpoints, :last_reward_type => "Discount Per Transaction (Order Cancel Roll Back)", :last_reward_worth => discount_per_transaction, :last_reward_update => Time.now, :totalearnedpoints => (user_redeem_point_record.totalearnedpoints - deduct_from_earned_points_to))
            item = Item.where(:id => orderitem.item_id).first
            if !item.nil?
              item.increment!(:quantity, orderitem.Quantity)
            end

            if updateordertocancel != true
              order.update(:earned_points => (order.earned_points - points_to_be_deducted_on_cancel))
              @user.notifications.create(order: order, message: 'Your Order for ' + item.name + ' has been cancelled')
              send_order_cancellation_email(orderitem.id)
            else
              @user.notifications.create(order: order, message: 'Your Order # ' + order.id.to_s + ' has been cancelled')
              OrderMailer.send_complete_cancel_order_email_to_customer(order.id, order.user.email).deliver
            end

            #if !OrderItem.where(:order_id => order.id).exists?
            #  order.destroy
            #end
            render json: {
              Message: "Order/Item Cancelled successfully",
              status: :deleted
            }
          else
            render json: {
              Message: "Order not found.",
              status: :unprocessable_entity
            }
          end
        else
          render json: {
            Message: "Order Item not found.",
            status: :unprocessable_entity
          }
        end
      else
        rende json: {
          Message: "Invalid request. Parameter(s) missing",
          status: :Invalid
        }
      end
  end

  def order_item_cancel_recurring
    if !params[:id].nil?
      orderitem = OrderItem.where(:id => params[:id]).first
      if !orderitem.nil?
        orderitem.update(:IsRecurring => false)
        render json: {
          Message: "Item removed from recurring order(s) successfully.",
          status: :deleted
        }
      else
        render json: {
          Message: "Order Item not found.",
          status: :unprocessable_entity
        }
      end
    else
      render json: {
        Message: "Invalid Request. Parameter(s) not found.",
        status: :invalid_request
      }
    end
  end
  # GET /order_items/1
  # GET /order_items/1.json
  def show
  end

  # GET /order_items/new
  def new
    @order_item = OrderItem.new
  end

  # GET /order_items/1/edit
  def edit
  end

  # POST /order_items
  # POST /order_items.json
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

  # PATCH/PUT /order_items/1
  # PATCH/PUT /order_items/1.json
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

  # DELETE /order_items/1
  # DELETE /order_items/1.json
  def destroy
    @order_item.destroy
    respond_to do |format|
      format.html { redirect_to order_items_url, notice: 'Order item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_item
      @order_item = OrderItem.find(params[:id])
    end

    def send_inventory_alerts(itemid)
      OrderMailer.send_low_inventory_alert(itemid).deliver
    end

    def send_order_cancellation_email(orderitemid)
      OrderMailer.send_order_cancellation_notification_to_customer(orderitemid).deliver
      OrderMailer.send_order_cancellation_notification_to_admin(orderitemid).deliver
    end

    def set_order_notifcation_email(orderid)
      OrderMailer.send_order_notification_email_to_admin(orderid).deliver
      OrderMailer.send_order_placement_notification_to_customer(@user.email).deliver
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_item_params
      params.require(:order_item).permit(:order_id, :item_id, :Quantity, :Unit_Price, :Total_Price)
    end
end
end
end

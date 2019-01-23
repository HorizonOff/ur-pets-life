
module Api
  module V1
    class OrdersController < Api::BaseController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = @user.orders
    if @orders.nil? or @orders.empty?
      render :json => {
        Message: 'No Orders found'
      }
    else
      if (!params[:pageno].nil? and !params[:size].nil?)
        size = params[:size].to_i
        page = params[:pageno].to_i
        @orders = @orders.limit(size).offset(page * size)
      end
    render json: @orders.as_json(
      :only => [:id, :Subtotal, :shipmenttime, :Delivery_Charges, :Vat_Charges, :Total, :Delivery_Date, :Order_Notes, :IsCash, :RedeemPoints, :earned_points],
      :include => {
        :location => {
          :only => [:id, :latitude, :longitude, :city, :area, :street, :building_name, :unit_number, :villa_number]
        },
        :order_items => {
          :only => [:id, :Quantity, :IsRecurring, :IsReviewed, :status],
          :include => {
            :item => {
              :only => [:id, :picture, :name, :price, :discount, :description, :weight, :unit, :short_description]
            },
            :recurssion_interval =>  {
              :only => [:id, :days, :weeks, :label]
            },
            :item_reviews => {
              :only => [:id, :user_id, :item_id, :rating, :comment]
            }
          }
        }
      }
    )
  end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    render json: @order.as_json(
    :only => [:id, :Subtotal, :shipmenttime, :Delivery_Charges, :Vat_Charges, :Total, :Delivery_Date, :Order_Notes, :IsCash, :RedeemPoints, :earned_points],
    :include => {
      :location => {
        :only => [:id, :latitude, :longitude, :city, :area, :street, :building_name, :unit_number, :villa_number]
      },
      :order_items => {
        :only => [:id, :Quantity, :IsRecurring, :IsReviewed, :status],
        :include => {
          :item => {
            :only => [:id, :picture, :name, :price, :discount, :description, :weight, :unit, :short_description]
          },
          :recurssion_interval =>  {
            :only => [:id, :days, :weeks, :label]
          },
          :item_reviews => {
            :only => [:id, :user_id, :item_id, :rating, :comment]
          }
        }
      }
    }
  )
  #  render json: {
  #    VatPercentage: "5",
  #    OrderDetails:
  #}
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  def re_oder_on_order_id
    respond_to do |format|
    if Order.where(:id => params[:id]).exists?
      @order = Order.where(:id => params[:id]).first
      @neworder = Order.new(:user_id => @user.id, :RedeemPoints => 0, :TransactionId => params[:TransactionId], :TransactionDate => params[:TransactionDate], :shipmenttime => @order.shipmenttime, :Subtotal => @order.Subtotal, :Delivery_Charges => @order.Delivery_Charges, :Vat_Charges => @order.Vat_Charges, :Total => @order.Total, :Order_Status => 1, :Payment_Status => 1, :Delivery_Date => @order.Delivery_Date, :Order_Notes => @order.Order_Notes, :IsCash => params[:IsCash],  :location_id => @order.location_id)
      if @neworder.save
        discount_per_transaction = 0
        subTotal = @order.Subtotal
        user_redeem_points = RedeemPoint.where(:user_id => @user.id).first.net_worth
        if subTotal <= 500
          discount_per_transaction =+ (3*subTotal)/100
        elsif subTotal > 500 and subTotal <= 1000
          discount_per_transaction =+ (5*subTotal)/100
        elsif subTotal > 1000 and subTotal <= 2000
          discount_per_transaction =+ (7.5*subTotal)/100
        elsif subTotal > 2000
          discount_per_transaction =+ (10*subTotal)/100
        end
        RedeemPoint.where(:user_id => @user.id).update(:net_worth => (user_redeem_points +  discount_per_transaction), :last_net_worth => user_redeem_points, :last_reward_type => "Discount Per Transaction", :last_reward_worth => discount_per_transaction, :last_reward_update => Time.now)
        @order.order_items.each do |orderitem|
          @neworderitem = OrderItem.new(:IsRecurring => false, :order_id => @neworder.id, :item_id => orderitem.item_id, :Quantity => orderitem.Quantity, :Unit_Price => orderitem.Unit_Price, :Total_Price => orderitem.Total_Price, :IsReviewed => false, :status => :pending)
          @neworderitem.save
          #if !orderitem.recurssion_interval_id.nil?
          #  @neworderitem.update(:recurssion_interval_id => orderitem.recurssion_interval_id)
          #end
        end
          format.json do
            render json: {
              Message: 'New Order placed successfully',
              status: :created,
              OrderDetails: @neworder.as_json(
                :only => [:id, :Subtotal, :Delivery_Charges, :Vat_Charges, :Total, :Delivery_Date, :Order_Notes, :IsCash, :shipmenttime],
                :include => {
                  :location => {
                    :only => [:id, :latitude, :longitude, :city, :area, :street, :building_name, :unit_number, :villa_number]
                  },
                  :order_items => {
                    :only => [:id, :Quantity, :IsRecurring, :IsReviewed],
                    :include => {
                      :item => {
                        :only => [:id, :picture, :name, :price, :discount, :description, :weight, :unit]
                      },
                      :recurssion_interval =>  {
                        :only => [:id, :days, :weeks, :label]
                      },
                      :item_reviews => {
                        :only => [:id, :user_id, :item_id, :rating, :comment]
                      }
                    }
                  }
                }
              )
            }
          end
      else
        format.json do
          render json: {
            Message: 'Error placing new order.',
            status: :unprocessable_entity,
            errors: @neworder.errors
          }
        end
      end
    else
      format.json do
        render json: {
          Message: 'Invalid Request. Order not found.',
          status: :unprocessable_entity
        }
      end
    end
  end
end
  # POST /orders
  # POST /orders.json
  def create
    respond_to do |format|
    @usercartitems = @user.shopping_cart_items
    if @usercartitems.nil? or @usercartitems.empty?
      format.json do
        render json: {
          Message: 'Cart Empty',
          status: :unprocessable_entity
        }
      end
    elsif (params[:IsCash] == "false" and (params[:TransactionId].blank? or params[:TransactionDate].blank?))
      format.json do
        render json: {
          Message: 'Invalid or empty Transaction reference',
          status: :unprocessable_entity
        }
      end
    else
      isoutofstock = false
      @itemsprice = 0
      @discounted_items_amount = 0
      @usercartitems.each do |cartitem|
        @itemsprice += (cartitem.item.price * cartitem.quantity)
        if cartitem.item.discount > 0
          @discounted_items_amount += (cartitem.item.price * cartitem.quantity)
        end
        if cartitem.item.quantity < cartitem.quantity
          isoutofstock = true
        end
      end
      if isoutofstock == true
        format.json do
          render json: {
            Message: 'Out of Stock',
            status: :out_of_stock
          }
        end
      else
        subTotal = @itemsprice.to_f.round(2)
        deliveryCharges = (subTotal > 100 ? 0 : 20)
        vatCharges = ((@itemsprice/100).to_f * 5).round(2)
        total = subTotal + deliveryCharges + vatCharges
        user_redeem_points = 0
        requested_redeem_points = params[:RedeemPoints].to_i
        permitted_redeem_points = 0
        paymentStatus = 0

        if RedeemPoint.where(:user_id => @user.id).exists?
          @user_redeem_point_record = RedeemPoint.where(:user_id => @user.id).first
        else
          @user_redeem_point_record = RedeemPoint.new(:user_id => @user.id, :net_worth => 0, :last_net_worth => 0, :totalearnedpoints => 0, :totalavailedpoints => 0)
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

        if params[:IsCash] == "false"
          @user.update_attributes(last_transaction_ref: params[:TransactionId], last_transaction_date: params[:TransactionDate])
          paymentStatus = 1
        end

        if permitted_redeem_points > 0
          deliveryCharges = (subTotal - permitted_redeem_points) > 100 ? 0 : 20
          total = subTotal + deliveryCharges + vatCharges
        end 
        @order = Order.new(:user_id => @user.id, :RedeemPoints => permitted_redeem_points, :TransactionId => params[:TransactionId], :TransactionDate => params[:TransactionDate], :Subtotal => subTotal, :Delivery_Charges => deliveryCharges, :shipmenttime => 'with in 7 days', :Vat_Charges => vatCharges, :Total => total, :Order_Status => 1, :Payment_Status => paymentStatus, :Delivery_Date => params[:Delivery_Date], :Order_Notes => params[:Order_Notes], :IsCash => params[:IsCash],  :location_id => params[:location_id], :is_viewed => false, :order_status_flag => 'pending')
        if @order.save

          if permitted_redeem_points > 0
            @user_redeem_point_record.update(:net_worth => (user_redeem_points - permitted_redeem_points), :last_net_worth => user_redeem_points, :last_reward_type => "Order Deduction", :last_reward_worth => permitted_redeem_points, :last_reward_update => Time.now, :totalavailedpoints => (@user_redeem_point_record.totalavailedpoints + permitted_redeem_points))
          end

          discount_per_transaction = 0
          amount_to_be_awarded = subTotal - permitted_redeem_points - @discounted_items_amount
          if amount_to_be_awarded > 0
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
          #@user_redeem_point_record.update(:net_worth => (user_redeem_points - permitted_redeem_points +  discount_per_transaction), :last_net_worth => (user_redeem_points - permitted_redeem_points), :last_reward_type => "Discount Per Transaction", :last_reward_worth => discount_per_transaction, :last_reward_update => Time.now, :totalearnedpoints => (@user_redeem_point_record.totalearnedpoints + discount_per_transaction))
          @order.update(:earned_points => discount_per_transaction)
          @usercartitems.each do |cartitem|
          @neworderitemcreate = OrderItem.new(:IsRecurring => cartitem.IsRecurring, :order_id => @order.id, :item_id => cartitem.item_id, :Quantity => cartitem.quantity, :Unit_Price => cartitem.item.price, :Total_Price => (cartitem.item.price * cartitem.quantity), :IsReviewed => false, :status => :pending, :isdiscounted => (cartitem.item.discount > 0 ? true : false), :next_recurring_due_date => DateTime.now)
          @neworderitemcreate.save
          item = Item.where(:id => cartitem.item_id).first
          item.decrement!(:quantity, cartitem.quantity)
          if item.quantity < 3
            send_inventory_alerts(item.id)
          end
          if !cartitem.recurssion_interval_id.nil?
            recurrion_interval = RecurssionInterval.where(:id => cartitem.recurssion_interval_id).first
            next_due_date = DateTime.now.to_date
            next_due_date = next_due_date.to_time + (recurrion_interval.days).days
            @neworderitemcreate.update_attributes(:next_recurring_due_date => next_due_date.to_date, :recurssion_interval_id => cartitem.recurssion_interval_id)
          end
          end
          @user.shopping_cart_items.destroy_all
          set_order_notifcation_email(@order.id)
          @user.notifications.create(order: @order, message: 'Your Order has been placed successfully')
          format.json do
            render json: {
              Message: 'Order was successfully created.',
              status: :created,
              VatPercentage: "5",
              #EarnedPoints: discount_per_transaction,
              OrderDetails: @order.as_json(
                :only => [:id, :Subtotal, :Delivery_Charges, :Vat_Charges, :Total, :Delivery_Date, :Order_Notes, :IsCash, :shipmenttime, :RedeemPoints, :earned_points],
                :include => {
                  :location => {
                    :only => [:id, :latitude, :longitude, :city, :area, :street, :building_name, :unit_number, :villa_number]
                  },
                  :order_items => {
                    :only => [:id, :Quantity, :IsRecurring, :IsReviewed, :status],
                    :include => {
                      :item => {
                        :only => [:id, :picture, :name, :price, :discount, :description, :weight, :unit, :quantity, :short_description]
                      },
                      :recurssion_interval =>  {
                        :only => [:id, :days, :weeks, :label]
                      },
                      :item_reviews => {
                        :only => [:id, :user_id, :item_id, :rating, :comment]
                      }
                    }
                  }
                }
              )
            }
            end
        else
          format.json do
            render json: {
              Message: 'Error creating order',
              status: :unprocessable_entity,
              errors: @order.errors
            }
          end
        end
      end
    end
  end
end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      format.json do
        render json: {
        Message: 'Order update not allowed',
        status: :unprocessable_entity
      }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
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

  def test_email
    begin
      set_order_notifcation_email
      render json: {
        Messgae: :sent
      }
    rescue => ex
      render json: {
        :Messgae => ex.message
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find_by_id(params[:id])
      return render_404 unless @order
    end

    def send_inventory_alerts(itemid)
      OrderMailer.send_low_inventory_alert(itemid).deliver
    end

    def set_order_notifcation_email(orderid)
      OrderMailer.send_order_notification_email_to_admin(orderid).deliver
      OrderMailer.send_order_placement_notification_to_customer(@user.email).deliver
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:Delivery_Date, :Order_Notes, :IsCash,  :location_id, :RedeemPoints)
    end
end
end
end

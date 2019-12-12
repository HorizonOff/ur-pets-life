module Api
  module V1
    class OrdersController < Api::BaseController
      include AdminPanel::OrderUpdateHelper
      before_action :set_order, only: [:show, :edit, :update, :destroy]
      before_action :set_usercartitems, only: [:create]
      # before_action :check_empty_transactions, only: [:create]

      # GET /orders
      # GET /orders.json
      def index
        @orders = @user.orders.visible
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
            :only => [:id, :Subtotal, :shipmenttime, :Delivery_Charges, :Vat_Charges, :Total, :Delivery_Date, :Order_Notes, :IsCash, :RedeemPoints, :earned_points, :driver_id],
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

      # GET /orders/1
      # GET /orders/1.json
      def show
        render json: @order.as_json(
        :only => [:id, :Subtotal, :shipmenttime, :Delivery_Charges, :Vat_Charges, :Total, :Delivery_Date, :Order_Notes, :IsCash, :RedeemPoints, :earned_points, :order_status_flag],
        :include => {
          :location => {
            :only => [:id, :latitude, :longitude, :city, :area, :street, :building_name, :unit_number, :villa_number]
          },
          :user => {
            :only => [:id, :first_name, :last_name, :mobile_number]
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
          },
          driver: {
            only: [:id, :name]
          }
        }
      )
      #  render json: {
      #    VatPercentage: "5",
      #    OrderDetails:
      #}
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

      def create
        isoutofstock = false
        @itemsprice = 0
        @total_price_without_discount = 0
        @discounted_items_amount = 0
        discount = ::Api::V1::DiscountDomainService.new(@user.email.dup).dicount_on_email
        @is_user_from_company = discount.positive?
        @usercartitems.each do |cartitem|
          if discount.positive? && cartitem.item.discount.zero? &&
            !(@user.member_type.in?(['silver', 'gold']) && cartitem.item.supplier.in?(["MARS", "NESTLE"])) &&
            @user.email != 'development@urpetslife.com'
            @itemsprice += cartitem.item.price * ((100 - discount).to_f / 100) * cartitem.quantity
          else
            @itemsprice += (cartitem.item.price * cartitem.quantity)
          end
          @total_price_without_discount += (cartitem.item.price * cartitem.quantity)
          if cartitem.item.discount > 0
            @discounted_items_amount += (cartitem.item.price * cartitem.quantity)
          end
          isoutofstock = true if cartitem.item.quantity < cartitem.quantity
        end
        return render json: { Message: 'Out of Stock', status: :out_of_stock } if isoutofstock == true

        subTotal = @itemsprice.to_f.round(2)
        if @user.email != 'development@urpetslife.com'
          deliveryCharges = (subTotal < 100 ? 20 : 0)
        else
          deliveryCharges = 7
        end
        company_discount = (@total_price_without_discount - @itemsprice).round(2)
        code_discount = ::Api::V1::DiscountCodeService.new(params[:pay_code], @user, subTotal).discount_from_code
        vatCharges = ((@total_price_without_discount/100).to_f * 5).round(2)
        total = subTotal + deliveryCharges + vatCharges + code_discount - company_discount
        user_redeem_points = 0
        requested_redeem_points = params[:RedeemPoints].to_i
        permitted_redeem_points = 0
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

        # if permitted_redeem_points > 0
        #   deliveryCharges = (subTotal - permitted_redeem_points) > 100 ? 0 : 20
        #   total = subTotal + deliveryCharges + vatCharges
        # end

        @order = Order.new(user_id: @user.id, RedeemPoints: permitted_redeem_points,
                           TransactionId: params[:TransactionId],
                           TransactionDate: params[:TransactionDate], Subtotal: @total_price_without_discount,
                           Delivery_Charges: deliveryCharges, shipmenttime: 'with in 7 days', Vat_Charges: vatCharges,
                           Total: total, Order_Status: 1, Delivery_Date: params[:Delivery_Date],
                           Order_Notes: params[:Order_Notes], IsCash: params[:IsCash],
                           location_id: params[:location_id], is_viewed: false,
                           order_status_flag: 'pending', code_discount: code_discount,
                           company_discount: company_discount, is_user_from_company: @is_user_from_company)
        if @order.save
          if @order.code_discount != 0
            pay_code_owner = User.find_by(pay_code: params[:pay_code])
            UsedPayCode.create(user_id: pay_code_owner.id, order_id: @order.id, code_user_id: @user.id)
          end

          if permitted_redeem_points > 0
            @user_redeem_point_record.update(net_worth: (user_redeem_points - permitted_redeem_points),
                                             last_net_worth: user_redeem_points, last_reward_type: 'Order Deduction',
                                             last_reward_worth: permitted_redeem_points, last_reward_update: Time.now,
                                             totalavailedpoints: (@user_redeem_point_record.totalavailedpoints
                                                                  + permitted_redeem_points))
          end
          discount_per_transaction = 0
          amount_to_be_awarded = subTotal - permitted_redeem_points - @discounted_items_amount
          if amount_to_be_awarded > 0 && (discount.blank? || discount.zero?) && @user.email != 'development@urpetslife.com'
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
          @order.update(earned_points: discount_per_transaction)
          is_any_recurring_item = false
          @usercartitems.each do |cartitem|
            @neworderitemcreate = OrderItem.new(IsRecurring: cartitem.IsRecurring, order_id: @order.id,
                                                item_id: cartitem.item_id, Quantity: cartitem.quantity,
                                                Unit_Price: cartitem.item.price,
                                                Total_Price: (cartitem.item.price * cartitem.quantity),
                                                IsReviewed: false, status: :pending,
                                                isdiscounted: (cartitem.item.discount > 0 ? true : false),
                                                next_recurring_due_date: DateTime.now)
            @neworderitemcreate.save
            item = Item.where(id: cartitem.item_id).first
            item.decrement!(:quantity, cartitem.quantity)
            if item.quantity < 3
              send_inventory_alerts(item.id)
            end
            if !cartitem.recurssion_interval_id.nil?
              recurrion_interval = cartitem.recurssion_interval
              next_due_date = Time.current + recurrion_interval.days.days
              @neworderitemcreate.update_attributes(next_recurring_due_date: next_due_date,
                                                    recurssion_interval_id: cartitem.recurssion_interval_id)
            end
            is_any_recurring_item = true if cartitem.IsRecurring
          end
          @user.shopping_cart_items.destroy_all

          if @order.IsCash
            set_order_notifcation_email(@order, is_any_recurring_item)
            @user.notifications.create(order: @order, message: 'Your Order has been placed successfully')
          end

          return render json: {
            Message: 'Order was successfully created.',
            status: :created,
            VatPercentage: "5",
            #EarnedPoints: discount_per_transaction,
            OrderDetails: @order.as_json(
              :only => [:id, :Subtotal, :Delivery_Charges, :Vat_Charges, :Total, :Delivery_Date, :Order_Notes, :IsCash, :shipmenttime, :RedeemPoints, :earned_points, :company_discount, :is_user_from_company, :code_discount],
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
        else
          return render json: { Message: 'Error creating order', status: :unprocessable_entity, errors: @order.errors }
        end
      end

      def update
        @order.update(order_params)
        update_status(@order) if params['driver_id'].blank?

        render json: {
          Message: 'Order was successfully updated.',
          status: :updated,
          VatPercentage: "5",
          OrderDetails: @order.as_json(
            only: [:id, :Subtotal, :Delivery_Charges, :Vat_Charges, :Total, :Delivery_Date, :Order_Notes, :IsCash, :shipmenttime, :RedeemPoints, :earned_points, :company_discount, :is_user_from_company, :code_discount, :driver_id],
            include: {
              location: {
                only: [:id, :latitude, :longitude, :city, :area, :street, :building_name, :unit_number, :villa_number]
              },
              order_items: {
                only: [:id, :Quantity, :IsRecurring, :IsReviewed, :status],
                include: {
                  item: {
                    only: [:id, :picture, :name, :price, :discount, :description, :weight, :unit, :quantity, :short_description]
                  },
                  recurssion_interval: {
                    only: [:id, :days, :weeks, :label]
                  },
                  item_reviews: {
                    only: [:id, :user_id, :item_id, :rating, :comment]
                  }
                }
              }
            }
          )
        }
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

      def set_usercartitems
        @usercartitems = @user.shopping_cart_items
        return render json: { Message: 'Cart Empty', status: :unprocessable_entity } if @usercartitems.blank?
      end


      def check_empty_transactions
        if (params[:IsCash] == "false" and (params[:TransactionId].blank? or params[:TransactionDate].blank?))
          return render json: { Message: 'Invalid or empty Transaction reference', status: :unprocessable_entity }
        end
      end

      def send_inventory_alerts(itemid)
        OrderMailer.send_low_inventory_alert(itemid).deliver_later
      end

      def set_order_notifcation_email(order, is_any_recurring_item)
        OrderMailer.send_order_notification_email_to_admin(order.id).deliver_later
        OrderMailer.send_order_placement_notification_to_customer(@user.email, order.id).deliver_later
        return unless is_any_recurring_item

        OrderMailer.send_recurring_order_notification_email_to_admin(order.id).deliver_later
        OrderMailer.send_recurring_order_placement_notification_to_customer(@user.email, order.id).deliver_later
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def order_params
        params.permit(:TransactionId, :TransactionDate, :IsCash, :Payment_Status, :order_status_flag, :driver_id)
      end
    end
  end
end

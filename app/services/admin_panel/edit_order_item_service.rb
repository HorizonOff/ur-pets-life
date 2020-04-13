module AdminPanel
  class EditOrderItemService

    def initialize(order, params)
      @order = order
      @order_items_params = params[:order][:order_items_attributes]
      @sub_total_price = 0
      @undiscounted_order_items = 0
    end

    def update
      @order_items_params.each do |order_item_params|
        get_item_and_quantity(order_item_params)
        oi = get_order_item(order_item_params)
        next if oi.blank?

        if should_destroy?(order_item_params)
          cancel_order_item(oi)
        else
          update_order_item(oi)
        end

        @undiscounted_order_items += oi.Total_Price unless oi.isdiscounted
      end

      update_order
    end

    private

    attr_reader :order, :order_items_params, :item, :quantity, :sub_total_price, :undiscounted_order_items

    def create_order_item
      order_item = OrderItem.new(temporary_order_item_params)

      if order_item.save
        calculate_items_count(order_item)
        order_item
      end
    end

    def cancel_order_item(order_item)
      order_item.update_columns(status: :cancelled)
      calculate_items_count(order_item)

      send_order_cancellation_email(order_item.id)
    end

    def update_order_item(order_item)
      if quantity != order_item.Quantity || item.id != order_item.item_id
        calculate_items_count(order_item)
        order_item.update(temporary_order_item_params)
      end

      @sub_total_price += order_item.Total_Price
    end

    def update_order
      AdminPanel::OrderUpdateService.new(order, sub_total_price, undiscounted_order_items).update
    end

    def get_item_and_quantity(order_item_params)
      @item = Item.find_by_id(order_item_params[1][:item_id])
      @quantity = order_item_params[1][:Quantity].to_i
    end

    def get_order_item(order_item_params)
      params = order_item_params[1]
      return OrderItem.find_by_id(params['id']) if params['id'].present?

      create_order_item if params['item_id'].present?
    end

    def calculate_items_count(order_item)
      if item.id == order_item.item_id && quantity < order_item.Quantity
        item.increment!(:quantity, order_item.Quantity - quantity)
      elsif order_item.status_cancelled?
        order_item.item.increment!(:quantity, order_item.Quantity)
      else
        order_item.item.increment!(:quantity, order_item.Quantity) if item.id != order_item.item_id
        item.decrement!(:quantity, quantity)
      end

      send_inventory_alerts(item.id) if item.quantity < 3
    end

    def should_destroy?(order_item_params)
      order_item_params[1]['_destroy'] != 'false'
    end

    def send_order_cancellation_email(order_item_id)
      OrderMailer.send_order_cancellation_notification_to_customer(order_item_id).deliver_later
      OrderMailer.send_order_cancellation_notification_to_admin(order_item_id).deliver_later
    end

    def send_inventory_alerts(item_id)
      OrderMailer.send_low_inventory_alert(item_id).deliver_later
    end

    def temporary_order_item_params
      { order_id: order.id, item_id: item.id, Quantity: quantity, Unit_Price: item.price,
        Total_Price: item.price * quantity, isdiscounted: item.discount.positive? }
    end
  end
end

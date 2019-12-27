namespace :cancel_failed_orders do
  desc 'Update orders with failed payment'

  task update: :environment do
    Order.where(Payment_Status: 0, order_status_flag: 'pending').each do |order|
      order.update_columns(Subtotal: 0, Delivery_Charges: 0, Vat_Charges: 0, Total: 0,
                           earned_points: 0, RedeemPoints: 0, order_status_flag: 'cancelled', is_viewed: true)

      order.order_items.each do |order_item|
        item = Item.find_by_id(order_item.item_id)
        item.increment!(:quantity, order_item.Quantity)
        order_item.update_columns(status: order.order_status_flag)
      end

      if order.RedeemPoints.positive?
        user_redeem_point_reimburse = RedeemPoint.where(user_id: order.user_id)

        user_redeem_point_reimburse.update_columns(net_worth: user_redeem_point_reimburse.net_worth + order.RedeemPoints,
                                                   totalavailedpoints: user_redeem_point_reimburse.totalavailedpoints - order.RedeemPoints)
      end
    end
  end
end

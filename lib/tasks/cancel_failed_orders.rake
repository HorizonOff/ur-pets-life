namespace :cancel_failed_orders do
  desc 'Update orders with failed payment'

  task update: :environment do
    Order.where(Payment_Status: 0).update_all(order_status_flag: 'cancelled')
  end
end

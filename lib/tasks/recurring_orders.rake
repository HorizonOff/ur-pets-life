namespace :recurring_orders do
  desc "This job will add recurring orders"
  task recurring_job: :environment do
    ::API::V1::OrderServices::RecurringOrdersService.new().perform
  end

  task make_recurring_orders_visible: :environment do
    Order.yesterday.where(is_pre_recurring: true).find_each do |order|
      order.update_column(:is_pre_recurring, false)
    end
  end
end

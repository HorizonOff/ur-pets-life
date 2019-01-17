namespace :recurring_orders do
  desc "This job will add recurring orders"
  task recurring_job: :environment do
    ::API::V1::OrderServices::RecurringOrdersService.new().perform
  end
end

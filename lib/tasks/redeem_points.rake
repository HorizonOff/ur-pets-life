namespace :redeem_points do
  desc "this Job will add Redeem Points on Customer Annual Purchases"

  task annual_job: :environment do
    ::RedeemPointServices::LoyaltyAutomationService.new().assign_rewards

  end

end

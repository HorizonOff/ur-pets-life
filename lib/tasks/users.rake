namespace :users do
  desc 'Update next users column: spends_eligble, spends_not_eligble'
  task update_spends: :environment do
    User.find_each(&:update_spends)
  end
end

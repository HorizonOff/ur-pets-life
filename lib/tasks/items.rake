namespace :items do
  desc 'Sending list of items that out of expire date'
  task check_expiry_at: :environment do
    if Date.current.day == 3 && Item.six_month_before_expiry_date.any?
      ItemMailer.send_list_of_expiry_at.deliver
    end
  end
end

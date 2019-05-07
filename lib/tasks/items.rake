namespace :items do
  desc 'Sending list of items that out of expire date, delete inactive items'
  task check_expiry_at: :environment do
    if Date.current.day == 3 && Item.six_month_before_expiry_date.any?
      ItemMailer.send_list_of_expiry_at.deliver
    end
  end

  task delete_inactive: :environment do
    Item.where(is_active: false).destroy_all
  end
end

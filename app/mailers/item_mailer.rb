class ItemMailer < ApplicationMailer
  def send_list_of_expiry_at
    @items = Item.six_month_before_expiry_date
    mail(to: ENV['ADMIN'], subject: 'List of items that expiry at 6 month')
  end
end

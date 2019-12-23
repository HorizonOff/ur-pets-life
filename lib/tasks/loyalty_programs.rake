namespace :loyalty_programs do
  desc 'Loyalty program cash back'
  task second: :environment do
    exit! if Time.now.strftime('%d-%m') != '01-01'
    users = User.joins(:orders).where('orders.created_at >= ?', 1.year.ago).uniq

    users.to_a.each do |user|
      total = 0

      Order.where('created_at >= ? AND user_id >= ?', DateTime.new(Time.now.year), user.id).each do |order|
        total += order.Total - order.Vat_Charges
      end

      if total > 10000
        loyalty_redeems = total * 0.05
        user.redeem_point.update_columns(net_worth: user.redeem_point.net_worth + loyalty_redeems)
      elsif total > 5000
        loyalty_redeems = total * 0.03
        user.redeem_point.update_columns(net_worth: user.redeem_point.net_worth + loyalty_redeems)
      end

      user.update_columns(spends_eligble: 0, spends_not_eligble: 0)
    end
  end
end

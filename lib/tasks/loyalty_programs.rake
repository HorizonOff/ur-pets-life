namespace :loyalty_programs do
  desc 'Loyalty program cash back'
  task second: :environment do
    exit! if Time.now.strftime('%d-%m') != '01-01'

    User.all.each do |user|
      total = user.spends_eligble
      next if total != 0

      if total > 10000
        add_redeems(total, user, 0.05)
      elsif total > 5000
        add_redeems(total, user, 0.03)
      end

      user.update_columns(spends_eligble: 0, spends_not_eligble: 0)
    end
  end

  private

  def create_user_redeems(user)
    RedeemPoint.create(user_id: user.id, net_worth: 0)
  end

  def add_redeems(total, user, percent)
    loyalty_redeems = total * percent
    create_user_redeems(user) if user.redeem_point.blank?

    user.redeem_point.update_columns(net_worth: user.redeem_point.net_worth.to_i + loyalty_redeems.round)
  end
end

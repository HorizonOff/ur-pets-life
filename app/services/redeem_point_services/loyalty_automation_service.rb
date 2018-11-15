module RedeemPointServices
  class LoyaltyAutomationService
    def initialize()
    end

    def assign_rewards
      puts "starting annual loyalty automation"
      start_date = Time.now.ago(1.year)
      end_date = Time.now
      @orders = Order.where(created_at: start_date..end_date)
      if @orders.count > 0
        puts "Found #{@orders.count} Orders from #{start_date} to #{end_date}"
        user_ids = @orders.distinct.pluck(:user_id)
        puts "Found #{user_ids.count} Users for Evaluation"
        user_ids.each do |targetuser|
          totalpurchase = @orders.where(user_id: targetuser).sum(:Total)
          puts "User #{targetuser} annual purchases are #{totalpurchase}"
          if totalpurchase >= 5000
            points_earned = calculate_reward_points(totalpurchase)
            puts "User #{targetuser} earned points are #{points_earned}"
            set_user_redeem_points(targetuser, points_earned)
          else
            puts "User Not eligible for Redeem Points Reward"
          end
        end
      else
        puts "Not Records found"
      end
      puts "Job terminating"
    end

    def calculate_reward_points(purchases)
      reward_points = 0
      if purchases == 0
        return reward_points
      else
        if purchases > 10000
          points_earned = (5*purchases)/100
          reward_points += points_earned
        elsif purchases > 5000
          points_earned = (3*purchases)/100
          reward_points += points_earned
        end
      end
      return reward_points
    end

    def set_user_redeem_points(user_id, pointsearned)
      if RedeemPoint.where(:user_id => user_id).exists?
        user_redeem_point = RedeemPoint.where(:user_id => user_id).first
        update_redeem_points(user_redeem_point, pointsearned)
      else
        user_redeem_point = RedeemPoint.new(:user_id => user_id, :net_worth => 0, :last_net_worth => 0, :totalearnedpoints => 0, :totalavailedpoints => 0)
        update_redeem_points(user_redeem_point, pointsearned)
      end
    end

    def update_redeem_points(redeempoint, pointsearned)
      l_net_worth = redeempoint.net_worth
      redeempoint.update(:net_worth => (l_net_worth + pointsearned), :last_net_worth => l_net_worth, :last_reward_type => "Annual Purchases",  :last_reward_worth => pointsearned, :last_reward_update => Time.now, :totalearnedpoints => (redeempoint.totalearnedpoints + pointsearned))
      puts "User #{redeempoint.user_id} has been awarded #{pointsearned} Redeem Points"
    end
  end
end

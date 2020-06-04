module OrdersServices
  class OrderMathService
    def initialize(sub_total, redeem_points, user)
      @sub_total = sub_total
      @redeem_points = redeem_points
      @user = user
      @permitted_redeem_points = 0
      @discount_per_transaction = 0
    end

    def calculate_discount
      discount
    end

    def calculate_redeem_points
      order_redeem_points
      @user_redeem_point_record
    end

    private

    attr_reader :sub_total, :redeem_points, :user, :discount_per_transaction

    def discount
      if sub_total <= 500
        @discount_per_transaction =+ (3*sub_total)/100
      elsif sub_total > 500 && sub_total <= 1000
        @discount_per_transaction =+ (5*sub_total)/100
      elsif sub_total > 1000 && sub_total <= 2000
        @discount_per_transaction =+ (7.5*sub_total)/100
      elsif sub_total > 2000
        @discount_per_transaction =+ (10*sub_total)/100
      end
      @discount_per_transaction.to_f.ceil
    end

    def order_redeem_points
      requested_redeem_points = redeem_points.to_i

      if user.redeem_point.present?
        @user_redeem_point_record = user.redeem_point
      else
        @user_redeem_point_record = RedeemPoint.create(user_id: user.id, net_worth: 0, last_net_worth: 0,
                                                       totalearnedpoints: 0, totalavailedpoints: 0)
      end
      user_redeem_points = @user_redeem_point_record.net_worth

      if requested_redeem_points > 0
        if requested_redeem_points <= user_redeem_points
          @permitted_redeem_points = requested_redeem_points
        else
          @permitted_redeem_points = user_redeem_points
        end
      end

      @permitted_redeem_points = sub_total if @permitted_redeem_points > sub_total
    end
  end
end


module Api
  module V1
    class UsedPayCodesController < Api::BaseController
      def pay_code
        pay_code = current_user.pay_code
        render json: { pay_code: pay_code }.to_json
      end

      def check_pay_code
        user = User.find_by(pay_code: params[:pay_code])
        return render_404 if user.blank?
        return render_422('Already used 3 times') if user.used_pay_codes.count >= 3
        return render_422('You already use this code') if current_user.id.in?(user.used_pay_codes.pluck(:id))

        render json: { message: 'Code checked' }.to_json
      end
    end
  end
end

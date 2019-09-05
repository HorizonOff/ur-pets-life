module Api
  module V1
    class UsedPayCodesController < Api::BaseController
      def pay_code
        pay_code = current_user.pay_code
        render json: { pay_code: pay_code }.to_json
      end

      def check_pay_code
        user = User.find_by(pay_code: params[:pay_code])
        return render_422('Code not found') if user.blank?
        return render_422('You can not use your own code') if user == current_user
        return render_422('This code already used 3 times') if user.used_pay_codes.count >= 3
        return render_422('Each user can use one code') if UsedPayCodes.where(code_user_id: current_user.id).any?

        render json: { message: 'Code checked' }.to_json
      end
    end
  end
end

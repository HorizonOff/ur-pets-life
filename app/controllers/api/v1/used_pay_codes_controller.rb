module Api
  module V1
    class UsedPayCodesController < Api::BaseController
      def pay_code
        pay_code = current_user.pay_code
        render json: { pay_code: pay_code }.to_json
      end
    end
  end
end

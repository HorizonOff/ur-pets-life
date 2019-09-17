module Api
  module V1
    class DiscountCodeService
      def initialize(code, code_user, sub_total)
        @code = code
        @code_user = code_user
        @sub_total = sub_total
      end

      def discount_from_code
        return 0 if code.blank?
        return 0 if @sub_total < 200

        user = User.find_by(pay_code: code)
        return 0 if user.blank?
        return 0 if user == code_user
        return 0 if user.used_pay_codes.count >= 3
        return 0 if code_user.id.in?(user.used_pay_codes&.pluck(:code_user_id))

        -50
      end

      private

      attr_reader :code, :code_user, :sub_total
    end
  end
end

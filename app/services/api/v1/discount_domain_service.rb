module Api
  module V1
    class DiscountDomainService
      def initialize(email)
        @email = email
      end

      def dicount_on_email
        domain = '@' + @email.split("@").last
        discount = DiscountDomain.find_by(domain: domain)&.discount
        discount
      end

      private

      attr_reader :email
    end
  end
end

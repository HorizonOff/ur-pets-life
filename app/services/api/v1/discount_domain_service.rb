module Api
  module V1
    class DiscountDomainService
      def initialize(email)
        @email = email
        @popular_domains = %w[@gmail.com @hotmail.com @yahoo.com].freeze
        @domain = '@' + email.split("@").last
      end

      def dicount_on_email
        discount = DiscountDomain.find_by(domain: @domain)&.discount
        discount
      end

      def is_domain_popular
        @domain.in?(@popular_domains)
      end

      private

      attr_reader :email, :domain, :popular_domains
    end
  end
end

module Api
  module V1
    class DiscountDomainService
      def initialize(email)
        @email = email
        @user = User.find_by(email: email)
        @popular_domains = %w[@gmail.com @hotmail.com @yahoo.com].freeze
        @domain = '@' + email.split("@").last
      end

      def dicount_on_email
        discount_domain = DiscountDomain.find_by(domain: @domain)&.discount
        discount_member = if @user.member_type == 'gold'
                            20
                          elsif @user.member_type == 'silver'
                            10
                          else
                            0
                          end
        discount = [discount_domain.to_i, discount_member.to_i].max
        discount
      end

      def is_domain_popular
        @domain.in?(@popular_domains)
      end

      private

      attr_reader :email, :domain, :popular_domains, :user
    end
  end
end

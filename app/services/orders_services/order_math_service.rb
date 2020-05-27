module OrdersServices
  class OrderMathService
    def initialize(price_for_award)
      @price_for_award = price_for_award
      @discount_per_transaction = 0
    end

    def calculate_discount
      discount
    end

    private

    attr_reader :price_for_award, :discount_per_transaction

    def discount
      if price_for_award <= 500
        @discount_per_transaction =+ (3*price_for_award)/100
      elsif price_for_award > 500 && price_for_award <= 1000
        @discount_per_transaction =+ (5*price_for_award)/100
      elsif price_for_award > 1000 && price_for_award <= 2000
        @discount_per_transaction =+ (7.5*price_for_award)/100
      elsif price_for_award > 2000
        @discount_per_transaction =+ (10*price_for_award)/100
      end
      @discount_per_transaction.to_f.ceil
    end
  end
end


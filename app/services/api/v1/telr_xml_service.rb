module Api
  module V1
    class TelrXmlService
      def initialize(type, amount, transaction)
        @type = type
        @amount = amount
        @transaction = transaction
      end

      def build_xml
        Nokogiri::XML::Builder.new do |xml|
          xml.remote {
            xml.store_ ENV['TELR_MERCHANT_ID']
            xml.key_ ENV['TELR_API_KEY']
            xml.tran {
              xml.type_ type
              xml.class_ "ecom"
              xml.currency_ "AED"
              xml.amount_ amount
              xml.ref_ transaction
              xml.test_ "1"
            }
          }
        end
      end

      private

      attr_reader :type, :amount, :transaction

    end
  end
end

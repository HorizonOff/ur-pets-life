require 'net/http'
require 'json'

module Api
  module V1
    module OrderServices
      class OnlinePaymentService

        def initialize
          @baseurl = ENV["PAYMENT_GATEWAY_BASE_URL"]
          @storeid = ENV["PAYMENT_GATEWAY_STORE_ID"]
          @authkey = ENV["PAYMENT_GATEWAY_API_AUTH_KEY"]
          @currency = ENV["PAYMENT_CURRENCY"]
          @mode = ENV["PAYMENT_MODE"]
        end

        def send_payment_request(tran_type, tran_class, tran_ref, desc, orderid, amount)
          request_payload = set_transaction_payload(tran_type, tran_class, tran_ref, desc, orderid, amount)
          uri = URI(@baseurl)
          uri.query = URI.encode_www_form(request_payload)
          http = Net::HTTP.new(uri.host, uri.port)
          request = Net::HTTP::Post.new(uri.path)
          response = http.request(request)
          response_json = CGI.parse(response.body)
          response_values = []
          response_values << response_json['sale_tranref'].first.to_s
          response_values << response_json['sale_trandate'].first.to_s
          response_values
        end

        private

        def set_transaction_payload(tran_type, tran_class, tran_ref, desc, orderid, amount)

          params =  {
            :ivp_store => "#{@storeid}",
            :ivp_authkey => "#{@authkey}",
            :ivp_trantype => "#{tran_type}",
            :ivp_tranclass => "#{tran_class}",
            :ivp_desc => "#{desc}",
            :ivp_cart => "#{orderid}",
            :ivp_currency => "#{@currency}",
            :ivp_amount => "#{amount}",
            :tran_ref => "#{tran_ref}",
            :ivp_test => "#{@mode}"
          }

        end
      end
    end
  end
end

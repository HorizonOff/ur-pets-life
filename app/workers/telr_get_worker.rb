class TelrGetWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(type, amount, order_id)
    @order = Order.find_by_id(order_id)

    post_request(type, amount, @order)
  end

  private

  def post_request(type, amount, order)
    req = Faraday.post('https://secure.telr.com/gateway/remote.xml', proxy: ENV["FIXIE_URL"]) do |request|
      request.body = ::Api::V1::TelrXmlService.new(type, amount, order).build_xml.to_xml
      request.headers['Content-Type'] = 'application/xml'
    end
    body = MultiXml.parse(req.body)

    return send_telr_error(order, type, body['remote']['auth']['message']).deliver if body['remote']['auth']['status'] == 'E'

    get_request if type == 'capture' && order.order_items.where(status: "cancelled").present?
  end

  def get_request
    req = Faraday.get("https://secure.telr.com/tools/api/xml/transaction/#{@order.TransactionId}", proxy: ENV["FIXIE_URL"]) do |request|
      request.headers['Authorization'] = ENV['TELR_BASIC_KEY']
    end

    if req.success?
      amount = MultiXml.parse(req.body)['transaction']['amount'].to_f - @order.Total
    else
      amount = 0
      @order.order_items.where(status: "cancelled").each do |item|
        amount += item.Total_Price
      end
    end

    post_request('release', amount, @order)
  end

  def send_telr_error(order, type, error)
    OrderMailer.send_telr_error(order, type, error)
  end
end

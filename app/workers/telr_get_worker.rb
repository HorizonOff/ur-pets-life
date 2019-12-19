class TelrGetWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(type, amount, order_id)
    @order = Order.find_by_id(order_id)

    return refund if type == 'capture' && @order.order_items.where(status: "cancelled").present?

    post_request(type, amount, @order.TransactionId)
  end

  private

  def post_request(type, amount, transaction)
    req = conn.post('/gateway/remote.xml') do |request|
      request.body = ::Api::V1::TelrXmlService.new(type, amount, transaction).build_xml.to_xml
      request.headers['Content-Type'] = 'application/xml'
    end
    body = MultiXml.parse(req.body)

    send_telr_error(@order, type, body['remote']['auth']['message']).deliver if body['remote']['auth']['status'] != 'A'
  end

  def get_request
    conn.get("/tools/api/xml/transaction/#{@order.TransactionId}") do |request|
      request.headers['Authorization'] = ENV['TELR_BASIC_KEY']
    end
  end

  def refund
    if get_request.success?
      amount = MultiXml.parse(get_request.body)['transaction']['amount'].to_f
      post_request('capture', amount, @order.TransactionId)

      amount -= @order.Total
      post_request('refund', amount, MultiXml.parse(get_request.body)['transaction']['notes']['note']['ref'])
    else
      amount = 0
      @order.order_items.where(status: "cancelled").each do |item|
        amount += item.Total_Price
      end

      send_manual_capture_request(@order, amount)
    end
  end

  def conn
    Faraday.new(url: 'https://secure.telr.com', proxy: ENV['FIXIE_URL'])
  end

  def send_telr_error(order, type, error)
    OrderMailer.send_telr_error(order, type, error)
  end

  def send_manual_capture_request(order, refund)
    OrderMailer.send_manual_capture_request(order, refund)
  end
end

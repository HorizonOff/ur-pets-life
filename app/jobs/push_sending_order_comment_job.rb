class PushSendingOrderCommentJob
  include SuckerPunch::Job

  def perform(id, order_id)
    ActiveRecord::Base.connection_pool.with_connection do
      @comment = Comment.find_by(id: id)
      @order = Order.find_by(id: order_id)
      push_sending_service.send_push
    end
  end

  private

  def push_sending_service
    @push_sending_service ||= ::PushSending::OrderCommentService.new(@comment, @order)
  end
end

class EmailOrderCommentWorker
  include Sidekiq::Worker

  def perform(order_id)
    OrderMailer.inform_about_comment(order_id).deliver
  end
end

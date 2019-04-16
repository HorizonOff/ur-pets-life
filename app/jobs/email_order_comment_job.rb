class EmailOrderCommentJob
  include SuckerPunch::Job

  def perform(order_id)
    ActiveRecord::Base.connection_pool.with_connection do
      OrderMailer.inform_about_comment(order_id).deliver
    end
  end
end

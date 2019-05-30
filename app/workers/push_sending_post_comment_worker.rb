class PushSendingPostCommentWorker
  include Sidekiq::Worker

  def perform(id, post_id, user_id)
    @comment = Comment.find_by(id: id)
    @post = Post.find_by(id: post_id)
    @user = User.find_by(id: user_id)
    push_sending_service.send_push
  end

  private

  def push_sending_service
    @push_sending_service ||= ::PushSending::PostCommentService.new(@comment, @post, @user)
  end
end

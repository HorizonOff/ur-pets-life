module AdminPanel
  class CommentsController < AdminPanelController
    before_action :set_post

    def index
      @comments = @post.comments.includes(:user).order(id: :desc).page(params[:page])
    end

    private

    def set_post
      @post = Post.find_by(id: params[:post_id])
    end
  end
end

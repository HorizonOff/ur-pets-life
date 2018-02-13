module AdminPanel
  class CommentsController < AdminPanelController
    before_action :authorize_super_admin
    before_action :set_post, only: :index
    before_action :set_comment, only: :destroy

    def index
      @comments = @post.comments.includes(:user).order(id: :desc).page(params[:page])
    end

    def destroy
      @post = @comment.post
      flash[:success] = 'Comment was deleted' if @comment.destroy
    end

    private

    def set_post
      @post = Post.find_by(id: params[:post_id])
    end

    def set_comment
      @comment = Comment.find_by(id: params[:id])
    end
  end
end

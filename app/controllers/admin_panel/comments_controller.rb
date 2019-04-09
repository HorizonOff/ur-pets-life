module AdminPanel
  class CommentsController < AdminPanelController
    # before_action :authorize_super_admin
    before_action :set_parent_object, only: %i[index create]
    before_action :set_comment, only: :destroy

    def index
      @comments = @parent_object.comments.includes(:writable).order(id: :desc).page(params[:page])
      read_comments if !current_admin.is_super_admin? && @parent_object.is_a?(Appointment)
      @comment = @parent_object.comments.new
    end

    def create
      @comment = @parent_object.comments.new(comment_params)
      @comment.writable = current_admin
      @comment.save
    end

    def destroy
      @parent_object = @comment.commentable
      flash[:success] = 'Comment was deleted' if @comment.destroy
    end

    private

    def read_comments
      @comments.read_by_admin
      @parent_object.update_counters
      current_admin.update_counters
    end

    def set_parent_object
      if params[:post_id].present?
        @parent_object = set_post
      elsif params[:order_id].present?
        @parent_object = set_order
      else
        @parent_object = set_appointment
      end
    end

    def set_post
      Post.find_by_id(params[:post_id])
    end

    def set_order
      Order.find_by_id(params[:order_id])
    end

    def set_appointment
      Appointment.find_by_id(params[:appointment_id])
    end

    def set_comment
      @comment = Comment.find_by(id: params[:id])
    end

    def comment_params
      params.require(:comment).permit(:message)
    end
  end
end

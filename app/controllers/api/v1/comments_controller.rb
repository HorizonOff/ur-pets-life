module Api
  module V1
    class CommentsController < Api::BaseController
      skip_before_action :authenticate_user, only: :index
      before_action :set_post

      def index
        @created_at = Time.zone.at(params[:created_at].to_i)
        comments = @post.comments.where('created_at <= ?', @created_at).order(created_at: :desc)
                        .includes(:user, user: :pet_avatar).limit(20)
        serialized_comments = ActiveModel::Serializer::CollectionSerializer.new(comments)

        render json: { comments: serialized_comments, total_count: @post.comments_count }
      end

      def create
        comment = @user.comments.new(comment_params.merge(post_id: @post.id))
        if comment.save
          render json: { message: 'Comment saccessfully created' }
        else
          render_422(parse_errors_messages(comment))
        end
      end

      private

      def set_post
        @post = Post.find_by_id(params[:post_id])
        return render_404 unless @post
      end

      def comment_params
        params.require(:comment).permit(:message)
      end
    end
  end
end

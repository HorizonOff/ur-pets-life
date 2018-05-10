module Api
  module V1
    class CommentsController < Api::BaseController
      skip_before_action :authenticate_user, only: :index
      before_action :set_parent_object

      def index
        @created_at = Time.zone.at(params[:created_at].to_i)
        comments = @parent_object.comments.where('created_at < ?', @created_at).order(created_at: :desc)
                                 .includes(:writable).limit(20)
        comments = ::Api::V1::CommentDecorator.decorate_collection(comments)
        serialized_comments = ActiveModel::Serializer::CollectionSerializer.new(comments, serializer: CommentSerializer)

        render json: { title: title, message: message, created_at: created_at,
                       comments: serialized_comments, total_count: @parent_object.comments_count }
      end

      def create
        comment = @parent_object.comments.new(comment_params)
        comment.writable = @user
        if comment.save
          comment = ::Api::V1::CommentDecorator.decorate(comment)
          render json: comment, serializer: CommentSerializer
        else
          render_422(parse_errors_messages(comment))
        end
      end

      private

      def set_parent_object
        @parent_object = params[:post_id].present? ? set_post : set_appointment
        return render_404 unless @parent_object
      end

      def set_post
        Post.find_by_id(params[:post_id])
      end

      def set_appointment
        Appointment.find_by_id(params[:appointment_id])
      end

      def comment_params
        params.require(:comment).permit(:message)
      end

      def title
        is_a_post? ? @parent_object.title : @parent_object.bookable.name
      end

      def message
        is_a_post? ? @parent_object.message : @parent_object.comment
      end

      def created_at
        @parent_object.created_at.to_i
      end

      def is_a_post?
        @is_a_post ||= @parent_object.is_a?(Post)
      end
    end
  end
end

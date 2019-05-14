module Api
  module V1
    class CommentsController < Api::BaseController
      skip_before_action :authenticate_user, only: :index
      before_action :set_parent_object
      before_action :parse_date, only: :index

      def index
        is_authorized = true
        if (@parent_object.is_a?(Order) or @parent_object.is_a?(Appointment))
          is_authorized = authenticate_user_for_chat
        end
        if is_authorized
          # authenticate_user if @parent_object.is_a?(Appointment)
          comments = @parent_object.comments.where('created_at < ?', @created_at).order(created_at: :desc)
                                 .includes(:writable, :commentable).limit(20)

          decorated_comments = ::Api::V1::CommentDecorator.decorate_collection(comments)
          serialized_comments = ActiveModel::Serializer::CollectionSerializer.new(decorated_comments,
                                                                              serializer: CommentSerializer)

          read_comments(comments) if @parent_object.is_a? Appointment
          read_comments(comments) if @parent_object.is_a? Order

          render json: { comments: serialized_comments, total_count: @parent_object.comments_count }.merge(default_fields)
        else
          render_401
        end
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

      def read_comments(comments)
        comments.read_by_user
        @parent_object.update_counters
        current_user.update_counters
      end

      def parse_date
        @created_at = Time.zone.at(params[:created_at].to_i)
      end

      def set_parent_object
        if  params[:post_id].present?
          @parent_object = set_post
        elsif params[:order_id].present?
          @parent_object = set_order
        else
          @parent_object = set_appointment
        end
        return render_404 unless @parent_object
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

      def comment_params
        params.require(:comment).permit(:message, :mobile_image_url)
      end

      def default_fields
        @default_fields ||= { title: title, message: message, created_at: created_at }
        unless a_post?
          @default_fields[:unread_comments_count_by_user] = @parent_object.unread_comments_count_by_user
          @default_fields[:unread_commented_appointments_count] = (@user.unread_commented_appointments_count + @user.unread_commented_orders_count)
        end
        @default_fields
      end

      def title
        if a_post?
          @parent_object.title
        elsif @parent_object.is_a?(Appointment)
          @parent_object.bookable.name
        elsif @parent_object.is_a?(Order)
          'Order # ' + @parent_object.id.to_s
        end
      end

      def message
        if a_post?
          @parent_object.message
        elsif @parent_object.is_a?(Appointment)
          @parent_object.comment
        elsif @parent_object.is_a?(Order)
          ''
        end
      end

      def created_at
        @parent_object.created_at.to_i
      end

      def a_post?
        @a_post ||= @parent_object.is_a?(Post)
      end
    end
  end
end

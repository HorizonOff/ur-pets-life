module Api
  module V1
    class PostsController < Api::BaseController
      skip_before_action :authenticate_user, only: :index

      def index
        @created_at = Time.zone.at(params[:created_at].to_i)
        posts = Post.where('created_at <= ?', @created_at).order(created_at: :desc)
                    .includes(:user, user: :pet_avatar).limit(20)

        serialized_posts = ActiveModel::Serializer::CollectionSerializer.new(posts)
        render json: { posts: serialized_posts, total_count: Post.count }
      end

      def create
        post = @user.posts.new(post_params)
        if post.save
          render json: { message: 'Post saccessfully created' }
        else
          render_422(parse_errors_messages(post))
        end
      end

      private

      def post_params
        params.require(:post).permit(:title, :message, :pet_type_id)
      end
    end
  end
end

module AdminPanel
  class PostsController < AdminPanelController
    before_action :authorize_super_admin
    before_action :set_post, only: %i[destroy create]

    def index
      respond_to do |format|
        format.html {}
        format.json { filter_posts }
      end
    end

    def new
      @post = Post.new
    end

    def create
      @post = current_admin.posts.new(post_params)
      if @post.save
        flash[:success] = 'Post was successfully created'
        redirect_to admin_panel_posts_path
      else
        flash[:error] = "Post wasn't created"
        render :new
      end
    end

    def show
      @parent_object = Post.find_by(id: params[:id])
      @comments = @parent_object.comments.includes(:writable).order(id: :desc).page(params[:page])
      @comment = @parent_object.comments.new
    end

    def destroy
      if @post.destroy
        render json: { message: 'Post was deleted' }
      else
        render json: { errors: @post.errors.full_messages }, status: 422
      end
    end

    private

    def set_post
      @post = Post.find_by(id: params[:id])
    end

    def post_params
      params.require(:post).permit(:image, :video, :pet_type_id, :title, :message)
    end

    def filter_posts
      filtered_posts = filter_and_pagination_query.filter
      posts = ::AdminPanel::PostDecorator.decorate_collection(filtered_posts)
      serialized_posts = ActiveModel::Serializer::CollectionSerializer.new(
        posts, serializer: ::AdminPanel::PostFilterSerializer, adapter: :attributes
      )

      render json: { draw: params[:draw], recordsTotal: Post.count,
                     recordsFiltered: filtered_posts.total_count, data: serialized_posts }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('Post', params)
    end
  end
end

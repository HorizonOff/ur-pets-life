module AdminPanel
  class MySecondHouseMemberInvitationsController < AdminPanelController
    before_action :authorize_super_admin

    def index
      respond_to do |format|
        format.html {}
        format.json { filter_invitations }
      end
    end

    def new
      @invitation = MySecondHouseMemberInvitation.new
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

    def filter_invitations
      filter_invitations = filter_and_pagination_query.filter
      invitations = ::AdminPanel::InvitationDecorator.decorate_collection(filter_invitations)
      serialized_invitations = ActiveModel::Serializer::CollectionSerializer.new(
        invitations, serializer: ::AdminPanel::InvitationFilterSerializer, adapter: :attributes
      )

      render json: { draw: params[:draw], recordsTotal: MySecondHouseMemberInvitation.count,
                     recordsFiltered: filter_invitations.total_count, data: serialized_invitations }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('MySecondHouseMemberInvitation', params)
    end
  end
end

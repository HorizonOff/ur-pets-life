module AdminPanel
  class UsersController < AdminPanelController
    before_action :authorize_super_admin
    before_action :set_user, except: %i[index new create]
    before_action :set_location, only: %i[edit]

    def index
      respond_to do |format|
        format.html {}
        format.json { filter_users }
      end
    end

    def edit; end

    def show; end

    def update
      @user.assign_attributes(user_params)
      if @user.save
        flash[:success] = 'User was successfully updated'
        redirect_to admin_panel_users_path
      else
        set_location
        render :edit
      end
    end

    def destroy
      @user.destroy
      flash[:success] = 'User was successfully deleted'
      redirect_to admin_panel_users_path
    end

    private

    def set_user
      @user = User.find_by(id: params[:id])
    end

    def set_location
      @user.build_location if @user.location.blank?
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :mobile_number, location_attributes: location_params)
    end

    def location_params
      %i[id latitude longitude city area street building_type building_name unit_number villa_number comment _destroy]
    end

    def filter_users
      filtered_users = filter_and_pagination_query.filter
      users = ::AdminPanel::UserDecorator.decorate_collection(filtered_users)
      serialized_users = ActiveModel::Serializer::CollectionSerializer.new(
        users, serializer: ::AdminPanel::UserFilterSerializer, adapter: :attributes
      )

      render json: { draw: params[:draw], recordsTotal: User.count,
                     recordsFiltered: filtered_users.total_count, data: serialized_users }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('User', params)
    end
  end
end

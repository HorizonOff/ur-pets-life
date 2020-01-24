module AdminPanel
  class UsersController < AdminPanelController
    include StaticMapHelper

    before_action :authorize_super_admin_employee_msh_admin
    before_action :set_user, except: %i[index new create]
    before_action :set_location, only: %i[edit]

    @@redeem_points_net_worth = 0
    def index
      respond_to do |format|
        format.html {}
        format.xlsx { export_data }
        format.json { filter_users }
      end
    end

    def edit
      @@redeem_points_net_worth = 0
      if !RedeemPoint.where(:user_id => @user.id).exists?
        @redeempoint = RedeemPoint.create(:user_id => @user.id, :net_worth => 0, :last_net_worth => 0, :totalearnedpoints => 0, :totalavailedpoints => 0)
        @user.redeem_point = @redeempoint
        @@redeem_points_net_worth = @redeempoint.net_worth
      else
        @@redeem_points_net_worth = @user.redeem_point.net_worth
      end
    end

    def show
      if !RedeemPoint.where(:user_id => @user.id).exists?
        @redeempoint = RedeemPoint.create(:user_id => @user.id, :net_worth => 0, :last_net_worth => 0, :totalearnedpoints => 0, :totalavailedpoints => 0)
        @user.redeem_point = @redeempoint
      end
      @pets = ::AdminPanel::PetDecorator.decorate_collection(@user.pets)
    end

    def update
      @user.assign_attributes(user_params)
      if @user.save
        if @user.redeem_point.net_worth > @@redeem_points_net_worth
          @user.redeem_point.update(:totalearnedpoints => (@user.redeem_point.totalearnedpoints + (@user.redeem_point.net_worth - @@redeem_points_net_worth)))
        end
        flash[:success] = 'User was successfully updated'
        redirect_to admin_panel_users_path
      else
        set_location
        render :edit
      end
    end

    def destroy
      if @user.destroy
        respond_to do |format|
          format.html do
            flash[:success] = 'User was deleted'
            redirect_to admin_panel_users_path
          end
          format.js { render json: { message: 'User was deleted' } }
        end
      else
        respond_to do |format|
          format.html do
            flash[:error] = "User wasn't deleted"
            render :show
          end
          format.js { render json: { errors: @user.errors.full_messages }, status: 422 }
        end
      end
    end

    def location
      location = Location.find_by_id(params['location_id'])
      img_url = generate_static_map_url(location)

      render json: { img_url: img_url}
    end

    private

    def set_user
      @user = User.find_by(id: params[:id])
    end

    def set_location
      @user.build_location if @user.location.blank?
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :mobile_number, :gender, :birthday, :email, :spends_eligble,
                                   :spends_not_eligble, :member_type,
                                   location_attributes: location_params,
                                   redeem_point_attributes: redeem_point_params)
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
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('User', params, current_admin)
    end

    def export_data
      @users = User.all.order(:id).includes(:location)
      @users = @users.msh_members if current_admin.is_msh_admin?
      name = "users #{Time.now.utc.strftime('%d-%M-%Y')}.xlsx"
      response.headers['Content-Disposition'] = "attachment; filename*=UTF-8''#{name}"
    end
  end
end

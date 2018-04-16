module AdminPanel
  class AdminsController < AdminPanelController
    before_action :authorize_super_admin
    before_action :set_admin, except: :index
    before_action :authorize_admin, except: :index

    def index
      respond_to do |format|
        format.html {}
        format.json { filter_admins }
      end
    end

    def change_status
      @admin.is_active = !@admin.is_active
      if @admin.save
        render json: { message: 'success' }, status: 200
      else
        render json: { message: @admin.errors.full_messages }, status: 422
      end
    end

    def destroy
      if @admin.destroy
        render json: { message: 'success' }, status: 200
      else
        render json: { errors: @admin.errors.full_messages }, status: 422
      end
    end

    def restore
      if @admin.restore
        render json: { message: 'success' }, status: 200
      else
        render json: { message: @admin.errors.full_messages }, status: 422
      end
    end

    private

    def set_admin
      @admin = Admin.with_deleted.find_by_id(params[:id])
    end

    def authorize_admin
      authorize @admin, :not_him_self?
    end

    def filter_admins
      filtered_admins = filter_and_pagination_query.filter
      admins = ::AdminPanel::AdminDecorator.decorate_collection(filtered_admins,
                                                                context: { current_admin: current_admin })
      serialized_admins = ActiveModel::Serializer::CollectionSerializer.new(
        admins, serializer: ::AdminPanel::AdminFilterSerializer, adapter: :attributes
      )

      render json: { draw: params[:draw], recordsTotal: Admin.with_deleted.count,
                     recordsFiltered: filtered_admins.total_count, data: serialized_admins }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('Admin', params)
    end
  end
end

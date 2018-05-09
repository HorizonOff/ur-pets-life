module AdminPanel
  class BoardingsController < AdminPanelController
    include AdminPanel::PictureParamsHelper
    before_action :set_boarding, except: %i[index new create]
    before_action :can_create?, only: %i[new create]
    before_action :can_update?, except: %i[index new create]

    def index
      authorize_super_admin
      respond_to do |format|
        format.html {}
        format.json { filter_boardings }
      end
    end

    def new
      @boarding = Boarding.new
      @boarding.build_relations
    end

    def edit
      @boarding.build_relations
    end

    def show; end

    def create
      parse_picture_params(:boarding)
      @boarding = if super_admin?
                    Boarding.new(boarding_params)
                  else
                    current_admin.build_boarding(boarding_params)
                  end
      if @boarding.save
        flash[:success] = 'Boarding was successfully created'
        redirect_to admin_panel_boarding_path(@boarding)
      else
        @boarding.build_relations
        render :new
      end
    end

    def update
      parse_picture_params(:boarding)
      if @boarding.update(boarding_params)
        flash[:success] = 'Boarding was successfully updated'
        redirect_to admin_panel_boardings_path
      else
        @boarding.build_relations
        render :edit
      end
    end

    def destroy
      if @boarding.destroy
        respond_to do |format|
          format.html do
            flash[:success] = 'Boarding was deleted'
            redirect_to admin_panel_boardings_path
          end
          format.json { render json: { message: 'Boarding was deleted' } }
        end
      else
        respond_to do |format|
          format.html do
            flash[:error] = "Boarding wasn't deleted"
            render :show
          end
          format.json { render json: { errors: @boarding.errors.full_messages }, status: 422 }
        end
      end
    end

    def new_service_type
      @service_type = @boarding.service_types.new
      @service_type.build_services_relation
      render 'admin_panel/service_types/new'
    end

    private

    def set_boarding
      @boarding = Boarding.find_by(id: params[:id])
    end

    def can_create?
      authorize :boarding, :create?
    end

    def can_update?
      authorize @boarding, :update?
    end

    def boarding_params
      params.require(:boarding).permit(:admin_id, :name, :email, :picture, :mobile_number, :website, :description,
                                       :picture_cache, service_option_details_attributes: service_option_params,
                                                       location_attributes: location_params,
                                                       schedule_attributes: schedule_params,
                                                       pictures_attributes: picture_params)
    end

    def filter_boardings
      filtered_boardings = filter_and_pagination_query.filter
      boardings = ::AdminPanel::BoardingDecorator.decorate_collection(filtered_boardings)
      serialized_boardings = ActiveModel::Serializer::CollectionSerializer.new(
        boardings, serializer: ::AdminPanel::BoardingFilterSerializer, adapter: :attributes
      )

      render json: { draw: params[:draw], recordsTotal: Boarding.count,
                     recordsFiltered: filtered_boardings.total_count, data: serialized_boardings }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('Boarding', params)
    end
  end
end

module AdminPanel
  class DayCareCentresController < AdminPanelController
    before_action :set_day_care_centre, except: %i[index new create]
    before_action :can_create?, only: %i[new create]
    before_action :can_update?, except: %i[index new create]

    def index
      authorize_super_admin
      respond_to do |format|
        format.html {}
        format.json { filter_day_care_centres }
      end
    end

    def new
      @day_care_centre = DayCareCentre.new
      @day_care_centre.build_location
      @day_care_centre.build_schedule
    end

    def edit; end

    def show; end

    def create
      @day_care_centre = if super_admin?
                           DayCareCentre.new(day_care_centre_params)
                         else
                           current_admin.build_day_care_centre(day_care_centre_params)
                         end
      if @day_care_centre.save
        flash[:success] = 'DayCare Centre was successfully created'
        redirect_to admin_panel_day_care_centre_path(@day_care_centre)
      else
        render :new
      end
    end

    def update
      if @day_care_centre.update(day_care_centre_params)
        flash[:success] = 'DayCare Centre was successfully updated'
        redirect_to admin_panel_day_care_centres_path
      else
        render :edit
      end
    end

    def destroy
      if @day_care_centre.destroy
        respond_to do |format|
          format.html do
            flash[:success] = 'DayCare Centre was deleted'
            redirect_to admin_panel_day_care_centres_path
          end
          format.json { render json: { message: 'DayCare Centre was deleted' }, status: 200 }
        end
      else
        respond_to do |format|
          format.html do
            flash[:error] = "DayCare Centre wasn't deleted"
            render :show
          end
          format.json { render json: { errors: @day_care_centre.errors.full_messages }, status: 422 }
        end
      end
    end

    def new_service_type
      @service_type = @day_care_centre.service_types.new
      @service_type.default_set
      render 'admin_panel/service_types/new'
    end

    private

    def set_day_care_centre
      @day_care_centre = DayCareCentre.find_by(id: params[:id])
    end

    def can_create?
      authorize :day_care_centre, :create?
    end

    def can_update?
      authorize @day_care_centre, :update?
    end

    def day_care_centre_params
      params.require(:day_care_centre).permit(:admin_id, :name, :email, :picture, :mobile_number, :website,
                                              :description,
                                              service_option_ids: [], location_attributes: location_params,
                                              schedule_attributes: schedule_params)
    end

    def filter_day_care_centres
      filtered_day_care_centres = filter_and_pagination_query.filter
      day_care_centres = ::AdminPanel::DayCareCentreDecorator.decorate_collection(filtered_day_care_centres)
      serialized_day_care_centres = ActiveModel::Serializer::CollectionSerializer.new(
        day_care_centres, serializer: ::AdminPanel::DayCareCentreFilterSerializer, adapter: :attributes
      )

      render json: { draw: params[:draw], recordsTotal: DayCareCentre.count,
                     recordsFiltered: filtered_day_care_centres.total_count, data: serialized_day_care_centres }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('DayCareCentre', params)
    end
  end
end

module AdminPanel
  class GroomingCentresController < AdminPanelController
    before_action :set_grooming_centre, except: %i[index new create]
    before_action :can_create?, only: %i[new create]
    before_action :can_update?, except: %i[index new create]

    def index
      respond_to do |format|
        format.html {}
        format.json { filter_grooming_centres }
      end
    end

    def new
      @grooming_centre = GroomingCentre.new
      @grooming_centre.build_location
      @grooming_centre.build_schedule
    end

    def edit; end

    def show; end

    def create
      @grooming_centre = if super_admin?
                           GroomingCentre.new(grooming_centre_params)
                         else
                           current_admin.build_grooming_centre(grooming_centre_params)
                         end
      if @grooming_centre.save
        flash[:success] = 'Grooming Centre was successfully created'
        redirect_to admin_panel_grooming_centre_path(@grooming_centre)
      else
        render :new
      end
    end

    def update
      if @grooming_centre.update(grooming_centre_params)
        flash[:success] = 'Grooming Centre was successfully updated'
        redirect_to admin_panel_grooming_centres_path
      else
        render :edit
      end
    end

    def destroy
      if @groming_centre.destroy
        respond_to do |format|
          format.html do
            flash[:success] = 'Grooming Centre was deleted'
            redirect_to admin_panel_groming_centres_path
          end
          format.json { render json: { message: 'Grooming Centre was deleted' }, status: 200 }
        end
      else
        respond_to do |format|
          format.html do
            flash[:error] = "Grooming Centre wasn't deleted"
            render :show
          end
          format.json { render json: { errors: @groming_centre.errors.full_messages }, status: 422 }
        end
      end
    end

    def new_service_type
      @service_type = @grooming_centre.service_types.new
      @service_type.default_set
      render 'admin_panel/service_types/new'
    end

    private

    def set_grooming_centre
      @grooming_centre = GroomingCentre.find_by(id: params[:id])
    end

    def can_create?
      authorize :grooming_centre, :create?
    end

    def can_update?
      authorize @grooming_centre, :update?
    end

    def grooming_centre_params
      params.require(:grooming_centre).permit(:admin_id, :name, :email, :picture, :mobile_number, :website,
                                              :description,
                                              service_option_ids: [], location_attributes: location_params,
                                              schedule_attributes: schedule_params)
    end

    def filter_grooming_centres
      filtered_grooming_centres = filter_and_pagination_query.filter
      grooming_centres = ::AdminPanel::GroomingCentreDecorator.decorate_collection(filtered_grooming_centres)
      serialized_grooming_centres = ActiveModel::Serializer::CollectionSerializer.new(
        grooming_centres, serializer: ::AdminPanel::GroomingCentreFilterSerializer, adapter: :attributes
      )

      render json: { draw: params[:draw], recordsTotal: GroomingCentre.count,
                     recordsFiltered: filtered_grooming_centres.total_count, data: serialized_grooming_centres }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('GroomingCentre', params)
    end
  end
end

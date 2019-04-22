module AdminPanel
  class DiscountDomainsController < AdminPanelController
    before_action :authorize_super_admin
    before_action :set_domain, except: %i[index new create]

    def index
      respond_to do |format|
        format.html {}
        format.json { filter_domains }
      end
    end

    def new
      @domain = DiscountDomain.new
    end

    def create
      # @clinic = super_admin? ? Clinic.new(clinic_params) : current_admin.build_clinic(clinic_params)
      # if @clinic.save
      #   flash[:success] = 'Clinic was successfully created'
      #   redirect_to admin_panel_clinic_path(@clinic)
      # else
      #   render :new
      # end
    end

    def show; end

    def edit; end

    def update
      # if @clinic.update(clinic_params)
      #   flash[:success] = 'Clinic was successfully updated'
      #   redirect_to admin_panel_clinic_path(@clinic)
      # else
      #   render :edit
      # end
    end

    def destroy
      # if @clinic.destroy
      #   respond_to do |format|
      #     format.html do
      #       flash[:success] = 'Clinic was deleted'
      #       redirect_to admin_panel_clinics_path
      #     end
      #     format.js { render json: { message: 'Clinic was deleted' } }
      #   end
      # else
      #   respond_to do |format|
      #     format.html do
      #       flash[:error] = "Clinic wasn't deleted"
      #       render :show
      #     end
      #     format.js { render json: { errors: @clinic.errors.full_messages }, status: 422 }
      #   end
      # end
    end

    private

    def set_domain
      @domain = DiscountDomain.find_by(id: params[:id])
    end

    def domain_params
      # params.require(:clinic).permit(:admin_id, :name, :email, :picture, :mobile_number, :consultation_fee, :website,
      #                                :description, :is_emergency, :picture_cache,
      #                                specialization_ids: [], pet_type_ids: [], location_attributes: location_params,
      #                                schedule_attributes: schedule_params, pictures_attributes: picture_params)
    end

    def filter_domains
      filtered_domains = filter_and_pagination_query.filter
      domains = ::AdminPanel::DomainDecorator.decorate_collection(filtered_domains)
      serialized_domains = ActiveModel::Serializer::CollectionSerializer.new(
        domains, serializer: ::AdminPanel::DomainFilterSerializer, adapter: :attributes
      )
      render json: { draw: params[:draw], recordsTotal: DiscountDomain.count, recordsFiltered: filtered_domains.total_count,
                     data: serialized_domains }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('DiscountDomain', params)
    end
  end
end

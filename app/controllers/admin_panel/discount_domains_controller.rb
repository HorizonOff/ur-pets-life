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
      @discount_domain = DiscountDomain.new
    end

    def create
      @discount_domain = DiscountDomain.new(domain_params)
      if @discount_domain.save
        flash[:success] = 'Discount domain was successfully created'
        redirect_to admin_panel_discount_domains_path
      else
        render :new
      end
    end

    def show; end

    def edit; end

    def update
      if @discount_domain.update(domain_params)
        flash[:success] = 'Discount domain was successfully updated'
        redirect_to admin_panel_discount_domains_path
      else
        render :edit
      end
    end

    def destroy
      if @discount_domain.destroy
        flash[:success] = 'Discount domain was deleted'
        redirect_to admin_panel_discount_domains_path
      else
        flash[:error] = "Discount domain wasn't deleted"
        render :index
      end
    end

    private

    def set_domain
      @discount_domain = DiscountDomain.find_by(id: params[:id])
    end

    def domain_params
      params.require(:discount_domain).permit(:domain, :discount)
    end

    def filter_domains
      filtered_domains = filter_and_pagination_query.filter
      domains = ::AdminPanel::DiscountDomainDecorator.decorate_collection(filtered_domains)
      serialized_domains = ActiveModel::Serializer::CollectionSerializer.new(
        domains, serializer: ::AdminPanel::DiscountDomainFilterSerializer, adapter: :attributes
      )
      render json: { draw: params[:draw], recordsTotal: DiscountDomain.count, recordsFiltered: filtered_domains.total_count,
                     data: serialized_domains }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('DiscountDomain', params)
    end
  end
end

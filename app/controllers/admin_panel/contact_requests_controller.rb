module AdminPanel
  class ContactRequestsController < AdminPanelController
    before_action :authorize_super_admin_employee
    before_action :set_contact_request, except: :index
    before_action :view_contact_request, only: :show

    def index
      respond_to do |format|
        format.html {}
        format.json { filter_contact_requests }
      end
    end

    def show
      @contact_request = ::AdminPanel::ContactRequestDecorator.decorate(@contact_request)
    end

    def new_reply; end

    def send_reply
      ContactRequestMailer.send_reply(@contact_request, params[:message]).deliver if params[:message].present?
      @contact_request.update_attribute(:is_answered, true)

      redirect_to admin_panel_contact_request_path(@contact_request)
    end

    private

    def set_contact_request
      @contact_request = ContactRequest.find_by(id: params[:id])
    end

    def view_contact_request
      @contact_request.update_attribute(:is_viewed, true)
    end

    def filter_contact_requests
      filtered_contact_requests = filter_and_pagination_query.filter
      contact_requests = ::AdminPanel::ContactRequestDecorator.decorate_collection(filtered_contact_requests)
      serialized_contact_requests = ActiveModel::Serializer::CollectionSerializer.new(
        contact_requests, serializer: ::AdminPanel::ContactRequestFilterSerializer, adapter: :attributes
      )

      render json: { draw: params[:draw], recordsTotal: ContactRequest.count,
                     recordsFiltered: filtered_contact_requests.total_count, data: serialized_contact_requests }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('ContactRequest', params)
    end
  end
end

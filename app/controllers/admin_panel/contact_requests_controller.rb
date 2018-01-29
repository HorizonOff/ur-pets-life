module AdminPanel
  class ContactRequestsController < AdminPanelController
    before_action :set_contact_request, except: :index

    def index
      @contact_requests = ContactRequest.all
    end

    def show; end

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
  end
end

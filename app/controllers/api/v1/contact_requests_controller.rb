module Api
  module V1
    class ContactRequestsController < Api::BaseController
      def create
        contact_request = @user.contact_requests.new(contact_request_params)
        if contact_request.save
          render json: { message: 'Successfully created' }
          ContactRequestMailer.send_contact_request(contact_request).deliver
        else
          render_422(parse_errors_messages(contact_request))
        end
      end

      private

      def contact_request_params
        params.require(:contact_request).permit(:subject, :message)
      end
    end
  end
end

module Api
  module V1
    class ContactRequestsController < Api::BaseController
      skip_before_action :authenticate_user

      def create
        contact_request = ContactRequest.new(contact_request_params)
        contact_request.assign_attributes(email: @user.email, user: @user) if @user
        if contact_request.save
          render json: { message: 'Successfully created' }
          ContactRequestMailer.send_contact_request(contact_request).deliver
        else
          render_422(parse_errors_messages(contact_request))
        end
      end

      private

      def contact_request_params
        params.require(:contact_request).permit(:email, :subject, :message)
      end
    end
  end
end

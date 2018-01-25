module Api
  module V1
    class ContactRequestsController < Api::BaseController
      def create
        @contact_request = @user.contact_requests.new(contact_request_params)
        if @contact_request.save
          render json: { message: 'Successfully created' }, status: 200
          ContactRequestMailer.send_contact_request(@contact_request).deliver
        else
          render json: { message: @contact_request.errors.full_messages }, status: 422
        end
      end

      private

      def contact_request_params
        params.permit(:subject, :message)
      end
    end
  end
end
